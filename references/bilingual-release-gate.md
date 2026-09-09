# Bilingual Release Gate

Use this gate whenever the requested output should display both Chinese and English
for ASA original-game or mod content. It addresses two independent runtime routes:
the complete original-game bilingual dictionary and the mod localization fallback
layout. Do not collapse them into one generic "bilingual works" check.

## Assemble Only Proven Components

1. Select a full bilingual dictionary baseline that has already rendered original-game
   bilingual text in the target ASA client.
2. Select a game-proven fallback layout for mod text, including every observed mount
   and language path. It may contain `Game` and `ShooterGame` with `zh`, `zh-Hans`,
   `ja`, and `de`; use the actual proven baseline rather than assuming a universal
   list.
3. Copy the complete dictionary content into every required fallback path. Do not use
   a sparse mod-only LocRes as the content baseline, and do not remove paths merely
   because they look redundant.
4. Make translation corrections as exact source/key changes only. Preserve the
   baseline mount point, official normal/bilingual separation, and fallback layout.

## Structural Gate

- Run `scripts/compare-pak-layout.ps1` against the known-good routing baseline.
  Block release if the mount point changes or a required LocRes path is missing.
- Use a target-client-compatible UnrealPak to test/list the new overlay.
- Verify ZIP CRC and final SHA-256 after all output bytes are fixed.
- Read back the corrected exact term from the final LocRes; check that its obsolete
  translation is absent.

## Runtime Matrix

Before publishing, collect and attach these independent results:

| Surface | Required evidence | Example expected behavior |
| --- | --- | --- |
| Original game | In-game screenshot of a base creature/item | Chinese name plus English original, such as `南方巨兽龙 [Giganotosaurus]` |
| Mod text | In-game screenshot from the affected mod | Chinese plus English original, such as `衰变之嗣[Scion of Degeneration]` |
| Direct asset UI, when applicable | In-game screenshot of a skin/item catalogue or tooltip | Translated display title plus English original, not only a LocRes readback |
| Corrected terminology | In-game or final LocRes readback | Exact approved term, such as `X-Dream 喷火龙[X-Dream Dragon]` |

If original-game text works but mod text does not, diagnose fallback routing. If mod
text works but original-game text does not, diagnose the complete bilingual dictionary
content. Do not alter the normal-Chinese package to solve either case.

## Release Notes

State the two baselines, the structural checks, the runtime matrix results, the
normal/bilingual mutual-exclusion rule, and any remaining unverified surface. A
candidate is not a release until both original-game and mod rows pass.
