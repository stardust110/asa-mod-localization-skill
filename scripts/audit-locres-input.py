#!/usr/bin/env python3
"""Fail on ambiguous LocRes translation inputs before packaging."""

import argparse
import csv
import json
from collections import defaultdict
from pathlib import Path


def audit(directory: Path, required: list[str]) -> dict:
    files = sorted(directory.glob("*.csv"))
    if not files:
        raise ValueError(f"No CSV files in {directory}")

    unkeyed = defaultdict(lambda: defaultdict(list))
    keyed = defaultdict(lambda: defaultdict(list))
    keyed_sources = defaultdict(lambda: defaultdict(list))
    translated_sources = set()
    row_count = 0
    for file in files:
        with file.open(encoding="utf-8-sig", newline="") as stream:
            reader = csv.DictReader(stream)
            expected = {"Path", "Key", "Source", "Translation"}
            if not expected.issubset(reader.fieldnames or ()):
                raise ValueError(f"Missing {sorted(expected)} columns: {file}")
            for line, row in enumerate(reader, 2):
                row_count += 1
                source, translation = row["Source"], row["Translation"]
                if not source or not translation or source == translation:
                    continue
                translated_sources.add(source)
                identity = row["Key"] or source
                group = keyed if row["Key"] else unkeyed
                group[identity][translation].append(f"{file.name}:{line}")
                if row["Key"]:
                    keyed_sources[identity][source].append(f"{file.name}:{line}")

    conflicts = []
    for kind, group in (("unkeyed-source", unkeyed), ("explicit-key", keyed)):
        for identity, translations in group.items():
            if len(translations) > 1:
                conflicts.append({"kind": kind, "identity": identity,
                                  "translations": dict(translations)})
    for identity, sources in keyed_sources.items():
        if len(sources) > 1:
            conflicts.append({"kind": "explicit-key-source", "identity": identity,
                              "sources": dict(sources)})
    missing = sorted(set(required) - translated_sources)
    return {"directory": str(directory), "files": len(files), "rows": row_count,
            "translated_sources": len(translated_sources), "conflicts": conflicts,
            "missing_required_sources": missing, "ok": not conflicts and not missing}


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("directory", type=Path, help="One variant's translation CSV directory")
    parser.add_argument("--required-source", action="append", default=[],
                        help="Screenshot source that must have a non-identical translation")
    args = parser.parse_args()
    try:
        report = audit(args.directory, args.required_source)
    except (OSError, ValueError) as error:
        parser.exit(2, f"audit error: {error}\n")
    print(json.dumps(report, ensure_ascii=False, indent=2))
    return 0 if report["ok"] else 2


if __name__ == "__main__":
    raise SystemExit(main())
