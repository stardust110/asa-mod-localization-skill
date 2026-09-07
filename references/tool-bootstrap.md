# Tool Bootstrap And Capability Checks

## Goal

Make the workflow usable on a clean machine without silently changing it. A skill
coordinates an agent; it does not itself contain a universal Unreal parser. Before
translation, determine whether the machine can inspect, extract, rebuild, and
validate the supplied package.

## Probe First

Check for these capabilities in the active workspace, configured tool paths, and
the system PATH:

| Capability | Typical compatible tool category | Required for |
| --- | --- | --- |
| Archive inspection and CRC | ZIP utility or language runtime | Reading and validating distribution archives |
| Unreal IoStore extraction | A compatible `.utoc` / `.ucas` extractor | Inventorying packed mod text |
| Unreal pak build or replacement | A version-compatible Unreal packaging tool | Producing a localization overlay |
| Localization resource conversion | A compatible locres parser/converter | Editing localization resources when required |
| File hashing | System SHA-256 utility or language runtime | Final integrity manifest |

Use project-provided tools before recommending a download. Verify tool versions
against the supplied package format with a harmless inventory or listing operation
before editing any asset.

## Permission Boundary

- Detection, version reporting, and read-only inspection may run immediately.
- Downloading an executable, installing a package, changing PATH, adding a registry
  entry, changing security settings, or replacing a user tool requires explicit
  user approval first.
- State the tool name, source, capability it provides, and intended install location
  in that approval request.
- Prefer a portable, workspace-local tool directory when the user approves, rather
  than modifying global system configuration.

## Redistribution Boundary

Do not upload a tool copied from one user's computer unless its complete
redistribution terms, source, version, and bundled dependencies are known. In
particular, a permissively licensed executable can still be accompanied by a DLL
with separate proprietary terms. Prefer an official upstream download and record
the version and SHA-256 after installation.

For Windows, this skill provides `scripts/bootstrap-retoc.ps1`. Its default mode is
read-only detection. The `-InstallRetoc` mode downloads the official retoc v0.1.5
release into a caller-selected workspace directory, then verifies that it launches.
Running that mode is an explicit user-approved installation action; it must never be
invoked silently by an agent. It does not download UnrealPak, Oodle DLLs, or tools
with unknown redistribution rights.

## Fallbacks

1. If extraction is unavailable, still collect screenshots, archive metadata, and
   existing translation maps; produce a pending-tools report rather than pretending
   that source coverage was audited.
2. If text can be exported but no packer is available, complete the translation map
   and validation report, label the package build as blocked, and retain exact keys
   for a later build.
3. If a tool cannot read the package, do not retry by changing format assumptions.
   Record the archive type, tool version, and error, then select another compatible
   tool only after verifying its format support.

## Completion Rule

Only mark a runnable patch complete after an extraction/build path and all package
checks succeed. A terminology file, translated CSV, or screenshots alone are useful
intermediate artifacts, not an installable patch.
