# Runtime Regression Triage

Read this reference when an ASA localization patch is structurally valid but a game
screenshot still shows English, loses Chinese that a previous version displayed, or
the client crashes after installation.

## Evidence First

Keep the last game-proven package unchanged. Gather the game version, selected
normal/bilingual mode, exact installed filenames, screenshot, and a target-compatible
UnrealPak layout comparison before rebuilding anything. ZIP CRC, `retoc verify`, and
asset readback are structural checks only; none proves that the ASA client mounts the
candidate on the affected UI surface.

Run:

```powershell
.\scripts\compare-pak-layout.ps1 `
  -KnownGoodPak 'D:\Patches\working\pakchunk9999-Windows_P.pak' `
  -CandidatePak 'D:\Patches\candidate\pakchunk9999-Windows_P.pak' `
  -UnrealPak 'D:\UE\Engine\Binaries\Win64\UnrealPak.exe' `
  -OutputPath '.\audit\pak-layout.json'
```

## Classify Before Repairing

### 1. PAK format failure

**Evidence:** the client reports `Invalid pak file version (...)`, or the
target-compatible UnrealPak cannot list/test the candidate.

**Repair:** rebuild the identical response file with a client-compatible UnrealPak,
then repeat the layout readback.

**Do not:** change translations, LocRes namespaces, or asset paths first. Do not
publish the candidate.

### 2. Language routing or mount-path regression

**Evidence:** a previous package works, the candidate has fewer or different
`Localization/.../*.locres` paths, a changed mount point, or missing fallback buckets
such as `ja`/`de` despite a Chinese UI setting.

**Repair:** preserve the known-good overlay bytes as an immutable recovery baseline.
Restore the complete proven mount and all fallback buckets, then make only a separate
candidate for new coverage.

**Do not:** compress the paths to only `zh`/`zh-Hans`, replace the normal package
while debugging bilingual behavior, or use an asset-container experiment as a fix.

### 3. Direct asset text is not mounted

**Evidence:** the final LocRes contains the expected key, but player-facing direct
asset fields (for example item display names embedded in cooked assets) remain English.
A proposed replacement container may pass `retoc verify` while the client never loads
it.

**Repair:** identify the actual client-scanned mount and verify it in game with a
minimal, isolated asset candidate. Keep normal and bilingual LocRes packages intact.

**Do not:** fuse experimental assets into the root official localization container,
or claim success from binary field readback alone.

### 4. Exact source/key mismatch

**Evidence:** mount layout is unchanged and the affected text is genuinely absent from
the final LocRes or uses a different FString/FText source due to whitespace, casing,
CRLF/LF, RichColor tags, namespace, or a mod update.

**Repair:** inventory the actual updated asset, add the complete source variant, and
audit its related visible text family.

**Do not:** translate isolated English fragments or fabricate a key from a screenshot.

## Release Decision

- A normal Chinese recovery may reuse a game-proven normal overlay exactly, but the
  release notes must state that it is a recovery and not a new bilingual fix.
- Release normal and bilingual artifacts only from their matching immutable baselines.
- A package can pass archive, PAK, LocRes, and container checks yet still be only a
  candidate. Mark it as such until a game screenshot confirms the target surface.
- Include the classification and baseline comparison JSON with the release audit.
