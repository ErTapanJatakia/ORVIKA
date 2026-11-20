#!/usr/bin/env python3
"""Add authoritative Dart Pub dependency edges to a Syft CycloneDX SBOM.

Syft inventories the locked Pub packages, while `dart pub deps --json`
provides the resolved package-to-package graph. This merger only adds edges
that are explicitly present in Pub's graph and fails closed on identity gaps.
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Any


def merge(sbom: dict[str, Any], pub_graph: dict[str, Any]) -> tuple[dict[str, Any], int, int]:
    if sbom.get("bomFormat") != "CycloneDX":
        raise ValueError("Input SBOM is not CycloneDX")
    metadata_component = sbom.get("metadata", {}).get("component", {})
    root_ref = metadata_component.get("bom-ref")
    if not root_ref:
        raise ValueError("CycloneDX metadata.component.bom-ref is required")
    if sbom.get("dependencies"):
        raise ValueError("Refusing to overwrite existing CycloneDX dependency relationships")

    root_name = pub_graph.get("root")
    packages = pub_graph.get("packages")
    if not isinstance(root_name, str) or not root_name:
        raise ValueError("Pub dependency graph is missing its root package name")
    if not isinstance(packages, list) or not packages:
        raise ValueError("Pub dependency graph has no package records")

    packages_by_name: dict[str, dict[str, Any]] = {}
    for package in packages:
        if not isinstance(package, dict):
            raise ValueError("Pub dependency graph contains a malformed package record")
        name = package.get("name")
        version = package.get("version")
        dependencies = package.get("dependencies", [])
        if not isinstance(name, str) or not name or not isinstance(version, str) or not version:
            raise ValueError("Pub package record is missing a name or version")
        if name in packages_by_name:
            raise ValueError(f"Duplicate Pub package name is not supported: {name}")
        if not isinstance(dependencies, list) or not all(
            isinstance(dependency, str) and dependency for dependency in dependencies
        ):
            raise ValueError(f"Malformed dependency list for Pub package: {name}")
        packages_by_name[name] = package

    root_package = packages_by_name.get(root_name)
    if root_package is None or root_package.get("kind") != "root":
        raise ValueError("Pub graph root does not resolve to exactly one root package record")
    if sum(package.get("kind") == "root" for package in packages_by_name.values()) != 1:
        raise ValueError("Pub graph must contain exactly one root package")

    pub_components: dict[tuple[str, str], str] = {}
    for component in sbom.get("components", []):
        purl = component.get("purl", "")
        if not purl.startswith("pkg:pub/"):
            continue
        key = (component.get("name"), component.get("version"))
        bom_ref = component.get("bom-ref")
        if not all(isinstance(value, str) and value for value in key) or not bom_ref:
            raise ValueError("Syft Pub component is missing its identity or bom-ref")
        if key in pub_components and pub_components[key] != bom_ref:
            raise ValueError(f"Ambiguous Syft component identity: {key[0]}@{key[1]}")
        pub_components[key] = bom_ref

    refs: dict[str, str] = {root_name: root_ref}
    for name, package in packages_by_name.items():
        if name == root_name:
            continue
        key = (name, package["version"])
        bom_ref = pub_components.get(key)
        if not bom_ref:
            raise ValueError(
                f"Pub package is absent from the Syft inventory: {name}@{package['version']}"
            )
        refs[name] = bom_ref

    relationships: list[dict[str, Any]] = []
    edge_count = 0
    for name in sorted(packages_by_name):
        package = packages_by_name[name]
        child_names = sorted(set(package.get("dependencies", [])))
        missing = [child for child in child_names if child not in refs]
        if missing:
            raise ValueError(f"Pub graph has unresolved dependencies for {name}: {missing}")
        child_refs = [refs[child] for child in child_names]
        if refs[name] in child_refs:
            raise ValueError(f"Pub graph contains a self-dependency for {name}")
        relationships.append({"ref": refs[name], "dependsOn": child_refs})
        edge_count += len(child_refs)

    result = json.loads(json.dumps(sbom))
    result["dependencies"] = relationships

    known_refs = {metadata_component["bom-ref"]}
    known_refs.update(component["bom-ref"] for component in result.get("components", []))
    for relationship in result["dependencies"]:
        if relationship["ref"] not in known_refs:
            raise ValueError(f"CycloneDX dependency ref is not present in the BOM: {relationship['ref']}")
        if any(ref not in known_refs for ref in relationship["dependsOn"]):
            raise ValueError("CycloneDX dependency edge points to a missing BOM component")

    return result, len(packages_by_name), edge_count


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--sbom", required=True, type=Path)
    parser.add_argument("--pub-deps", required=True, type=Path)
    parser.add_argument("--output", required=True, type=Path)
    args = parser.parse_args()

    with args.sbom.open(encoding="utf-8") as handle:
        sbom = json.load(handle)
    with args.pub_deps.open(encoding="utf-8") as handle:
        pub_graph = json.load(handle)

    result, package_count, edge_count = merge(sbom, pub_graph)
    args.output.write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
    print(
        "CycloneDX dependency graph verified: "
        f"{package_count} Pub packages, {edge_count} Pub dependency edges."
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
