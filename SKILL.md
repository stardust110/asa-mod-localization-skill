---
name: asa-mod-localization-release
description: "Create and validate reusable ARK: Survival Ascended mod localization patches, including separate official normal and bilingual baselines. Use for ASA mod archive localization, coverage repair, and local release packaging; not for ordinary game translation questions."
---

# ASA Mod Localization Release

Create a usable, portable ASA mod localization package. This standard `SKILL.md`
folder is designed for skills-compatible agents; optional client metadata must not
be required for the workflow. The default deliverable is a
local pair of verified normal and bilingual archives plus checksums; publishing them
to a hosting service is outside this skill. Treat package inspection and in-game
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

## Tool Readiness

Before unpacking or building, read [tool-bootstrap.md](references/tool-bootstrap.md)
and [tool-sources.md](references/tool-sources.md), then probe the local environment. Do not assume the user already owns an Unreal
package tool. Report the exact missing capability and a compatible tool category;
ask for explicit permission before downloading, installing, updating, or changing
system configuration. Never substitute a tool that changes the package format or
claim a patch was built when extraction was unavailable.

## Terminology Is A Dependency

Before translating ASA creatures, items, materials, mechanics, or UI, follow the
project `AGENTS.md` and load its designated TSV/JSON terminology sources. Prefer
confirmed ASA terminology over literal English translation. New confirmed terms need
an English source, Chinese translation, category, evidence, and scope rule; unknown
proper names remain English or `中文（English）` until verified.

## Build Two Deliberate Variants

- Normal mod localization must copy the official *normal* package triplet
  (`ShooterGame-Windows_P.pak`, `.ucas`, `.utoc`).
- Bilingual mod localization must separately copy the official *bilingual* triplet.
  Never build both variants from the same official `.pak` or expect a mod-only
  overlay to make base-game names bilingual.
- Keep a single mod localization overlay pak. Do not package obsolete duplicate
  overlay names.
- Build archives in the workspace first. External distribution folders can reject or
  truncate writes; copy only a verified final artifact out afterward.

## Portable Workflow

- Accept a mod archive or unpacked mod directory, a normal official baseline, and,
  when bilingual output is requested, a bilingual official baseline.
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
3. Each zip passes CRC/integrity testing and contains the expected official triplet,
   localization overlay, and installation readme.
4. The normal and bilingual archives contain the respective, distinct official `.pak`
   hashes.
5. A SHA256 manifest covers the final archives.
