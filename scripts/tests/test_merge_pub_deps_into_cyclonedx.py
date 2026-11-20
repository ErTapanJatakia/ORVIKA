"""Tests for merging the Dart Pub dependency graph into CycloneDX."""

import importlib.util
import unittest
from pathlib import Path

SCRIPT = Path(__file__).resolve().parents[1] / "merge_pub_deps_into_cyclonedx.py"
SPEC = importlib.util.spec_from_file_location("merge_pub_deps_into_cyclonedx", SCRIPT)
assert SPEC is not None and SPEC.loader is not None
MODULE = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(MODULE)


def fixtures():
    sbom = {
        "bomFormat": "CycloneDX",
        "specVersion": "1.6",
        "metadata": {"component": {"bom-ref": "root-ref", "name": "/src", "type": "file"}},
        "components": [
            {"bom-ref": "a-ref", "type": "library", "name": "alpha", "version": "1.0.0", "purl": "pkg:pub/alpha@1.0.0"},
            {"bom-ref": "b-ref", "type": "library", "name": "beta", "version": "2.0.0", "purl": "pkg:pub/beta@2.0.0"},
        ],
    }
    graph = {
        "root": "sample_app",
        "packages": [
            {"name": "sample_app", "version": "0.1.0", "kind": "root", "dependencies": ["alpha"]},
            {"name": "alpha", "version": "1.0.0", "kind": "direct", "dependencies": ["beta"]},
            {"name": "beta", "version": "2.0.0", "kind": "transitive", "dependencies": []},
        ],
    }
    return sbom, graph


class CycloneDxPubGraphTests(unittest.TestCase):
    def test_adds_only_resolved_pub_dependency_edges(self):
        sbom, graph = fixtures()
        result, package_count, edge_count = MODULE.merge(sbom, graph)
        self.assertEqual(package_count, 3)
        self.assertEqual(edge_count, 2)
        self.assertEqual(
            result["dependencies"],
            [
                {"ref": "a-ref", "dependsOn": ["b-ref"]},
                {"ref": "b-ref", "dependsOn": []},
                {"ref": "root-ref", "dependsOn": ["a-ref"]},
            ],
        )
        self.assertNotIn("dependencies", sbom)

    def test_fails_when_pub_package_is_missing_from_syft_inventory(self):
        sbom, graph = fixtures()
        sbom["components"] = sbom["components"][:1]
        with self.assertRaisesRegex(ValueError, "absent from the Syft inventory"):
            MODULE.merge(sbom, graph)

    def test_fails_when_dependency_name_is_unresolved(self):
        sbom, graph = fixtures()
        graph["packages"][1]["dependencies"] = ["not-in-graph"]
        with self.assertRaisesRegex(ValueError, "unresolved dependencies"):
            MODULE.merge(sbom, graph)

    def test_fails_on_duplicate_pub_package_names(self):
        sbom, graph = fixtures()
        graph["packages"].append(dict(graph["packages"][1]))
        with self.assertRaisesRegex(ValueError, "Duplicate Pub package"):
            MODULE.merge(sbom, graph)

    def test_fails_instead_of_overwriting_existing_relationships(self):
        sbom, graph = fixtures()
        sbom["dependencies"] = [{"ref": "root-ref", "dependsOn": []}]
        with self.assertRaisesRegex(ValueError, "Refusing to overwrite"):
            MODULE.merge(sbom, graph)

    def test_fails_when_cyclonedx_root_reference_is_missing(self):
        sbom, graph = fixtures()
        del sbom["metadata"]["component"]["bom-ref"]
        with self.assertRaisesRegex(ValueError, "bom-ref is required"):
            MODULE.merge(sbom, graph)


if __name__ == "__main__":
    unittest.main()
