# Portable Input And Output Contract

## Inputs

Ask for only the materials needed for the requested variant:

- A mod archive or an unpacked mod directory.
- An official normal-language package triplet for normal output.
- An official bilingual package triplet only when bilingual output is requested.
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
- `build/`: generated normal and bilingual package roots.
- `output/`: final archives, checksums, and installation notes.

Never overwrite source archives or prior verified output. Rebuild a new output
directory when the mod or official baseline changes.

## Required Outputs

For each requested variant, deliver:

- One installable archive containing the correct official triplet and current
  mod localization overlay.
- `SHA256SUMS.txt` generated from the final archive bytes.
- A short installation note stating that normal and bilingual variants are
  mutually exclusive.
- An audit summary: source count, translated player-facing count, excluded
  technical count, pending terminology count, and validation results.

When bilingual output is not requested or a bilingual official baseline is not
supplied, produce only the normal archive and say so in the audit summary. Never
manufacture bilingual base-game localization from a mod-only overlay.

## Automation Rules

- Inventory and deduplicate exact source strings before translation so recurring
  mod updates can reuse the same map.
- Apply terminology replacements with context rules, never broad global word
  substitution.
- Keep automation configuration external to reusable code: source, baseline,
  workspace, and output paths must be parameters.
- Leave unknown proper names in English or mark them as pending. Automation may
  accelerate coverage but must not silently turn an unverified translation into a
  glossary standard.
