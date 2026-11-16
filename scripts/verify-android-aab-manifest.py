#!/usr/bin/env python3
"""Verify every Android App Bundle module manifest using Google's bundletool."""

import argparse
import subprocess
import sys
import zipfile
import xml.etree.ElementTree as ET
from pathlib import Path

ANDROID_NS = "{http://schemas.android.com/apk/res/android}"
EXPECTED_PACKAGE = "com.orvika.app"
EXPECTED_PERMISSIONS = {
    "android.permission.CAMERA",
    "android.permission.INTERNET",
}


def module_names(bundle_path: Path) -> list[str]:
    with zipfile.ZipFile(bundle_path) as bundle:
        modules = sorted({
            name.split("/", 1)[0]
            for name in bundle.namelist()
            if name.endswith("/manifest/AndroidManifest.xml")
        })
    if "base" not in modules:
        raise ValueError("AAB does not contain the required base module manifest")
    return modules


def read_module_manifest(bundletool: Path, bundle_path: Path, module: str) -> ET.Element:
    result = subprocess.run(
        [
            "java", "-jar", str(bundletool), "dump", "manifest",
            f"--bundle={bundle_path}", f"--module={module}",
        ],
        check=True,
        capture_output=True,
        text=True,
    )
    try:
        return ET.fromstring(result.stdout)
    except ET.ParseError as error:
        raise ValueError(f"bundletool returned invalid XML for module {module}: {error}") from error


def verify(bundletool: Path, bundle_path: Path) -> None:
    modules = module_names(bundle_path)
    all_permissions: set[str] = set()

    for module in modules:
        manifest = read_module_manifest(bundletool, bundle_path, module)
        package_name = manifest.get("package")
        if package_name != EXPECTED_PACKAGE:
            raise ValueError(
                f"Module {module} package identity is {package_name!r}; "
                f"expected {EXPECTED_PACKAGE!r}"
            )

        for element in manifest:
            if element.tag.rsplit("}", 1)[-1].startswith("uses-permission"):
                permission = element.get(ANDROID_NS + "name")
                if permission:
                    all_permissions.add(permission)

    if all_permissions != EXPECTED_PERMISSIONS:
        unexpected = sorted(all_permissions - EXPECTED_PERMISSIONS)
        missing = sorted(EXPECTED_PERMISSIONS - all_permissions)
        raise ValueError(
            "AAB merged module permission set differs from the reviewed allowlist; "
            f"unexpected={unexpected}, missing={missing}"
        )

    print("Android App Bundle module manifests verified.")
    print(f"- Modules: {', '.join(modules)}")
    print(f"- Application ID: {EXPECTED_PACKAGE}")
    print(f"- Permissions: {', '.join(sorted(all_permissions))}")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--bundle", required=True, type=Path)
    parser.add_argument("--bundletool", required=True, type=Path)
    args = parser.parse_args()

    if not args.bundle.is_file():
        parser.error(f"AAB file does not exist: {args.bundle}")
    if not args.bundletool.is_file():
        parser.error(f"bundletool JAR does not exist: {args.bundletool}")

    try:
        verify(args.bundletool.resolve(), args.bundle.resolve())
    except (OSError, ValueError, subprocess.CalledProcessError, zipfile.BadZipFile) as error:
        print(f"AAB manifest verification failed: {error}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
