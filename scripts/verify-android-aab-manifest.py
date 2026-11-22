#!/usr/bin/env python3
"""Verify every Android App Bundle module manifest using Google's bundletool."""

import argparse
import re
import shutil
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


def is_signature_protection_level(value: str) -> bool:
    """Accept the exact Android signature level in text or bundletool numeric form."""
    normalized = value.strip().lower()
    if normalized == "signature":
        return True
    try:
        return int(normalized, 0) == 0x00000002
    except ValueError:
        return False


def permission_declarations(manifest: Any) -> list[tuple[str, str]]:
    """Return declared permission names and protection levels for diagnostics."""
    declarations = []
    for element in manifest:
        if element.tag.rsplit("}", 1)[-1] == "permission":
            declarations.append((
                element.get(ANDROID_NS + "name", "<missing-name>"),
                element.get(ANDROID_NS + "protectionLevel", "<missing-protectionLevel>"),
            ))
    return declarations


def module_names(bundle_path: Path) -> list[str]:
    with zipfile.ZipFile(bundle_path) as bundle:
        modules = sorted({
            name.split("/", 1)[0]
            for name in bundle.namelist()
            if name.endswith("/manifest/AndroidManifest.xml")
        })
    if "base" not in modules:
        raise ValueError("AAB does not contain the required base module manifest")
    invalid_modules = [
        module for module in modules
        if re.fullmatch(r"[A-Za-z][A-Za-z0-9_]*", module) is None
    ]
    if invalid_modules:
        raise ValueError(f"AAB contains invalid module names: {invalid_modules}")
    return modules


def read_module_manifest(
    bundletool: Path,
    bundle_path: Path,
    module: str,
    diagnostics_dir: Path | None = None,
) -> Any:
    """Render and parse a module manifest; never export the raw manifest."""
    java_executable = shutil.which("java")
    if java_executable is None:
        raise FileNotFoundError("Java executable was not found on PATH")
    if re.fullmatch(r"[A-Za-z][A-Za-z0-9_]*", module) is None:
        raise ValueError("Invalid Android App Bundle module identifier")
    bundletool = bundletool.resolve(strict=True)
    bundle_path = bundle_path.resolve(strict=True)
    if not bundletool.is_file() or not bundle_path.is_file():
        raise ValueError("bundletool and bundle inputs must resolve to regular files")

    # shell=False and one argv element per value prevent shell interpretation;
    # module identifiers are constrained above before entering the argument vector.
    command = [
        java_executable, "-jar", str(bundletool), "dump", "manifest",
        f"--bundle={bundle_path}", f"--module={module}",
    ]
    result = subprocess.run(
        command,
        shell=False,
        check=False,
        capture_output=True,
        text=True,
    )

    if diagnostics_dir is not None:
        diagnostics_dir.mkdir(parents=True, exist_ok=True)
        with (diagnostics_dir / "bundletool-module-status.txt").open(
            "a", encoding="utf-8"
        ) as status:
            status.write(
                f"module={module}\nreturn_code={result.returncode}\n"
                f"stdout_bytes={len(result.stdout.encode('utf-8'))}\n"
                f"stderr_bytes={len(result.stderr.encode('utf-8'))}\n\n"
            )
        if result.stderr:
            safe_module = "".join(
                char if char.isalnum() or char in "._-" else "_"
                for char in module
            )
            (diagnostics_dir / f"{safe_module}-bundletool-stderr.txt").write_text(
                result.stderr, encoding="utf-8"
            )

    if result.returncode != 0:
        raise ValueError(
            f"bundletool manifest dump failed for module {module} "
            f"(exit {result.returncode}); see captured diagnostics"
        )
    return parse_manifest_xml(result.stdout, module)


def write_module_summary(
    diagnostics_dir: Path | None,
    module: str,
    manifest: Any,
) -> None:
    """Write only package and permission metadata, not the full app manifest."""
    if diagnostics_dir is None:
        return
    declarations = permission_declarations(manifest)
    uses_permissions = []
    for element in manifest:
        if element.tag.rsplit("}", 1)[-1].startswith("uses-permission"):
            name = element.get(ANDROID_NS + "name")
            if name:
                uses_permissions.append(name)
    report = diagnostics_dir / "module-permission-summary.txt"
    with report.open("a", encoding="utf-8") as output:
        output.write(f"module={module}\n")
        output.write(f"package={manifest.get('package', '<missing>')}\n")
        output.write("permission_declarations:\n")
        if declarations:
            for name, protection_level in declarations:
                output.write(
                    f"  name={name!r}; protectionLevel={protection_level!r}\n"
                )
        else:
            output.write("  <none>\n")
        output.write("uses_permissions:\n")
        for name in sorted(uses_permissions):
            output.write(f"  {name}\n")
        if not uses_permissions:
            output.write("  <none>\n")
        output.write("\n")


def verify(
    bundletool: Path,
    bundle_path: Path,
    diagnostics_dir: Path | None = None,
) -> None:
    modules = module_names(bundle_path)
    all_permissions: set[str] = set()
    permission_diagnostics: list[str] = []
    has_signature_protected_dynamic_receiver_permission = False

    for module in modules:
        manifest = read_module_manifest(
            bundletool, bundle_path, module, diagnostics_dir
        )
        write_module_summary(diagnostics_dir, module, manifest)
        package_name = manifest.get("package")
        if package_name != EXPECTED_PACKAGE:
            raise ValueError(
                f"Module {module} package identity is {package_name!r}; "
                f"expected {EXPECTED_PACKAGE!r}"
            )

        for name, protection_level in permission_declarations(manifest):
            permission_diagnostics.append(
                f"{module}: name={name!r}, protectionLevel={protection_level!r}"
            )
            if (
                name == DYNAMIC_RECEIVER_PERMISSION
                and is_signature_protection_level(protection_level)
            ):
                has_signature_protected_dynamic_receiver_permission = True

        for element in manifest:
            element_name = element.tag.rsplit("}", 1)[-1]
            if element_name.startswith("uses-permission"):
                permission = element.get(ANDROID_NS + "name")
                if permission:
                    all_permissions.add(permission)

    if all_permissions != EXPECTED_PERMISSIONS:
        unexpected = sorted(all_permissions - EXPECTED_PERMISSIONS)
        missing = sorted(EXPECTED_PERMISSIONS - all_permissions)
        raise ValueError(
            "AAB merged module permission set differs from the reviewed Android + "
            f"AndroidX allowlist; unexpected={unexpected}, missing={missing}"
        )

    if not has_signature_protected_dynamic_receiver_permission:
        observed = "; ".join(permission_diagnostics) or "<no permission declarations>"
        raise ValueError(
            "AAB must declare the AndroidX dynamic receiver permission "
            f"{DYNAMIC_RECEIVER_PERMISSION!r} with signature protection. "
            f"Observed <permission> declarations by module: {observed}"
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
    parser.add_argument(
        "--diagnostics-dir",
        type=Path,
        help="Optionally write a sanitized package/permission diagnostic report.",
    )
    args = parser.parse_args()

    if not args.bundle.is_file():
        parser.error(f"AAB file does not exist: {args.bundle}")
    if not args.bundletool.is_file():
        parser.error(f"bundletool JAR does not exist: {args.bundletool}")

    try:
        verify(
            args.bundletool.resolve(),
            args.bundle.resolve(),
            args.diagnostics_dir,
        )
    except (OSError, ValueError, subprocess.CalledProcessError, zipfile.BadZipFile) as error:
        print(f"AAB manifest verification failed: {error}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
