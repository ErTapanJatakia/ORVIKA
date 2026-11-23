"""Regression tests for safe Android App Bundle manifest parsing and diagnostics."""

import importlib.util
import tempfile
import unittest
import zipfile
from pathlib import Path
from unittest.mock import patch
from subprocess import CompletedProcess

SCRIPT = Path(__file__).resolve().parents[1] / "verify-android-aab-manifest.py"
SPEC = importlib.util.spec_from_file_location("verify_android_aab_manifest", SCRIPT)
if SPEC is None or SPEC.loader is None:
    raise RuntimeError("Unable to load the module under test")
MODULE = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(MODULE)


class ManifestParserSecurityTests(unittest.TestCase):
    def test_module_names_accepts_expected_module_identifiers(self):
        with tempfile.TemporaryDirectory() as directory:
            bundle_path = Path(directory, "valid.aab")
            with zipfile.ZipFile(bundle_path, "w") as bundle:
                bundle.writestr("base/manifest/AndroidManifest.xml", "<manifest/>")
                bundle.writestr("feature_one/manifest/AndroidManifest.xml", "<manifest/>")
            self.assertEqual(MODULE.module_names(bundle_path), ["base", "feature_one"])

    def test_module_names_rejects_path_like_module_identifiers(self):
        with tempfile.TemporaryDirectory() as directory:
            bundle_path = Path(directory, "invalid.aab")
            with zipfile.ZipFile(bundle_path, "w") as bundle:
                bundle.writestr("base/manifest/AndroidManifest.xml", "<manifest/>")
                bundle.writestr("../escape/manifest/AndroidManifest.xml", "<manifest/>")
            with self.assertRaisesRegex(ValueError, "invalid module names"):
                MODULE.module_names(bundle_path)

    def test_accepts_well_formed_manifest(self):
        root = MODULE.parse_manifest_xml(
            '<manifest xmlns:android="http://schemas.android.com/apk/res/android" ' # DevSkim: ignore DS137138 -- required Android XML namespace identifier in a parser fixture.
            'package="com.orvika.app"><uses-permission '
            'android:name="android.permission.INTERNET"/></manifest>',
            "base",
        )
        self.assertEqual(root.get("package"), "com.orvika.app")

    def test_permission_declarations_capture_exact_protection_level(self):
        root = MODULE.parse_manifest_xml(
            '<manifest xmlns:android="http://schemas.android.com/apk/res/android">' # DevSkim: ignore DS137138 -- required Android XML namespace identifier in a parser fixture.
            '<permission android:name="com.orvika.app.DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION" '
            'android:protectionLevel="signature"/></manifest>',
            "base",
        )
        self.assertEqual(
            MODULE.permission_declarations(root),
            [(
                "com.orvika.app.DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION",
                "signature",
            )],
        )

    def test_signature_protection_accepts_bundletool_hex_value(self):
        self.assertTrue(MODULE.is_signature_protection_level("0x00000002"))

    def test_signature_protection_accepts_decimal_numeric_value(self):
        self.assertTrue(MODULE.is_signature_protection_level("2"))

    def test_signature_protection_accepts_text_value(self):
        self.assertTrue(MODULE.is_signature_protection_level("signature"))

    def test_signature_protection_rejects_combined_or_stronger_levels(self):
        for value in ("signature|privileged", "0x00000003", "0x0000000A", "dangerous"):
            with self.subTest(value=value):
                self.assertFalse(MODULE.is_signature_protection_level(value))

    def test_permission_declaration_diagnostic_preserves_unexpected_value(self):
        root = MODULE.parse_manifest_xml(
            '<manifest xmlns:android="http://schemas.android.com/apk/res/android">'
            '<permission android:name="com.orvika.app.DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION" '
            'android:protectionLevel="signature|privileged"/></manifest>',
            "base",
        )
        self.assertEqual(
            MODULE.permission_declarations(root)[0][1],
            "signature|privileged",
        )

    def test_read_module_manifest_records_status_without_exporting_raw_xml(self):
        xml = '<manifest package="com.orvika.app"/>'
        completed = CompletedProcess(args=["java"], returncode=0, stdout=xml, stderr="")
        with tempfile.TemporaryDirectory() as directory:
            bundletool = Path(directory, "bundletool.jar")
            bundle_path = Path(directory, "app.aab")
            bundletool.write_bytes(b"test placeholder")
            bundle_path.write_bytes(b"test bundle placeholder")
            with patch.object(MODULE.subprocess, "run", return_value=completed) as run:
                MODULE.read_module_manifest(bundletool, bundle_path, "base", Path(directory))
            self.assertIs(run.call_args.kwargs["shell"], False)
            self.assertIs(run.call_args.kwargs["stdin"], MODULE.subprocess.DEVNULL)
            self.assertEqual(run.call_args.kwargs["timeout"], 120)
            status = Path(directory, "bundletool-module-status.txt").read_text()
            self.assertIn("module=base", status)
            self.assertIn("return_code=0", status)
            self.assertFalse(Path(directory, "base-AndroidManifest.xml").exists())

    def test_read_module_manifest_preserves_stderr_on_bundletool_failure(self):
        completed = CompletedProcess(
            args=["java"], returncode=2, stdout="", stderr="bundletool diagnostic"
        )
        with tempfile.TemporaryDirectory() as directory:
            bundletool = Path(directory, "bundletool.jar")
            bundle_path = Path(directory, "app.aab")
            bundletool.write_bytes(b"test placeholder")
            bundle_path.write_bytes(b"test bundle placeholder")
            with patch.object(MODULE.subprocess, "run", return_value=completed):
                with self.assertRaisesRegex(ValueError, "dump failed"):
                    MODULE.read_module_manifest(bundletool, bundle_path, "base", Path(directory))
            saved = Path(directory, "base-bundletool-stderr.txt")
            self.assertEqual(saved.read_text(encoding="utf-8"), "bundletool diagnostic")

    def test_module_summary_contains_only_package_and_permission_metadata(self):
        root = MODULE.parse_manifest_xml(
            '<manifest xmlns:android="http://schemas.android.com/apk/res/android" '
            'package="com.orvika.app"><permission android:name="com.orvika.app.TEST" '
            'android:protectionLevel="signature"/><uses-permission '
            'android:name="android.permission.INTERNET"/><application '
            'android:label="ORVIKA"/></manifest>',
            "base",
        )
        with tempfile.TemporaryDirectory() as directory:
            MODULE.write_module_summary(Path(directory), "base", root)
            report = Path(directory, "module-permission-summary.txt").read_text()
            self.assertIn("protectionLevel='signature'", report)
            self.assertIn("android.permission.INTERNET", report)
            self.assertNotIn("application", report)
            self.assertNotIn("ORVIKA", report)

    def test_rejects_external_entity_declaration(self):
        xml = (
            '<!DOCTYPE manifest [<!ENTITY xxe SYSTEM "file:///etc/passwd">]>'
            '<manifest package="&xxe;"/>'
        )
        with self.assertRaisesRegex(ValueError, "unsafe or invalid XML"):
            MODULE.parse_manifest_xml(xml, "base")

    def test_rejects_internal_entity_expansion(self):
        xml = (
            '<!DOCTYPE manifest [<!ENTITY first "ORVIKA">'
            '<!ENTITY second "&first;&first;">]>'
            '<manifest package="&second;"/>'
        )
        with self.assertRaisesRegex(ValueError, "unsafe or invalid XML"):
            MODULE.parse_manifest_xml(xml, "base")

    def test_rejects_malformed_xml(self):
        with self.assertRaisesRegex(ValueError, "unsafe or invalid XML"):
            MODULE.parse_manifest_xml("<manifest><activity></manifest>", "base")


if __name__ == "__main__":
    unittest.main()
