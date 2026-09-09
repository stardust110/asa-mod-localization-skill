---
name: asa-mod-localization-release
description: "Create and validate reusable ARK: Survival Ascended mod localization overlays, with optional fused normal and bilingual baseline packages. Use for ASA mod archive localization, coverage repair, and local release packaging; not for ordinary game translation questions."
---

# ASA Mod Localization Release

Create a usable, portable ASA mod localization package. This standard `SKILL.md`
folder is designed for skills-compatible agents; optional client metadata must not
be required for the workflow. The default deliverable is a verified mod localization
overlay archive plus a checksum; fused packages that include an official base-game
baseline are optional. Publishing them to a hosting service is outside this skill.
Treat package inspection and in-game
evidence as different things: a structurally valid archive is not proof that every
text renders in the game.

## Start With Evidence

- Treat every archive as a potentially new mod. Do not require a pre-existing
  per-mod script or translation file before beginning work.
- Inspect supplied archives and screenshots before modifying any translation map.
- Identify the actual mod from content and player-facing metadata. Internal Unreal
  project paths can be historical and must not be presented as the mod name.
- For a new mod, unpack its package into an isolated workspace, inventory all text,
  deduplicate exact sources, and classify visible surfaces before writing a single
  translation. Compare to an earlier archive when one exists; otherwise make this
  inventory the baseline for future updates.
- Scan only player-facing surfaces: item names/descriptions, engrams, creature names,
  buffs, HUD/status text, books, and tool modes. Exclude material parameters,
  shader fields, binary noise, and other technical strings.
- A screenshot showing English is a concrete regression: locate its complete source
  text including punctuation, RichColor tags, spaces, and line endings. Do not assume
  that translating a short fragment will match Unreal's localization key.
- When a working patch and a regressed candidate both exist, read
  [runtime-regression-triage.md](references/runtime-regression-triage.md) before
  changing translations. Run `scripts/compare-pak-layout.ps1` with a
  target-compatible UnrealPak to compare their mount points and LocRes paths.
  A missing path is a packaging regression, not evidence that the translation text
  needs to be rewritten.

## Tool Readiness

Before unpacking or building, read [tool-bootstrap.md](references/tool-bootstrap.md)
and [tool-sources.md](references/tool-sources.md), then probe the local environment. Do not assume the user already owns an Unreal
package tool. Report the exact missing capability and a compatible tool category;
ask for explicit permission before downloading, installing, updating, or changing
system configuration. Never substitute a tool that changes the package format or
claim a patch was built when extraction was unavailable.

## New-Machine Preflight

For a new machine, read [new-machine-quickstart.md](references/new-machine-quickstart.md)
and run `scripts/preflight.ps1` before translating. The script reports independent
readiness states for source inventory, overlay build, and any requested fused package
builds. Do not collapse a blocked build into a generic failure: deliver the
translation map and audit as intermediate artifacts when appropriate, and name the
one missing input or capability that prevents the next stage.

## Terminology Is A Dependency

Before translating ASA creatures, items, materials, mechanics, or UI, follow the
project `AGENTS.md` and load its designated TSV/JSON terminology sources. Prefer
confirmed ASA terminology over literal English translation. New confirmed terms need
an English source, Chinese translation, category, evidence, and scope rule; unknown
proper names remain English or `中文（English）` until verified.

## Choose The Distribution Mode

### Overlay-only (default)

- Build and distribute only the current mod localization overlay pak, installation
  note, and checksum. An official base-game package triplet is **not required**.
- The player installs the overlay beside the official normal or bilingual localization
  package they already use. Selecting a bilingual-compatible overlay does not create
  bilingual base-game text; that text still comes from the official bilingual package.
- Keep a single current overlay pak. Do not include obsolete duplicate overlay names.

### Fused package (optional)

- Use this only when distributing one self-contained archive that also carries the
  base-game localization package.
- A normal fused package must copy the official *normal* triplet
  (`ShooterGame-Windows_P.pak`, `.ucas`, `.utoc`). A bilingual fused package must
  separately copy the official *bilingual* triplet.
- Never build both fused variants from the same official `.pak`, or claim a mod-only
  overlay adds bilingual names to base-game content.

### Variant Isolation Is Mandatory

- Treat normal Chinese and bilingual output as independent products, not two flags
  passed through one mutable shared build tree. Each variant needs an immutable
  baseline, isolated work/output directories, and a separate manifest with its own
  hashes.
- A bilingual experiment must never replace, repack, fuse assets into, or otherwise
  alter a normal-Chinese payload unless normal mode has separately passed its
  in-game regression test. A structurally valid bilingual container is not evidence
  that the normal package still works.
- When a prior normal package is game-proven and a newer normal package regresses,
  preserve the proven overlay bytes as the recovery baseline. Compare mount point,
  every `Localization/.../*.locres` path, and official triplet hashes before adding
  new coverage.
- Preserve every observed fallback entry required by the working baseline. Do not
  reduce `zh / zh-Hans / ja / de` buckets to only `zh / zh-Hans` merely because the
  UI language appears Chinese; ASA mod text can resolve through a fallback bucket.

Build archives in the workspace first. External distribution folders can reject or
truncate writes; copy only a verified final artifact out afterward.

### PAK Format Compatibility Is A Release Gate

- A newer UnrealPak is not automatically compatible with the player's ASA client.
  The packer version may write a newer PAK format even when the files and mount
  paths are otherwise correct.
- Select a packer by proving that it can read a known-good ASA overlay or client
  PAK. After building, use that same target-compatible reader to run `-List` or
  `-Test` on the new overlay and confirm the intended locres entries are present.
- Treat a game error such as `Invalid pak file version (12)` as a packaging-format
  failure, not a text, locres, or translation defect. Do not publish that PAK;
  rebuild from the identical response file with a compatible UnrealPak, then repeat
  archive and locres readback checks.

## Portable Workflow

- Accept a mod archive or unpacked mod directory for overlay-only output. Require an
  official normal or bilingual baseline only for the matching optional fused output.
- Keep generated inventories, translation maps, audit reports, and output archives
  under a user-selected workspace. Do not depend on a particular drive letter,
  GitHub repository, mod author, or prior release script.
- Use a small reusable build script only when it preserves exact text keys and can
  be rerun for future mod updates. The script must expose source paths and output
  paths as configuration rather than hard-coding a user's folders.
- Produce a concise installation readme and `SHA256SUMS.txt`. Hosting, uploading,
  and external announcements remain explicit user choices.

Read [portable-input-output.md](references/portable-input-output.md) and
[release-checklist.md](references/release-checklist.md) before a build.

## Completion Standard

Do not call the task complete until all applicable checks pass:

1. Source-to-translation audit reports no unresolved player-facing strings in scope.
2. Mixed-English and Chinese-spacing checks pass, except explicitly approved proper
   names or model identifiers.
3. Each overlay-only zip passes CRC/integrity testing and contains the current
   localization overlay plus an installation readme that states its base-package
   compatibility.
4. Each fused zip additionally contains the expected official triplet; normal and
   bilingual fused archives use their respective, distinct official `.pak` hashes.
5. Every produced overlay PAK passes a `-List` or `-Test` readback with an
   ASA-client-compatible UnrealPak and contains the expected localization paths.
6. A SHA256 manifest covers the final archives.
7. Normal and bilingual artifacts have separate baseline hashes, isolated output
   paths, and their own in-game evidence. Publishing one must not overwrite or
   silently supersede the other.
8. For a regression that has a known-good baseline, the release audit includes the
   baseline-versus-candidate PAK layout comparison and its classification. Do not
   publish an asset-container workaround for a LocRes routing failure, or vice versa.
