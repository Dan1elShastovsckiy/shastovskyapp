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
import hashlib
import json
from datetime import datetime, timezone
from pathlib import Path, PurePosixPath


SITE_ROOT = Path("/var/www/shastovsky")
RELEASES = SITE_ROOT / "releases"
CURRENT = SITE_ROOT / "current"
PREVIOUS = SITE_ROOT / ".previous"
LOCK_FILE = Path("/run/lock/shastovsky-deploy.lock")
MAX_FILES = 100_000
MAX_UNPACKED_BYTES = 2 * 1024 * 1024 * 1024
VERIFICATION_FILE = re.compile(r"^(?:google|yandex)[A-Za-z0-9_-]+\.html$", re.I)
SERVER_FILES = {"robots.txt", "sitemap.xml"}
MANIFEST_FILENAME = ".shastovsky-manifest.json"


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


def is_server_managed_path(relative: PurePosixPath) -> bool:
    if relative.parts and relative.parts[0] == "uploads":
        return True
    return len(relative.parts) == 1 and (
        relative.name in SERVER_FILES or VERIFICATION_FILE.fullmatch(relative.name) is not None
    )


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as source:
        while chunk := source.read(1024 * 1024):
            digest.update(chunk)
    return digest.hexdigest()


def collect_build_manifest(root: Path) -> dict[str, str]:
    validate_server_data(root)
    result: dict[str, str] = {}
    for current_root, directories, files in os.walk(root, followlinks=False):
        current = Path(current_root)
        relative_dir = PurePosixPath(current.relative_to(root).as_posix())
        if relative_dir.parts and relative_dir.parts[0] == "uploads":
            directories[:] = []
            continue
        for name in files:
            path = current / name
            relative = PurePosixPath(path.relative_to(root).as_posix())
            if is_server_managed_path(relative):
                continue
            result[relative.as_posix()] = sha256_file(path)
    return result


def manifest() -> None:
    if os.geteuid() != 0:
        raise DeployError("The receiver must run as root")
    current = read_current()
    result = {"version": 1, "files": collect_build_manifest(current)}
    print(json.dumps(result, sort_keys=True, separators=(",", ":")), flush=True)


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


def refresh_server_managed_data(old_release: Path, candidate: Path) -> None:
    """Refresh mutable server-owned files immediately before release activation."""
    for name in SERVER_FILES:
        (candidate / name).unlink(missing_ok=True)
    for path in candidate.iterdir():
        if VERIFICATION_FILE.fullmatch(path.name):
            path.unlink()
    uploads = candidate / "uploads"
    if uploads.is_dir() and not uploads.is_symlink():
        shutil.rmtree(uploads)
    elif uploads.exists() or uploads.is_symlink():
        uploads.unlink()
    copy_server_managed_data(old_release, candidate)


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

    php_files = [
        str(path.relative_to(build))
        for path in build.rglob("*")
        if path.is_file()
        and not is_server_managed_path(PurePosixPath(path.relative_to(build).as_posix()))
        and re.search(r"\.php(?:$|\.)", path.name, re.I)
    ]
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


def validate_manifest_files(files: object) -> dict[str, str]:
    if not isinstance(files, dict) or len(files) > MAX_FILES:
        raise DeployError("The deployment manifest has an invalid file list")

    result: dict[str, str] = {}
    for name, digest in files.items():
        if not isinstance(name, str) or not isinstance(digest, str):
            raise DeployError("The deployment manifest contains an invalid entry")
        relative = PurePosixPath(name)
        if (
            not name
            or relative.is_absolute()
            or relative.as_posix() != name
            or "\\" in name
            or any(part in ("..", "") for part in relative.parts)
            or name == MANIFEST_FILENAME
            or is_server_managed_path(relative)
            or re.fullmatch(r"[0-9a-f]{64}", digest) is None
        ):
            raise DeployError(f"Invalid deployment manifest path or digest: {name!r}")
        result[name] = digest

    names = set(result)
    for name in names:
        for parent in PurePosixPath(name).parents:
            if parent != PurePosixPath(".") and parent.as_posix() in names:
                raise DeployError("The deployment manifest has conflicting file paths")
    return result


def hardlink_file(source: str | os.PathLike[str], destination: str | os.PathLike[str]) -> str:
    os.link(source, destination)
    return os.fspath(destination)


def deploy_delta(stream=None) -> None:
    if os.geteuid() != 0:
        raise DeployError("The receiver must run as root")
    if stream is None:
        stream = sys.stdin.buffer

    old_release = read_current()
    old_previous = read_previous()
    stage = Path(tempfile.mkdtemp(prefix=".incoming-", dir=SITE_ROOT))
    candidate: Path | None = None

    try:
        delta = stage / "delta"
        delta.mkdir(mode=0o755)
        extract_build(stream, delta)

        manifest_path = delta / MANIFEST_FILENAME
        if not manifest_path.is_file() or manifest_path.stat().st_size > 32 * 1024 * 1024:
            raise DeployError("The deployment archive has no valid manifest")
        try:
            payload = json.loads(manifest_path.read_text(encoding="utf-8"))
        except (UnicodeDecodeError, json.JSONDecodeError) as error:
            raise DeployError("The deployment manifest is not valid JSON") from error
        if (
            not isinstance(payload, dict)
            or type(payload.get("version")) is not int
            or payload["version"] != 1
        ):
            raise DeployError("Unsupported deployment manifest version")
        expected_files = validate_manifest_files(payload.get("files"))

        staged_files: dict[str, Path] = {}
        for path in delta.rglob("*"):
            if path.is_symlink():
                raise DeployError(f"Unsupported delta entry: {path.relative_to(delta)}")
            if not path.is_file():
                continue
            relative = path.relative_to(delta).as_posix()
            if relative == MANIFEST_FILENAME:
                continue
            if relative not in expected_files:
                raise DeployError(f"The delta contains an unlisted file: {relative}")
            if sha256_file(path) != expected_files[relative]:
                raise DeployError(f"The delta file failed its hash check: {relative}")
            staged_files[relative] = path

        old_files = collect_build_manifest(old_release)
        for name, digest in expected_files.items():
            if name in staged_files:
                continue
            if old_files.get(name) != digest:
                raise DeployError(f"The delta is missing a changed file: {name}")

        validate_server_data(old_release)
        timestamp = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")
        candidate = RELEASES / f"release-{timestamp}-{os.getpid()}"
        # Releases live on the same filesystem. Hard links make the candidate
        # cheap to create; changed paths are unlinked before replacement below.
        shutil.copytree(old_release, candidate, copy_function=hardlink_file)

        for name in old_files.keys() - expected_files.keys():
            target = candidate.joinpath(*PurePosixPath(name).parts)
            if not target.is_file() or target.is_symlink():
                raise DeployError(f"The active release has an unexpected file: {name}")
            target.unlink()

        for root, directories, _ in os.walk(candidate, topdown=False):
            for name in directories:
                directory = Path(root) / name
                relative = PurePosixPath(directory.relative_to(candidate).as_posix())
                if is_server_managed_path(relative):
                    continue
                try:
                    directory.rmdir()
                except OSError:
                    pass

        for name, source in staged_files.items():
            target = candidate.joinpath(*PurePosixPath(name).parts)
            if target.is_dir() and not target.is_symlink():
                shutil.rmtree(target)
            else:
                target.unlink(missing_ok=True)
            target.parent.mkdir(parents=True, exist_ok=True, mode=0o755)
            shutil.copy2(source, target)
            os.chmod(target, 0o644)

        validate_build(candidate)
        refresh_server_managed_data(old_release, candidate)
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
        if requested == "deploy-delta":
            os.execv(
                "/usr/bin/sudo",
                ["sudo", "-n", "/usr/local/sbin/shastovsky-deploy", "--deploy-delta"],
            )
        if requested == "manifest":
            os.execv(
                "/usr/bin/sudo",
                ["sudo", "-n", "/usr/local/sbin/shastovsky-deploy", "--manifest"],
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
        log("only deploy, deploy-delta, manifest, rollback and status commands are allowed")
        return 64

    if sys.argv[1:] == []:
        operation = deploy
    elif sys.argv[1:] == ["--rollback"]:
        operation = rollback
    elif sys.argv[1:] == ["--deploy-delta"]:
        operation = deploy_delta
    elif sys.argv[1:] == ["--manifest"]:
        operation = manifest
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
