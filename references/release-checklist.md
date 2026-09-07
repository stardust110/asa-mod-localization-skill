# Release Checklist

## Source And Scope

- Record the supplied mod archive version and the module name shown to players.
- For a newly introduced mod, create a mod-specific source inventory and translation
  map rather than adding opaque replacements to an unrelated mod's list. Share only
  generic ASA terminology through the central glossary.
- Start with full player-facing coverage: names, descriptions, engrams, buffs, HUD,
  status messages, tool modes, and books. Defer only strings that are demonstrably
  technical, not player-facing, or semantically unconfirmed.
- If a source includes novel creatures, items, or fictional proper names, check the
  ASA glossary first; if it is not confirmed, retain English or use `中文（English）`
  and record it as pending instead of inventing a standard term.
- Preserve pre-existing confirmed translations unless source text changed.
- Compare update archives with the previous package when available. Focus translation
  review on new or changed player-facing strings rather than raw string volume.
- For screenshots, retain the complete source string. Unreal `FText` keys can change
  with CRLF/LF, punctuation, casing, whitespace, and RichColor markup.

## Translation Quality

- Translate complete sentences, not individual English tokens pasted into a Chinese
  sentence. This prevents the common mixed-language tooltip failure.
- Preserve placeholders such as `{Test}`, `{NumLevels}`, `{1}`, `%`, and markup.
- Preserve line layout unless an exact source variant proves a different layout is
  required. Add both CRLF and LF keys only when the source exists in both forms.
- Put bilingual formatting only on display-name/item-name sources. Descriptions stay
  natural Chinese unless the user explicitly asks for bilingual descriptions.

## Packaging

- Use official normal files for the normal archive and official bilingual files for
  the bilingual archive. Hash the embedded `ShooterGame-Windows_P.pak` from each zip
  and compare it with the intended official source.
- Validate `ZipFile.testzip()` or equivalent CRC checks. Verify the root includes:
  `ShooterGame-Windows_P.pak`, `.ucas`, `.utoc`, the current overlay pak, and an
  installation readme.
- Generate `SHA256SUMS.txt` after final archive bytes are fixed.
- Keep the package generic: archive names, workspace root, and destination folder
  must be configurable. Do not require a specific release host or account.

## In-Game Follow-Up

- A package check cannot prove runtime coverage. If a player screenshot exposes an
  untranslated tooltip, add the exact source to the next patch, then expand the audit
  to its related item family and source variants.
- Explain installation as mutually exclusive: normal or bilingual, never both.
