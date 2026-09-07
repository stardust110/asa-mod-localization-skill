[CmdletBinding()]
param(
    [string]$ToolRoot = (Join-Path $PSScriptRoot '..\tools'),
    [switch]$InstallRetoc,
    [string]$RetocVersion = '0.1.5'
)

$ErrorActionPreference = 'Stop'
$ToolRoot = [IO.Path]::GetFullPath($ToolRoot)
$localRetoc = Join-Path $ToolRoot "retoc-v$RetocVersion\retoc.exe"
$legacyLocalRetoc = Join-Path $ToolRoot 'retoc\retoc.exe'
$commandRetoc = Get-Command retoc.exe -ErrorAction SilentlyContinue

function Get-RetocStatus {
    param([string]$Path, [string]$Source)

    if (-not (Test-Path -LiteralPath $Path)) {
        return $null
    }

    $version = (& $Path --version 2>&1 | Select-Object -First 1).ToString().Trim()
    [pscustomobject]@{
        found = $true
        source = $Source
        path = $Path
        version = $version
        sha256 = (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
    }
}

$status = Get-RetocStatus -Path $localRetoc -Source 'workspace'
if (-not $status) {
    $status = Get-RetocStatus -Path $legacyLocalRetoc -Source 'workspace'
}
if (-not $status -and $commandRetoc) {
    $status = Get-RetocStatus -Path $commandRetoc.Source -Source 'PATH'
}

if ($status) {
    $status | ConvertTo-Json -Depth 3
    exit 0
}

if (-not $InstallRetoc) {
    [pscustomobject]@{
        found = $false
        action = 'Run this script again with -InstallRetoc only after approving an official upstream download.'
        upstream = 'https://github.com/trumank/retoc/releases/tag/v0.1.5'
        target = $localRetoc
    } | ConvertTo-Json -Depth 3
    exit 2
}

$asset = 'retoc_cli-x86_64-pc-windows-msvc.zip'
$url = "https://github.com/trumank/retoc/releases/download/v$RetocVersion/$asset"
$staging = Join-Path $env:TEMP "retoc-$RetocVersion.zip"
$destination = Split-Path -Parent $localRetoc

New-Item -ItemType Directory -Path $destination -Force | Out-Null
Invoke-WebRequest -Uri $url -OutFile $staging
Expand-Archive -LiteralPath $staging -DestinationPath $destination -Force

$status = Get-RetocStatus -Path $localRetoc -Source 'official-release'
if (-not $status) {
    throw "retoc.exe was not found after extracting the official release to $destination"
}

$status | ConvertTo-Json -Depth 3
