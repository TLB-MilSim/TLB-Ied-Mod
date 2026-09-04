<#
    Builds @TLB - IEDs from source, then signs it.

    Usage:
      .\build.ps1                     # build + sign with the default key
      .\build.ps1 -Deploy             # also copy into the Arma !Workshop folder
      .\build.ps1 -KeyName TLBMisc3   # sign with one of your existing keys
#>
param(
    [string] $KeyName = "TLBIEDs01",
    [switch] $Deploy
)

$ErrorActionPreference = "Stop"

$Root      = $PSScriptRoot
$Tools     = "E:\SteamLibrary\steamapps\common\Arma 3 Tools"
$Builder   = Join-Path $Tools "AddonBuilder\AddonBuilder.exe"
$SignFile  = Join-Path $Tools "DSSignFile\DSSignFile.exe"
$CreateKey = Join-Path $Tools "DSSignFile\DSCreateKey.exe"
$WorkshopDir = "E:\SteamLibrary\steamapps\common\Arma 3\!Workshop"

$ModName  = "@TLB - IEDs"
# AddonBuilder ignores $PBOPREFIX$ and would otherwise name the prefix after the
# source folder ("tlb_ieds"), silently breaking every tlb\ieds path in config.
$Prefix   = "tlb\ieds"
$Source   = Join-Path $Root "addons\tlb_ieds"
$Dist     = Join-Path $Root "dist\$ModName"
$AddonOut = Join-Path $Dist "addons"
$KeyOut   = Join-Path $Dist "keys"
$KeyStore = Join-Path $Root "private"

foreach ($p in @($Builder, $SignFile, $CreateKey)) {
    if (-not (Test-Path $p)) { throw "Missing Arma 3 Tools component: $p" }
}

# --- clean ---------------------------------------------------------------
if (Test-Path $Dist) { Remove-Item $Dist -Recurse -Force }
New-Item -ItemType Directory -Force -Path $AddonOut, $KeyOut, $KeyStore | Out-Null

# --- pack ----------------------------------------------------------------
# -packonly: no binarisation. There are no models or textures here, only config
# and SQF, so binarising would buy nothing and only add a failure mode.
Write-Host "Packing $Source ..." -ForegroundColor Cyan
# AddonBuilder logs to stderr. Under $ErrorActionPreference = "Stop", PowerShell
# 5.1 turns native stderr into a terminating NativeCommandError, so drop to
# Continue for the call itself and judge success by the exit code instead.
$PrevEAP = $ErrorActionPreference
$ErrorActionPreference = "Continue"
try {
    & $Builder $Source $AddonOut -clear -packonly "-prefix=$Prefix"
} finally {
    $ErrorActionPreference = $PrevEAP
}
if ($LASTEXITCODE -ne 0) { throw "AddonBuilder failed with exit code $LASTEXITCODE" }

$Pbo = Join-Path $AddonOut "tlb_ieds.pbo"
if (-not (Test-Path $Pbo)) { throw "Expected PBO was not produced: $Pbo" }

# Read the prefix back out of the PBO header. A wrong prefix produces no build
# error at all - it only shows up in game as "Script ... not found".
$HeaderBytes = ([System.IO.File]::ReadAllBytes($Pbo))[0..255]
$HeaderText  = [System.Text.Encoding]::ASCII.GetString($HeaderBytes)
$Fields      = $HeaderText -split "`0"
$Idx         = [array]::IndexOf($Fields, "prefix")
if ($Idx -lt 0) { throw "PBO header has no prefix field" }
$Actual = $Fields[$Idx + 1]
if ($Actual -ne $Prefix) { throw "PBO prefix is '$Actual', expected '$Prefix'" }
Write-Host "  prefix verified: $Actual" -ForegroundColor DarkGray

Copy-Item (Join-Path $Root "mod.cpp") (Join-Path $Dist "mod.cpp") -Force

# --- key -----------------------------------------------------------------
$PrivateKey = Join-Path $KeyStore "$KeyName.biprivatekey"
$PublicKey  = Join-Path $KeyStore "$KeyName.bikey"

if (-not (Test-Path $PrivateKey)) {
    $Existing = Join-Path $Tools "DSSignFile\$KeyName.biprivatekey"
    if (Test-Path $Existing) {
        Write-Host "Using existing key $KeyName from Arma 3 Tools." -ForegroundColor Cyan
        Copy-Item $Existing $PrivateKey -Force
        Copy-Item (Join-Path $Tools "DSSignFile\$KeyName.bikey") $PublicKey -Force
    } else {
        Write-Host "Creating new signing key $KeyName ..." -ForegroundColor Cyan
        Push-Location $KeyStore
        try { & $CreateKey $KeyName } finally { Pop-Location }
    }
}
if (-not (Test-Path $PrivateKey)) { throw "Signing key not available: $PrivateKey" }

# --- sign ----------------------------------------------------------------
Write-Host "Signing with $KeyName ..." -ForegroundColor Cyan
$PrevEAP = $ErrorActionPreference
$ErrorActionPreference = "Continue"
try {
    & $SignFile $PrivateKey $Pbo
} finally {
    $ErrorActionPreference = $PrevEAP
}
if ($LASTEXITCODE -ne 0) { throw "DSSignFile failed with exit code $LASTEXITCODE" }

Copy-Item $PublicKey $KeyOut -Force

# --- deploy --------------------------------------------------------------
if ($Deploy) {
    $Target = Join-Path $WorkshopDir $ModName
    Write-Host "Deploying to $Target ..." -ForegroundColor Cyan
    if (Test-Path $Target) { Remove-Item $Target -Recurse -Force }
    Copy-Item $Dist $Target -Recurse -Force
}

Write-Host ""
Write-Host "Built $ModName" -ForegroundColor Green
Get-ChildItem $Dist -Recurse -File | ForEach-Object {
    "  {0,-45} {1,8:N0} bytes" -f $_.FullName.Substring($Dist.Length + 1), $_.Length
}
