# Portable Input And Output Contract

## Inputs

Ask for only the materials needed for the requested distribution mode:

- A mod archive or an unpacked mod directory.
- For the default overlay-only mode: the intended pairing, normal or bilingual
  official localization. The official triplet itself is not an input.
- For an optional fused package: the matching official normal-language or bilingual
  package triplet to embed.
- Any project terminology files, prior translation maps, screenshots, and prior
  patch archives that the user has available.

Do not require a particular archive name, folder layout, game install location,
release host, account, or proprietary tool path. When a required extraction or
packing tool is unavailable, identify the missing capability and use an
equivalent compatible tool rather than changing the package format.

## Workspace Layout

Use a user-selected workspace and keep these areas separate:

- `source/`: immutable copies or unpacked source material.
- `inventory/`: exact-source inventories and surface classifications.
- `translations/`: translation maps, terminology overrides, and pending terms.
- `build/`: generated overlay and optional fused package roots.
- `output/`: final archives, checksums, and installation notes.

Never overwrite source archives or prior verified output. Rebuild a new output
directory when the mod or official baseline changes.

## Required Outputs

For every output, deliver:

- One installable overlay archive containing the current mod localization overlay and
  an installation note that declares normal or bilingual base-package compatibility.
- `SHA256SUMS.txt` generated from the final archive bytes.
- An audit summary: source count, translated player-facing count, excluded
  technical count, pending terminology count, and validation results.

For optional fused distribution, add the matching official triplet to a separate
archive and hash-check it against its source. Do not embed an official triplet in an
overlay-only archive. Never claim that a mod-only overlay manufactures bilingual
base-game localization.

## Automation Rules

- Inventory and deduplicate exact source strings before translation so recurring
  mod updates can reuse the same map.
- Apply terminology replacements with context rules, never broad global word
  substitution.
- Keep automation configuration external to reusable code: source, distribution mode,
  base-package compatibility, optional baseline, workspace, and output paths must be
  parameters.
- Leave unknown proper names in English or mark them as pending. Automation may
  accelerate coverage but must not silently turn an unverified translation into a
  glossary standard.
