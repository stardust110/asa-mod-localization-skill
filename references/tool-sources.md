# Tool Sources And Licensing

## retoc

- Purpose: inspect and unpack Unreal IoStore `.utoc` / `.ucas` containers.
- Official source and releases: <https://github.com/trumank/retoc>
- Version currently used by the optional bootstrap: `v0.1.5`.
- License: MIT for retoc itself, as stated in its upstream repository.
- Installation policy: download only from the official release after user approval;
  save under the selected workspace and record the executable SHA-256.

## UnrealPak

UnrealPak is normally distributed with a legal Unreal Engine installation. Do not
bundle or redistribute a copy in this skill. Detect a user-provided compatible
installation, report its path and version, and ask the user to install Unreal Engine
or provide a legitimate tool path when it is missing.

## Third-Party DLLs And Unlicensed Binaries

Do not redistribute Oodle-related DLLs, game-extracted DLLs, or utilities whose
license and original distribution source cannot be verified. A user's local copy is
not evidence that the file may be republished.
