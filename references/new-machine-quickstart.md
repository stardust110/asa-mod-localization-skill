# New-Machine Quickstart

## Minimal Inputs

| Goal | Required inputs |
| --- | --- |
| Audit or translate an already unpacked mod | Unpacked mod directory and a workspace |
| Inventory a packed mod | Mod package plus a compatible IoStore extractor |
| Build a normal patch | Mod source, normal official triplet, and compatible UnrealPak |
| Build a bilingual patch | Everything for normal output plus a distinct bilingual official triplet |

Terminology files, prior patches, and screenshots are optional inputs, but provide
important context and should be used when available.

## Run Preflight

From the skill repository on Windows:

```powershell
.\scripts\preflight.ps1 `
  -ModSource 'D:\Mods\example-windows.zip' `
  -NormalBaseline 'D:\ASA\official-normal' `
  -BilingualBaseline 'D:\ASA\official-bilingual' `
  -UnrealPak 'D:\UE\Engine\Binaries\Win64\UnrealPak.exe'
```

The output is JSON so an agent can consume it without guessing. Exit code `0` means
every requested build path is ready. Exit code `2` means one or more stages are
blocked; read the `missing` list rather than retrying blindly.

## Interpret The Result

- `inventory.ready`: the agent can extract or read the supplied mod source and build
  a player-facing text inventory.
- `normalBuild.ready`: the agent can create and validate a normal patch after
  translation.
- `bilingualBuild.ready`: the agent can create and validate a bilingual patch using
  a separate official bilingual baseline.

An omitted bilingual baseline means bilingual output is not requested, not a
failure. A source directory is treated as already unpacked; a packed archive still
needs a compatible extractor.

## Clean-Machine Outcome Matrix

| Available state | Deliverable |
| --- | --- |
| Source only | Input report and exact missing-tool list |
| Source plus inventory | Translation map, terminology decisions, and coverage audit |
| Normal build ready | Verified normal install archive and checksum manifest |
| Normal plus bilingual build ready | Verified normal and bilingual archives, each with its matching baseline |

Never tell a user that a translated map is an installable patch until package build
and integrity validation complete.
