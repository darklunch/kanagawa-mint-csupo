# Kanagawa Mint-Csupo — build all submission-ready packages into dist/
# Usage: powershell -File tools\build-packages.ps1
# dist/ is gitignored; artifacts are attached to GitHub Releases instead.

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$dist = Join-Path $root 'dist'
New-Item -ItemType Directory -Force $dist | Out-Null
Remove-Item "$dist\*" -Recurse -Force -ErrorAction SilentlyContinue

Write-Host 'Building Kanagawa Mint-Csupo packages...' -ForegroundColor Green

# Firefox (AMO): manifest.json at zip root
Compress-Archive -Path "$root\ports\firefox\manifest.json" -DestinationPath "$dist\kanagawa-mint-csupo-firefox.zip"
Write-Host '  firefox     -> kanagawa-mint-csupo-firefox.zip'

# Chromium (CWS): manifest.json at zip root
Compress-Archive -Path "$root\ports\chromium\manifest.json" -DestinationPath "$dist\kanagawa-mint-csupo-chromium.zip"
Write-Host '  chromium    -> kanagawa-mint-csupo-chromium.zip'

# Vivaldi (themes.vivaldi.net): zip containing settings.json
$tmp = Join-Path $env:TEMP 'kmc-vivaldi-build'
New-Item -ItemType Directory -Force $tmp | Out-Null
Copy-Item "$root\ports\vivaldi\kanagawa-mint-csupo-vivaldi.json" "$tmp\settings.json" -Force
Compress-Archive -Path "$tmp\settings.json" -DestinationPath "$dist\kanagawa-mint-csupo-vivaldi.zip"
Remove-Item $tmp -Recurse -Force
Write-Host '  vivaldi     -> kanagawa-mint-csupo-vivaldi.zip'

# Obsidian: manifest.json + theme.css at zip root (also usable as folder drop-in)
Compress-Archive -Path "$root\ports\obsidian\manifest.json", "$root\ports\obsidian\theme.css" -DestinationPath "$dist\kanagawa-mint-csupo-obsidian.zip"
Write-Host '  obsidian    -> kanagawa-mint-csupo-obsidian.zip'

# Zed: zip of the extension folder (dev-install convenience; registry uses git)
Compress-Archive -Path "$root\ports\zed\*" -DestinationPath "$dist\kanagawa-mint-csupo-zed.zip"
Write-Host '  zed         -> kanagawa-mint-csupo-zed.zip'

# Windows bundle: theme, reg files, apply script, terminal scheme, setup doc
Compress-Archive -Path "$root\ports\windows\*", "$root\ports\windows-terminal\kanagawa-mint-csupo.json" -DestinationPath "$dist\kanagawa-mint-csupo-windows.zip"
Write-Host '  windows     -> kanagawa-mint-csupo-windows.zip'

# VS Code (.vsix): needs Node; skipped gracefully if unavailable
$npx = Get-Command npx -ErrorAction SilentlyContinue
if ($npx) {
    Push-Location "$root\ports\vscode"
    try {
        npx --yes @vscode/vsce package --allow-missing-repository -o "$dist\kanagawa-mint-csupo-1.3.0.vsix"
        Write-Host '  vscode      -> kanagawa-mint-csupo-1.3.0.vsix'
    } finally { Pop-Location }
} else {
    Write-Host '  vscode      -> SKIPPED (Node/npx not found; install Node then rerun)' -ForegroundColor Yellow
}

Write-Host "`nDone. Artifacts in dist\" -ForegroundColor Green
Get-ChildItem $dist | Select-Object Name, Length
