"""Regression tests for safe Android App Bundle manifest parsing."""

import importlib.util
import unittest
from pathlib import Path

SCRIPT = Path(__file__).resolve().parents[1] / "verify-android-aab-manifest.py"
SPEC = importlib.util.spec_from_file_location("verify_android_aab_manifest", SCRIPT)
assert SPEC is not None and SPEC.loader is not None
MODULE = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(MODULE)


class ManifestParserSecurityTests(unittest.TestCase):
    def test_accepts_well_formed_manifest(self):
        root = MODULE.parse_manifest_xml(
            '<manifest xmlns:android="http://schemas.android.com/apk/res/android" '
            'package="com.orvika.app"><uses-permission '
            'android:name="android.permission.INTERNET"/></manifest>',
            "base",
        )
        self.assertEqual(root.get("package"), "com.orvika.app")

    def test_permission_declarations_capture_exact_protection_level(self):
        root = MODULE.parse_manifest_xml(
            '<manifest xmlns:android="http://schemas.android.com/apk/res/android">'
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
