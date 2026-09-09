[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string]$KnownGoodPak,

    [Parameter(Mandatory)]
    [string]$CandidatePak,

    [Parameter(Mandatory)]
    [string]$UnrealPak,

    [string]$OutputPath
)

$ErrorActionPreference = 'Stop'

function Get-PakLayout {
    param([Parameter(Mandatory)][string]$Path)

    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        throw "PAK not found: $Path"
    }

    $output = & $UnrealPak $Path -List 2>&1
    if ($LASTEXITCODE -ne 0) {
        throw "UnrealPak could not read candidate: $Path`n$output"
    }

    $mount = $output |
        Select-String -Pattern 'Mount point\s+(.+)$' |
        ForEach-Object { $_.Matches[0].Groups[1].Value.Trim() } |
        Select-Object -First 1
    $entries = $output |
        Select-String -Pattern '"([^"]+)"\s+offset:' |
        ForEach-Object { $_.Matches[0].Groups[1].Value } |
        Sort-Object -Unique
    $locres = $entries |
        Where-Object { $_ -match '^Localization/.+\.locres$' } |
        Sort-Object

    [pscustomobject]@{
        path = (Resolve-Path -LiteralPath $Path).Path
        sha256 = (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash.ToLowerInvariant()
        mountPoint = $mount
        entryCount = @($entries).Count
        locresPaths = @($locres)
    }
}

if (-not (Test-Path -LiteralPath $UnrealPak -PathType Leaf)) {
    throw "UnrealPak not found: $UnrealPak"
}

$baseline = Get-PakLayout -Path $KnownGoodPak
$candidate = Get-PakLayout -Path $CandidatePak
$missing = @($baseline.locresPaths | Where-Object { $_ -notin $candidate.locresPaths })
$added = @($candidate.locresPaths | Where-Object { $_ -notin $baseline.locresPaths })

$result = [ordered]@{
    knownGood = $baseline
    candidate = $candidate
    comparison = [ordered]@{
        mountPointMatches = ($baseline.mountPoint -eq $candidate.mountPoint)
        missingLocresPaths = $missing
        addedLocresPaths = $added
        routingRegression = ($missing.Count -gt 0 -or $baseline.mountPoint -ne $candidate.mountPoint)
        byteIdentical = ($baseline.sha256 -eq $candidate.sha256)
    }
}

$json = $result | ConvertTo-Json -Depth 6
if ($OutputPath) {
    $parent = Split-Path -Parent $OutputPath
    if ($parent) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }
    Set-Content -LiteralPath $OutputPath -Value $json -Encoding utf8
}
$json
