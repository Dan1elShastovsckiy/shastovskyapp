#!/usr/bin/env python3
"""Restricted, atomic receiver for the shastovsky.com static site."""

from __future__ import annotations

import os
import re
import shutil
import subprocess
import sys
import tarfile
import tempfile
import fcntl
import stat
import urllib.error
import urllib.parse
import urllib.request
import zipfile
from datetime import datetime, timezone
from pathlib import Path, PurePosixPath


SITE_ROOT = Path("/var/www/shastovsky")
RELEASES = SITE_ROOT / "releases"
CURRENT = SITE_ROOT / "current"
PREVIOUS = SITE_ROOT / ".previous"
LOCK_FILE = Path("/run/lock/shastovsky-deploy.lock")
MAX_FILES = 100_000
MAX_UNPACKED_BYTES = 2 * 1024 * 1024 * 1024
MAX_ARTIFACT_BYTES = 1024 * 1024 * 1024
MAX_ARTIFACT_URL_BYTES = 16 * 1024
VERIFICATION_FILE = re.compile(r"^(?:google|yandex)[A-Za-z0-9_-]+\.html$", re.I)
SERVER_FILES = {"robots.txt", "sitemap.xml"}
ARTIFACT_FILENAME = "website.tar.gz"


class DeployError(RuntimeError):
    pass


def log(message: str) -> None:
    print(f"shastovsky-deploy: {message}", flush=True)


def run(command: list[str], *, timeout: int = 30) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        command,
        check=True,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        timeout=timeout,
    )


def read_current() -> Path:
    if not CURRENT.is_symlink():
        raise DeployError(f"{CURRENT} is not an active release symlink")
    target = CURRENT.resolve(strict=True)
    if target.parent != RELEASES or not target.is_dir():
        raise DeployError("The active release points outside the managed releases directory")
    return target


def set_current(target: Path) -> None:
    resolved = target.resolve(strict=True)
    if resolved.parent != RELEASES or not resolved.is_dir():
        raise DeployError("Refusing to activate a path outside the managed releases directory")
    temporary_link = SITE_ROOT / f".current-{os.getpid()}"
    temporary_link.unlink(missing_ok=True)
    temporary_link.symlink_to(resolved.relative_to(SITE_ROOT))
    os.replace(temporary_link, CURRENT)


def read_previous() -> Path | None:
    if not PREVIOUS.is_file():
        return None
    target = (SITE_ROOT / PREVIOUS.read_text(encoding="utf-8").strip()).resolve()
    if target.parent != RELEASES or not target.is_dir():
        return None
    return target


def write_previous(target: Path) -> None:
    temporary = SITE_ROOT / f".previous-{os.getpid()}"
    temporary.write_text(str(target.relative_to(SITE_ROOT)), encoding="utf-8")
    os.chmod(temporary, 0o600)
    os.replace(temporary, PREVIOUS)


def extract_build(stream, destination: Path) -> None:
    seen: set[PurePosixPath] = set()
    count = 0
    total_size = 0

    with tarfile.open(fileobj=stream, mode="r|gz") as archive:
        for member in archive:
            count += 1
            if count > MAX_FILES:
                raise DeployError("The upload contains too many archive entries")

            relative = PurePosixPath(member.name)
            if member.name in ("", ".", "./"):
                continue
            if (
                relative.is_absolute()
                or "\\" in member.name
                or any(part in ("..", "") for part in relative.parts)
            ):
                raise DeployError(f"Unsafe archive path: {member.name!r}")
            if not (member.isdir() or member.isfile()):
                raise DeployError(f"Unsupported archive entry: {member.name!r}")
            if relative in seen:
                raise DeployError(f"Duplicate archive path: {member.name!r}")
            seen.add(relative)

            target = destination.joinpath(*relative.parts)
            if member.isdir():
                target.mkdir(parents=True, exist_ok=True, mode=0o755)
                os.chmod(target, 0o755)
                continue

            if member.size < 0:
                raise DeployError(f"Invalid file size: {member.name!r}")
            total_size += member.size
            if total_size > MAX_UNPACKED_BYTES:
                raise DeployError("The uncompressed upload exceeds the 2 GiB limit")

            target.parent.mkdir(parents=True, exist_ok=True, mode=0o755)
            source = archive.extractfile(member)
            if source is None:
                raise DeployError(f"Could not read archive file: {member.name!r}")
            with source, target.open("xb") as output:
                shutil.copyfileobj(source, output, length=1024 * 1024)
            os.chmod(target, 0o644)


def validate_server_data(source: Path) -> None:
    for root, directories, files in os.walk(source, followlinks=False):
        for name in directories + files:
            path = Path(root) / name
            mode = path.lstat().st_mode
            if not (stat.S_ISDIR(mode) or stat.S_ISREG(mode)):
                raise DeployError(f"Unsupported server-managed entry: {path}")


def copy_server_managed_data(old_release: Path, candidate: Path) -> None:
    for name in SERVER_FILES:
        source = old_release / name
        if not source.exists():
            continue
        if not stat.S_ISREG(source.lstat().st_mode):
            raise DeployError(f"Expected a regular server-managed file: {source}")
        shutil.copy2(source, candidate / name)

    for source in old_release.iterdir():
        if not VERIFICATION_FILE.fullmatch(source.name):
            continue
        if not stat.S_ISREG(source.lstat().st_mode):
            raise DeployError(f"Expected a regular domain verification file: {source}")
        shutil.copy2(source, candidate / source.name)

    uploads = old_release / "uploads"
    if uploads.exists():
        if not stat.S_ISDIR(uploads.lstat().st_mode):
            raise DeployError("The server-managed uploads path is not a directory")
        validate_server_data(uploads)
        destination = candidate / "uploads"
        if destination.exists():
            if destination.is_dir() and not destination.is_symlink():
                shutil.rmtree(destination)
            else:
                destination.unlink()
        shutil.copytree(uploads, destination, copy_function=shutil.copy2)


def validate_build(build: Path) -> None:
    required = (
        build / "index.html",
        build / "flutter_bootstrap.js",
        build / "main.dart.js",
        build / "about" / "index.html",
        build / "georgia-part1" / "index.html",
    )
    missing = [str(path.relative_to(build)) for path in required if not path.is_file()]
    if missing:
        raise DeployError("Required build files are missing: " + ", ".join(missing))

    php_files = [str(path.relative_to(build)) for path in build.rglob("*")
                 if path.is_file() and re.search(r"\.php(?:$|\.)", path.name, re.I)]
    if php_files:
        raise DeployError("Refusing to publish PHP files: " + ", ".join(php_files[:10]))

    article = (build / "georgia-part1" / "index.html").read_text(
        encoding="utf-8", errors="replace"
    )
    if "https://pactors.io/countries/georgia" not in article:
        raise DeployError("The Georgia article prerender does not contain the requested link")


def smoke_test() -> None:
    checks = (
        ("/", None),
        ("/about/", None),
        ("/georgia-part1/", "https://pactors.io/countries/georgia"),
        ("/main.dart.js", None),
    )
    for path, expected in checks:
        result = run(
            [
                "/usr/bin/curl",
                "--fail",
                "--silent",
                "--show-error",
                "--location",
                "--max-time",
                "30",
                "--resolve",
                "shastovsky.com:443:127.0.0.1",
                f"https://shastovsky.com{path}",
            ],
            timeout=35,
        )
        if expected and expected not in result.stdout:
            raise DeployError(f"The local production check failed for {path}")

    response = subprocess.run(
        [
            "/usr/bin/curl",
            "--silent",
            "--show-error",
            "--output",
            "/dev/null",
            "--write-out",
            "%{http_code}",
            "--max-time",
            "30",
            "--resolve",
            "shastovsky.com:443:127.0.0.1",
            "https://shastovsky.com/upload.php",
        ],
        check=True,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        timeout=35,
    )
    if response.stdout.strip() != "403":
        raise DeployError("The exposed PHP endpoint is not returning 403")


def cleanup_releases(current: Path, previous: Path) -> None:
    protected = {current.resolve(), previous.resolve()}
    releases = sorted(
        (path for path in RELEASES.iterdir() if path.is_dir() and not path.is_symlink()),
        key=lambda path: path.stat().st_mtime,
        reverse=True,
    )
    for release in releases:
        if release.resolve() not in protected:
            shutil.rmtree(release)


def deploy(stream=None) -> None:
    if os.geteuid() != 0:
        raise DeployError("The receiver must run as root")
    if stream is None:
        stream = sys.stdin.buffer
    old_release = read_current()
    old_previous = read_previous()
    stage = Path(tempfile.mkdtemp(prefix=".incoming-", dir=SITE_ROOT))
    candidate: Path | None = None

    try:
        build = stage / "build"
        build.mkdir(mode=0o755)
        extract_build(stream, build)
        validate_build(build)

        timestamp = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")
        candidate = RELEASES / f"release-{timestamp}-{os.getpid()}"
        shutil.copytree(build, candidate)
        copy_server_managed_data(old_release, candidate)

        # This file was served as source because Nginx had no PHP handler.
        (candidate / "upload.php").unlink(missing_ok=True)
        (candidate / "upload.php.save").unlink(missing_ok=True)

        uploads = candidate / "uploads"
        if uploads.is_dir():
            shutil.chown(uploads, user="www-data", group="www-data")
            for root, directories, files in os.walk(uploads):
                for name in directories + files:
                    shutil.chown(Path(root) / name, user="www-data", group="www-data")

        write_previous(old_release)

        set_current(candidate)
        try:
            smoke_test()
        except Exception:
            set_current(old_release)
            if old_previous:
                write_previous(old_previous)
            else:
                PREVIOUS.unlink(missing_ok=True)
            raise

        cleanup_releases(candidate, old_release)
        log(f"activated {candidate.name}; previous release is {old_release.name}")
    finally:
        shutil.rmtree(stage, ignore_errors=True)
        if candidate and candidate.exists() and CURRENT.resolve() != candidate.resolve():
            shutil.rmtree(candidate, ignore_errors=True)


def validate_artifact_url(url: str) -> None:
    if len(url.encode("utf-8")) > MAX_ARTIFACT_URL_BYTES:
        raise DeployError("The artifact URL is too long")
    if not url or any(ord(char) < 0x21 or ord(char) > 0x7E for char in url):
        raise DeployError("The artifact URL contains invalid characters")
    parsed = urllib.parse.urlsplit(url)
    hostname = (parsed.hostname or "").lower()
    if (
        parsed.scheme != "https"
        or not hostname.endswith(".blob.core.windows.net")
        or parsed.username is not None
        or parsed.password is not None
        or parsed.port is not None
        or not parsed.path
        or not parsed.query
        or parsed.fragment
    ):
        raise DeployError("The artifact URL is not a valid HTTPS GitHub artifact URL")


def download_artifact(url: str, destination) -> None:
    validate_artifact_url(url)
    request = urllib.request.Request(
        url,
        headers={"User-Agent": "shastovsky-deploy/1.0"},
    )

    class NoRedirect(urllib.request.HTTPRedirectHandler):
        def redirect_request(self, req, fp, code, msg, headers, newurl):
            return None

    opener = urllib.request.build_opener(NoRedirect)
    try:
        response = opener.open(request, timeout=60)
    except (OSError, urllib.error.URLError) as error:
        raise DeployError("Could not download the GitHub Actions artifact") from error

    with response:
        final_url = urllib.parse.urlsplit(response.geturl())
        if (
            response.status != 200
            or final_url.scheme != "https"
            or final_url.hostname != urllib.parse.urlsplit(url).hostname
        ):
            raise DeployError("The artifact download returned an unexpected response")

        content_length = response.headers.get("Content-Length")
        if content_length is not None:
            try:
                expected_size = int(content_length)
            except ValueError as error:
                raise DeployError("The artifact download has an invalid content length") from error
            if expected_size < 1 or expected_size > MAX_ARTIFACT_BYTES:
                raise DeployError("The artifact download size is outside the allowed limit")
        else:
            expected_size = None

        received = 0
        while True:
            chunk = response.read(1024 * 1024)
            if not chunk:
                break
            received += len(chunk)
            if received > MAX_ARTIFACT_BYTES:
                raise DeployError("The artifact download exceeds the 1 GiB limit")
            destination.write(chunk)

        if received == 0 or (expected_size is not None and received != expected_size):
            raise DeployError("The artifact download was incomplete")


def deploy_artifact_url() -> None:
    if os.geteuid() != 0:
        raise DeployError("The receiver must run as root")
    raw_url = sys.stdin.buffer.readline(MAX_ARTIFACT_URL_BYTES + 1)
    if len(raw_url) > MAX_ARTIFACT_URL_BYTES or not raw_url.endswith(b"\n"):
        raise DeployError("A single artifact URL line is required")
    try:
        url = raw_url[:-1].decode("ascii")
    except UnicodeDecodeError as error:
        raise DeployError("The artifact URL is not valid ASCII") from error
    if sys.stdin.buffer.read(1):
        raise DeployError("Unexpected data after the artifact URL")

    with tempfile.TemporaryFile(prefix="shastovsky-artifact-", suffix=".zip", dir="/tmp") as zip_file:
        download_artifact(url, zip_file)
        zip_file.seek(0)

        with zipfile.ZipFile(zip_file) as artifact:
            entries = artifact.infolist()
            if len(entries) != 1:
                raise DeployError("The GitHub artifact must contain exactly one file")
            entry = entries[0]
            mode = (entry.external_attr >> 16) & 0o170000
            if (
                entry.filename != ARTIFACT_FILENAME
                or entry.is_dir()
                or mode not in (0, stat.S_IFREG)
                or entry.file_size < 1
                or entry.file_size > MAX_ARTIFACT_BYTES
            ):
                raise DeployError("The GitHub artifact does not contain the expected site archive")

            with artifact.open(entry) as source, tempfile.TemporaryFile(
                prefix="shastovsky-site-", suffix=".tar.gz", dir="/tmp"
            ) as site_archive:
                shutil.copyfileobj(source, site_archive, length=1024 * 1024)
                site_archive.seek(0)
                deploy(site_archive)


def rollback() -> None:
    if os.geteuid() != 0:
        raise DeployError("The receiver must run as root")
    current = read_current()
    target = read_previous()
    if target is None:
        raise DeployError("No previous release is recorded")
    if target == current:
        raise DeployError("The recorded previous release is invalid")

    write_previous(current)
    set_current(target)
    try:
        smoke_test()
    except Exception:
        set_current(current)
        write_previous(target)
        raise
    log(f"rolled back to {target.name}")


def status() -> None:
    if os.geteuid() != 0:
        raise DeployError("The receiver must run as root")
    current = read_current()
    log(f"active release: {current.name}")
    if PREVIOUS.is_file():
        log(f"previous release: {PREVIOUS.read_text(encoding='utf-8').strip()}")


def main() -> int:
    if os.geteuid() != 0:
        requested = os.environ.get("SSH_ORIGINAL_COMMAND", "")
        if requested == "deploy":
            os.execv("/usr/bin/sudo", ["sudo", "-n", "/usr/local/sbin/shastovsky-deploy"])
        if requested == "deploy-url":
            os.execv(
                "/usr/bin/sudo",
                ["sudo", "-n", "/usr/local/sbin/shastovsky-deploy", "--deploy-url"],
            )
        if requested == "rollback":
            os.execv(
                "/usr/bin/sudo",
                ["sudo", "-n", "/usr/local/sbin/shastovsky-deploy", "--rollback"],
            )
        if requested == "status":
            os.execv(
                "/usr/bin/sudo",
                ["sudo", "-n", "/usr/local/sbin/shastovsky-deploy", "--status"],
            )
        log("only deploy, deploy-url, rollback and status commands are allowed")
        return 64

    if sys.argv[1:] == []:
        operation = deploy
    elif sys.argv[1:] == ["--rollback"]:
        operation = rollback
    elif sys.argv[1:] == ["--deploy-url"]:
        operation = deploy_artifact_url
    elif sys.argv[1:] == ["--status"]:
        operation = status
    else:
        log("invalid receiver arguments")
        return 64

    lock_descriptor = os.open(LOCK_FILE, os.O_CREAT | os.O_RDWR, 0o600)
    try:
        fcntl.flock(lock_descriptor, fcntl.LOCK_EX)
        operation()
    finally:
        os.close(lock_descriptor)
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except Exception as error:
        log(str(error))
        sys.exit(1)
