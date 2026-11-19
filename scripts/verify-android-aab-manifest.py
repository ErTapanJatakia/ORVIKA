#!/usr/bin/env python3
"""Verify every Android App Bundle module manifest using Google's bundletool."""

import argparse
import subprocess
import sys
import zipfile
from pathlib import Path
from typing import Any

from defusedxml import ElementTree as ET
from defusedxml.common import DefusedXmlException

ANDROID_NS = "{http://schemas.android.com/apk/res/android}"
EXPECTED_PACKAGE = "com.orvika.app"
DYNAMIC_RECEIVER_PERMISSION = (
    f"{EXPECTED_PACKAGE}.DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION"
)
EXPECTED_PERMISSIONS = {
    "android.permission.ACCESS_NETWORK_STATE",
    "android.permission.CAMERA",
    "android.permission.INTERNET",
    DYNAMIC_RECEIVER_PERMISSION,
}


def parse_manifest_xml(xml_text: str, module: str) -> Any:
    """Parse bundletool output while rejecting DTDs and entity declarations."""
    try:
        return ET.fromstring(xml_text)
    except (ET.ParseError, DefusedXmlException) as error:
        raise ValueError(
            f"bundletool returned unsafe or invalid XML for module {module}: {error}"
        ) from error


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


def read_module_manifest(bundletool: Path, bundle_path: Path, module: str) -> Any:
    result = subprocess.run(
        [
            "java", "-jar", str(bundletool), "dump", "manifest",
            f"--bundle={bundle_path}", f"--module={module}",
        ],
        check=True,
        capture_output=True,
        text=True,
    )
    return parse_manifest_xml(result.stdout, module)


def verify(bundletool: Path, bundle_path: Path) -> None:
    modules = module_names(bundle_path)
    all_permissions: set[str] = set()
    has_signature_protected_dynamic_receiver_permission = False

    for module in modules:
        manifest = read_module_manifest(bundletool, bundle_path, module)
        package_name = manifest.get("package")
        if package_name != EXPECTED_PACKAGE:
            raise ValueError(
                f"Module {module} package identity is {package_name!r}; "
                f"expected {EXPECTED_PACKAGE!r}"
            )

        for element in manifest:
            element_name = element.tag.rsplit("}", 1)[-1]
            if element_name.startswith("uses-permission"):
                permission = element.get(ANDROID_NS + "name")
                if permission:
                    all_permissions.add(permission)
            elif element_name == "permission":
                permission = element.get(ANDROID_NS + "name")
                protection_level = element.get(ANDROID_NS + "protectionLevel", "")
                if (
                    permission == DYNAMIC_RECEIVER_PERMISSION
                    and protection_level.lower() == "signature"
                ):
                    has_signature_protected_dynamic_receiver_permission = True

    if all_permissions != EXPECTED_PERMISSIONS:
        unexpected = sorted(all_permissions - EXPECTED_PERMISSIONS)
        missing = sorted(EXPECTED_PERMISSIONS - all_permissions)
        raise ValueError(
            "AAB merged module permission set differs from the reviewed Android + "
            f"AndroidX allowlist; unexpected={unexpected}, missing={missing}"
        )

    if not has_signature_protected_dynamic_receiver_permission:
        raise ValueError(
            "AAB must declare the AndroidX dynamic receiver permission "
            f"{DYNAMIC_RECEIVER_PERMISSION!r} with signature protection"
        )

    print("Android App Bundle module manifests verified.")
    print(f"- Modules: {', '.join(modules)}")
    print(f"- Application ID: {EXPECTED_PACKAGE}")
    print(f"- Permissions: {', '.join(sorted(all_permissions))}")
    print("- AndroidX dynamic receiver permission: declared with signature protection")


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
