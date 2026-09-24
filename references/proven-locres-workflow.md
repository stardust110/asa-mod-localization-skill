# Proven ASA Mod LocRes Workflow

Use this when extending a game-proven external `3+1` patch, especially after a
direct cooked-asset overlay listed correctly in a PAK but stayed English in-game.
This records the route that the user confirmed working with test version 0.1.53
on 2026-09-24; it is evidence for that client and mod set, not a universal
promise that every ASA mod string is LocRes-addressable.

## 1. Freeze the Working Baseline

- Record the exact normal and bilingual archives, their hashes, install location,
  game/mod versions, and screenshot-tested names **and descriptions**. Do not
  overwrite either proven variant while experimenting.
- Compare the previous and candidate PAK mount points and every LocRes target path.
  Preserve all game-proven `Game`/`ShooterGame` and language fallback copies; do
  not infer a minimal set from the UI language alone.
- Inspect each mod archive's `.uplugin` to confirm its identity and numeric mod ID.
  An internal project name may differ from the public mod name. Include every
  newly requested mod in the input manifest; otherwise a successful build can
  silently omit it.

## 2. Inventory Actual Player-Facing Sources

- Work on an isolated copy of the supplied mod archive. When converting cooked
  IoStore packages to legacy assets, provide matching global `ScriptObjects`
  metadata if the converter requires it. A successful conversion must report zero
  failed packages before text inventory is trusted.
- Export structured text with an ASA-compatible asset reader. Retain `Path`,
  `Key`, exact `Source`, and surface type. Raw extraction can contain shader,
  binary, and editor noise; do not translate every extracted string.
- Classify item/engram names, descriptions, buffs, UI, creature names, and
  technical fields. Check a screenshot's complete English string against the
  current archive rather than assuming an old translation map still covers it.
- Deduplicate exact sources across **all** included mods. Review conflicts both
  within one variant and between UI and item surfaces. Use project terminology,
  existing proven patch text, the mod author's description, and ASA creature-name
  references. Preserve user-approved names rather than "correcting" them from
  an unrelated glossary.

## 3. Choose the LocRes Identity From Evidence

The export's empty `Key` column does **not** prove that LocRes cannot address the
runtime text. In the confirmed 0.1.53 case, many names and descriptions exported
without explicit keys still rendered from the external PAK's LocRes. For those
sources, the builder generated candidate entries for the exact original text and
its Unreal string CRC key under `Content`, `GraphLiteral`, and the empty namespace.
It stored the original source-string hash with each translation. This is a
candidate-key strategy to validate in-game, not permission to invent keys blindly.

When the export provides an explicit localization key, preserve it. A bare GUID
may require the same observed namespace candidates; an already qualified
`namespace::key` must remain qualified. Check the final LocRes for at least one
keyed UI entry and representative unkeyed item name **and** description. If an
English screenshot persists, inspect the actual source/key/namespace and mod
version before changing package format.

Unkeyed sources with the same exact English text cannot carry different Chinese
translations in one namespace/key. In 0.1.53, five medicine item names also named
buff/status effects. For the bilingual variant they stayed Chinese on both
surfaces, because making the item bilingual would also make UI/status bilingual.
Record such exceptions; never silently let the last CSV row win. Run:

```text
python scripts/audit-locres-input.py translations/normal --required-source "Blood Syringe"
python scripts/audit-locres-input.py translations/bilingual --required-source "Blood Syringe"
```

## 4. Extend, Build, and Read Back

- Start from each variant's complete game-proven LocRes, not a new sparse file.
  Add only reviewed new identities. On an existing identity, retain its source
  hash and translation unless a separately reviewed correction explicitly changes
  it. Compare every prior identity/hash/value after writing; missing or changed
  entries fail the build.
- Keep normal and bilingual inputs, baselines, workspaces, and output names separate.
  Only item and creature display names are bilingual when that is the user's rule;
  descriptions, buffs, and UI remain Chinese.
- Build a single external overlay PAK with the known-good ASA-compatible UnrealPak.
  Check `-Test`, `-List`, mount point, expected LocRes copies, and the absence of
  unintended cooked mod assets. Read the **final** LocRes back and check exact
  translations for screenshot examples, at least one description per added mod,
  and a keyed UI example when relevant.
- For strict `3+1`, copy the matching proven `ShooterGame-Windows_P` triplet
  unchanged into each archive, then verify all three hashes. The ZIP contains only
  these three runtime files, `pakchunk9999-Windows_P.pak`, and an install note.
  Test ZIP CRC and compute SHA-256 from final archive bytes. Keep filenames short
  and Chinese-first; make normal/bilingual installation mutually exclusive.

## 5. Runtime Gate and Failure Triage

Provide a **test** archive before publishing. Ask for game screenshots showing a
new mod's name, description, and representative item/engram plus a base-game
Chinese check. Structural checks prove only that the candidate was built as
intended. Record confirmed coverage and any remaining English surfaces.

If a PAK contains a translated cooked asset but the game still shows English,
inspect explicit mod IoStore mounting before repeating that route. Conversely,
`ExplicitlyLoaded: true` alone does not rule out LocRes: the confirmed 0.1.53
route translated item and medicine text from explicitly loaded mods. Diagnose
mount priority and text identity separately. Never switch to mod-folder
replacement under a user's strict `3+1` policy, and never treat a working normal
variant as proof that bilingual works.
