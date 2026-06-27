$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$version = "2026.06.27.1"
$stage = Join-Path $root ".build\liquidctl"
$binary = Join-Path $stage "bin\liquidctl"
$dist = Join-Path $root "dist"
$bundle = Join-Path $dist "liquidctl-$version.tgz"

if (-not (Test-Path $binary)) {
    throw "Missing Linux binary at $binary. Build it with scripts/build-release.sh on Linux or download the GitHub Actions artifact."
}

Copy-Item -Recurse -Force (Join-Path $root "source\usr\local\emhttp\plugins\liquidctl\*") $stage
Set-Content -Encoding ASCII -Path (Join-Path $stage "VERSION") -Value $version
New-Item -ItemType Directory -Force -Path $dist | Out-Null
tar -C (Join-Path $root ".build") -czf $bundle liquidctl

$hash = Get-FileHash -Algorithm MD5 $bundle
Write-Host "Bundle: $bundle"
Write-Host "MD5: $($hash.Hash.ToLowerInvariant())"
