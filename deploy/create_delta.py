#!/usr/bin/env python3
"""Package only build files that differ from the active production release."""

from __future__ import annotations

import argparse
import hashlib
import io
import json
import os
import re
import sys
import tarfile
from pathlib import Path, PurePosixPath


MANIFEST_FILENAME = ".shastovsky-manifest.json"
SERVER_FILES = {"robots.txt", "sitemap.xml"}
VERIFICATION_FILE = re.compile(r"^(?:google|yandex)[A-Za-z0-9_-]+\.html$", re.I)
MAX_FILES = 100_000


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


def validate_path(name: str) -> str:
    relative = PurePosixPath(name)
    if (
        not name
        or relative.is_absolute()
        or relative.as_posix() != name
        or "\\" in name
        or any(part in ("..", "") for part in relative.parts)
        or name == MANIFEST_FILENAME
        or is_server_managed_path(relative)
    ):
        raise ValueError(f"Unsafe or reserved build path: {name!r}")
    return name


def read_baseline(path: Path) -> dict[str, str]:
    payload = json.loads(path.read_text(encoding="utf-8"))
    if (
        not isinstance(payload, dict)
        or type(payload.get("version")) is not int
        or payload["version"] != 1
        or not isinstance(payload.get("files"), dict)
        or len(payload["files"]) > MAX_FILES
    ):
        raise ValueError("Production returned an unsupported file manifest")

    result: dict[str, str] = {}
    for name, digest in payload["files"].items():
        if not isinstance(name, str) or not isinstance(digest, str):
            raise ValueError("Production manifest contains an invalid entry")
        validate_path(name)
        if re.fullmatch(r"[0-9a-f]{64}", digest) is None:
            raise ValueError(f"Production manifest has an invalid hash for {name!r}")
        result[name] = digest
    return result


def collect_build(source: Path) -> dict[str, Path]:
    if not source.is_dir():
        raise ValueError(f"Build directory does not exist: {source}")

    result: dict[str, Path] = {}
    for root, directories, filenames in os.walk(source, followlinks=False):
        current = Path(root)
        for name in directories:
            if (current / name).is_symlink():
                raise ValueError(f"Build contains a symbolic link: {current / name}")
        for name in filenames:
            path = current / name
            if path.is_symlink() or not path.is_file():
                raise ValueError(f"Build contains a non-regular file: {path}")
            relative = path.relative_to(source).as_posix()
            validate_path(relative)
            if relative in result:
                raise ValueError(f"Build contains a duplicate path: {relative}")
            result[relative] = path
            if len(result) > MAX_FILES:
                raise ValueError("Build contains too many files")
    return result


def add_manifest(archive: tarfile.TarFile, payload: bytes) -> None:
    info = tarfile.TarInfo(MANIFEST_FILENAME)
    info.size = len(payload)
    info.mode = 0o644
    info.mtime = 0
    archive.addfile(info, io.BytesIO(payload))


def create_delta(source: Path, baseline_path: Path, output: Path) -> tuple[int, int]:
    baseline = read_baseline(baseline_path)
    build = collect_build(source)
    hashes = {name: sha256_file(path) for name, path in build.items()}
    changed = [name for name in sorted(build) if baseline.get(name) != hashes[name]]
    payload = json.dumps(
        {"version": 1, "files": hashes},
        sort_keys=True,
        separators=(",", ":"),
    ).encode("utf-8")

    output.parent.mkdir(parents=True, exist_ok=True)
    with tarfile.open(output, mode="w:gz", compresslevel=6) as archive:
        add_manifest(archive, payload)
        for name in changed:
            path = build[name]
            info = archive.gettarinfo(str(path), arcname=name)
            with path.open("rb") as source_file:
                archive.addfile(info, source_file)
    return len(changed), output.stat().st_size


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source", type=Path, required=True)
    parser.add_argument("--baseline", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    try:
        changed, size = create_delta(args.source, args.baseline, args.output)
    except (OSError, ValueError, json.JSONDecodeError) as error:
        print(f"create-delta: {error}", file=sys.stderr)
        return 1
    print(f"Prepared {changed} changed files ({size} bytes).")
    return 0


if __name__ == "__main__":
    sys.exit(main())
