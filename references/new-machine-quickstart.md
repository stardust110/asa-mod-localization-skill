# New-Machine Quickstart

## Minimal Inputs

| Goal | Required inputs |
| --- | --- |
| Audit or translate an already unpacked mod | Unpacked mod directory and a workspace |
| Inventory a packed mod | Mod package plus a compatible IoStore extractor |
| Build a mod localization overlay (default) | Mod source and compatible UnrealPak |
| Build a normal fused package | Overlay inputs plus a normal official triplet |
| Build a bilingual fused package | Overlay inputs plus a distinct bilingual official triplet |

Terminology files, prior patches, and screenshots are optional inputs, but provide
important context and should be used when available.

## Run Preflight

From the skill repository on Windows:

```powershell
.\scripts\preflight.ps1 `
  -ModSource 'D:\Mods\example-windows.zip' `
  -UnrealPak 'D:\UE\Engine\Binaries\Win64\UnrealPak.exe'
```

The output is JSON so an agent can consume it without guessing. Exit code `0` means
every requested build path is ready. Exit code `2` means one or more stages are
blocked; read the `missing` list rather than retrying blindly.

## Interpret The Result

- `inventory.ready`: the agent can extract or read the supplied mod source and build
  a player-facing text inventory.
- `overlayBuild.ready`: the agent can create and validate an installable mod
  localization overlay. No official base-game triplet is needed.
- `normalFusedBuild.ready`: when fused mode is requested, the agent can create a
  self-contained normal package with a normal official baseline.
- `bilingualFusedBuild.ready`: when a bilingual fused baseline is supplied, the
  agent can create the matching self-contained bilingual package.

To check optional fused output, pass `-DistributionMode fused` and the matching
baseline paths:

```powershell
.\scripts\preflight.ps1 `
  -DistributionMode fused `
  -ModSource 'D:\Mods\example-windows.zip' `
  -NormalBaseline 'D:\ASA\official-normal' `
  -BilingualBaseline 'D:\ASA\official-bilingual' `
  -UnrealPak 'D:\UE\Engine\Binaries\Win64\UnrealPak.exe'
```

A source directory is treated as already unpacked; a packed archive still needs a
compatible extractor. Preflight confirms that a tool can launch, not that it is the
right Unreal engine version for a final package.

## Clean-Machine Outcome Matrix

| Available state | Deliverable |
| --- | --- |
| Source only | Input report and exact missing-tool list |
| Source plus inventory | Translation map, terminology decisions, and coverage audit |
| Overlay build ready | Verified mod overlay archive, checksum manifest, and base-package compatibility note |
| Normal fused build ready | Verified self-contained normal archive with its matching baseline |
| Normal plus bilingual fused build ready | Verified fused normal and bilingual archives, each with its matching baseline |

Never tell a user that a translated map is an installable patch until package build
and integrity validation complete.
