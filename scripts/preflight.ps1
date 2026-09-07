[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string]$ModSource,
    [ValidateSet('overlay', 'fused')]
    [string]$DistributionMode = 'overlay',
    [ValidateSet('normal', 'bilingual')]
    [string]$OverlayTarget = 'normal',
    [string]$NormalBaseline,
    [string]$BilingualBaseline,
    [string]$UnrealPak,
    [string]$RetocPath,
    [string]$Workspace = (Join-Path (Get-Location) 'asa-localization-work')
)

$ErrorActionPreference = 'Stop'

function Resolve-ExistingFile {
    param([string[]]$Candidates)

    foreach ($candidate in $Candidates) {
        if ($candidate -and (Test-Path -LiteralPath $candidate -PathType Leaf)) {
            return [IO.Path]::GetFullPath($candidate)
        }
    }
    return $null
}

function Test-ToolLaunch {
    param([string]$Path, [string[]]$Arguments)

    if (-not $Path) {
        return [pscustomobject]@{ path = $null; launched = $false; exitCode = $null }
    }

    try {
        $null = & $Path @Arguments 2>&1
        return [pscustomobject]@{ path = $Path; launched = $true; exitCode = $LASTEXITCODE }
    }
    catch {
        return [pscustomobject]@{ path = $Path; launched = $false; exitCode = $null }
    }
}

function Test-OfficialTriplet {
    param([string]$Path)

    $names = @('ShooterGame-Windows_P.pak', 'ShooterGame-Windows_P.ucas', 'ShooterGame-Windows_P.utoc')
    if (-not $Path -or -not (Test-Path -LiteralPath $Path)) {
        return [pscustomobject]@{ provided = [bool]$Path; ready = $false; type = $null; missing = $names }
    }

    if (Test-Path -LiteralPath $Path -PathType Container) {
        $missing = @($names | Where-Object { -not (Test-Path -LiteralPath (Join-Path $Path $_) -PathType Leaf) })
        return [pscustomobject]@{ provided = $true; ready = ($missing.Count -eq 0); type = 'directory'; missing = $missing }
    }

    if ([IO.Path]::GetExtension($Path).ToLowerInvariant() -ne '.zip') {
        return [pscustomobject]@{ provided = $true; ready = $false; type = 'unsupported-file'; missing = $names }
    }

    Add-Type -AssemblyName System.IO.Compression
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    $archive = [IO.Compression.ZipFile]::OpenRead([IO.Path]::GetFullPath($Path))
    try {
        $entryNames = @($archive.Entries | ForEach-Object Name)
        $missing = @($names | Where-Object { $_ -notin $entryNames })
        return [pscustomobject]@{ provided = $true; ready = ($missing.Count -eq 0); type = 'zip'; missing = $missing }
    }
    finally {
        $archive.Dispose()
    }
}

$ModSource = [IO.Path]::GetFullPath($ModSource)
$Workspace = [IO.Path]::GetFullPath($Workspace)
$skillRoot = Split-Path -Parent $PSScriptRoot
$workspaceRetoc = Join-Path $Workspace 'tools\retoc-v0.1.5\retoc.exe'
$legacyWorkspaceRetoc = Join-Path $Workspace 'tools\retoc\retoc.exe'
$pathRetoc = (Get-Command retoc.exe -ErrorAction SilentlyContinue).Source
$retoc = Resolve-ExistingFile @($RetocPath, $workspaceRetoc, $legacyWorkspaceRetoc, $pathRetoc)
$unrealPak = Resolve-ExistingFile @($UnrealPak, $env:ASA_UNREALPAK, (Get-Command UnrealPak.exe -ErrorAction SilentlyContinue).Source)
$retocProbe = Test-ToolLaunch -Path $retoc -Arguments @('--version')
$unrealPakProbe = Test-ToolLaunch -Path $unrealPak -Arguments @('-help')
$sourceExists = Test-Path -LiteralPath $ModSource
$sourceIsDirectory = $sourceExists -and (Test-Path -LiteralPath $ModSource -PathType Container)
$fusedRequested = $DistributionMode -eq 'fused'
$normalRequested = $fusedRequested
$bilingualRequested = $fusedRequested -and -not [string]::IsNullOrWhiteSpace($BilingualBaseline)
$normal = if ($normalRequested) { Test-OfficialTriplet -Path $NormalBaseline } else { [pscustomobject]@{ provided = $false; ready = $true; type = 'not-required-for-overlay'; missing = @() } }
$bilingual = if ($bilingualRequested) { Test-OfficialTriplet -Path $BilingualBaseline } else { [pscustomobject]@{ provided = $false; ready = $true; type = 'not-requested'; missing = @() } }

$missing = [System.Collections.Generic.List[string]]::new()
if (-not $sourceExists) { $missing.Add("Mod source not found: $ModSource") }
if ($sourceExists -and -not $sourceIsDirectory -and -not $retocProbe.launched) { $missing.Add('Packed mod source requires a compatible IoStore extractor such as retoc.') }
if (-not $unrealPakProbe.launched) { $missing.Add('Compatible UnrealPak executable is missing or cannot launch for package build.') }
if ($normalRequested -and -not $normal.ready) { $missing.Add('Normal official baseline triplet is missing or incomplete for fused output.') }
if ($bilingualRequested -and -not $bilingual.ready) { $missing.Add('Bilingual official baseline triplet is missing or incomplete.') }

$inventoryReady = $sourceExists -and ($sourceIsDirectory -or $retocProbe.launched)
$overlayBuildReady = $inventoryReady -and $unrealPakProbe.launched
$normalFusedBuildReady = $fusedRequested -and $overlayBuildReady -and $normal.ready
$bilingualFusedBuildReady = $bilingualRequested -and $normalFusedBuildReady -and $bilingual.ready

$result = [ordered]@{
    workspace = $Workspace
    distribution = [ordered]@{ mode = $DistributionMode; overlayTarget = $OverlayTarget }
    source = [ordered]@{ path = $ModSource; exists = $sourceExists; type = if ($sourceIsDirectory) { 'unpacked-directory' } elseif ($sourceExists) { 'packed-file' } else { 'missing' } }
    tools = [ordered]@{ retoc = $retocProbe; unrealPak = $unrealPakProbe; sha256 = [bool](Get-Command Get-FileHash -ErrorAction SilentlyContinue) }
    normalBaseline = $normal
    bilingualBaseline = $bilingual
    inventory = [ordered]@{ ready = $inventoryReady }
    overlayBuild = [ordered]@{ ready = $overlayBuildReady }
    normalFusedBuild = [ordered]@{ requested = $fusedRequested; ready = $normalFusedBuildReady }
    bilingualFusedBuild = [ordered]@{ requested = $bilingualRequested; ready = $bilingualFusedBuildReady }
    missing = @($missing)
}

$result | ConvertTo-Json -Depth 6
if ($overlayBuildReady -and (-not $fusedRequested -or ($normalFusedBuildReady -and (-not $bilingualRequested -or $bilingualFusedBuildReady)))) {
    exit 0
}
exit 2
