# Kanagawa Mint-Csupo — Windows 11 apply script (spec v1.3.0)
# Applies: wallpaper, dark mode, mint accent (taskbar/title bars), mint mouse
# pointer, mint text-cursor indicator, Windows Terminal scheme + window theme.
# All changes are HKCU (current user only). No admin rights required.
# Documentation: kmc-windows-setup.md · Undo notes at the bottom of that file.

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path

# --- Palette (see byte-order cheat sheet in kmc-windows-setup.md) ---
$MintABGR  = 0xFFB2E354   # AccentColor / AccentColorMenu / StartColorMenu
$MintBGR   = 0x00B2E354   # CursorColor / IndicatorColor
$MintARGB  = 0xC454E3B2   # ColorizationColor (C4 = intensity)
$InkABGR   = 0xFF372A2A   # #2a2a37 -> inactive window border

function Set-Reg($path, $name, $value, $type = 'DWord') {
    if (-not (Test-Path $path)) { New-Item -Path $path -Force | Out-Null }
    New-ItemProperty -Path $path -Name $name -Value $value -PropertyType $type -Force | Out-Null
}

Write-Host 'Kanagawa Mint-Csupo — applying Windows tweaks...' -ForegroundColor Green

# --- 1. Dark mode ---
$pers = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize'
Set-Reg $pers 'AppsUseLightTheme'    0
Set-Reg $pers 'SystemUsesLightTheme' 0
Write-Host '  [1/6] Dark mode (system + apps)'

# --- 2. Accent color: Electric Mint ---
$accent = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent'
Set-Reg $accent 'AccentColorMenu' $MintABGR
Set-Reg $accent 'StartColorMenu'  $MintABGR
Write-Host '  [2/6] Accent color #54E3B2'

# --- 3. Accent on Start/taskbar + title bars, ink inactive borders ---
Set-Reg $pers 'ColorPrevalence' 1
$dwm = 'HKCU:\Software\Microsoft\Windows\DWM'
Set-Reg $dwm 'ColorPrevalence'     1
Set-Reg $dwm 'AccentColor'         $MintABGR
Set-Reg $dwm 'AccentColorInactive' $InkABGR
Set-Reg $dwm 'ColorizationColor'   $MintARGB
Write-Host '  [3/6] Accent on taskbar + title bars, #2a2a37 inactive borders'

# --- 4. Mouse pointer: mint ---
$acc = 'HKCU:\Software\Microsoft\Accessibility'
Set-Reg $acc 'CursorType'  6
Set-Reg $acc 'CursorColor' $MintBGR
Write-Host '  [4/6] Mint mouse pointer (takes effect after sign-out)'

# --- 5. Text cursor indicator: mint ---
Set-Reg "$acc\CursorIndicator" 'IndicatorColor' $MintBGR
Write-Host '  [5/6] Mint text cursor indicator (enable toggle in Settings > Accessibility > Text cursor if off)'

# --- 6. Windows Terminal: scheme + ink-stack window theme ---
$wtDirs = @(
    "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState",
    "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState",
    "$env:LOCALAPPDATA\Microsoft\Windows Terminal"
) | Where-Object { Test-Path (Join-Path $_ 'settings.json') }

if ($wtDirs.Count -eq 0) {
    Write-Host '  [6/6] Windows Terminal settings.json not found - skipped' -ForegroundColor Yellow
} else {
    foreach ($dir in $wtDirs) {
        $file = Join-Path $dir 'settings.json'
        Copy-Item $file "$file.kmc-backup" -Force
        $json = Get-Content $file -Raw | ConvertFrom-Json

        $scheme = Get-Content (Join-Path $root '..\windows-terminal\kanagawa-mint-csupo.json') -Raw | ConvertFrom-Json
        if ($null -eq $json.schemes) { $json | Add-Member -NotePropertyName schemes -NotePropertyValue @() }
        $json.schemes = @($json.schemes | Where-Object { $_.name -ne $scheme.name }) + $scheme

        $wtTheme = [PSCustomObject]@{
            name   = 'Kanagawa Mint-Csupo'
            tab    = [PSCustomObject]@{ background = '#1A1A22FF'; unfocusedBackground = '#181820FF' }
            tabRow = [PSCustomObject]@{ background = '#181820FF'; unfocusedBackground = '#181820FF' }
            window = [PSCustomObject]@{ applicationTheme = 'dark' }
        }
        if ($null -eq $json.themes) { $json | Add-Member -NotePropertyName themes -NotePropertyValue @() }
        $json.themes = @($json.themes | Where-Object { $_.name -ne $wtTheme.name }) + $wtTheme
        if ($null -eq ($json.PSObject.Properties['theme'])) {
            $json | Add-Member -NotePropertyName theme -NotePropertyValue 'Kanagawa Mint-Csupo'
        } else { $json.theme = 'Kanagawa Mint-Csupo' }

        if ($null -eq $json.profiles.defaults) {
            $json.profiles | Add-Member -NotePropertyName defaults -NotePropertyValue ([PSCustomObject]@{})
        }
        if ($null -eq ($json.profiles.defaults.PSObject.Properties['colorScheme'])) {
            $json.profiles.defaults | Add-Member -NotePropertyName colorScheme -NotePropertyValue $scheme.name
        } else { $json.profiles.defaults.colorScheme = $scheme.name }

        $json | ConvertTo-Json -Depth 32 | Set-Content $file -Encoding utf8
        Write-Host "  [6/6] Windows Terminal themed ($file)"
    }
}

# --- Wallpaper + cursor refresh (instant, no sign-out) ---
$wallpaper = Join-Path $root '..\..\wallpapers\wave.png'
Add-Type @'
using System.Runtime.InteropServices;
public class KmcNative {
    [DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
    public static extern bool SystemParametersInfo(uint uiAction, uint uiParam, string pvParam, uint fWinIni);
    [DllImport("user32.dll", SetLastError = true)]
    public static extern bool SystemParametersInfo(uint uiAction, uint uiParam, System.IntPtr pvParam, uint fWinIni);
}
'@
[KmcNative]::SystemParametersInfo(20, 0, $wallpaper, 3) | Out-Null       # SPI_SETDESKWALLPAPER
[KmcNative]::SystemParametersInfo(0x57, 0, [System.IntPtr]::Zero, 3) | Out-Null  # SPI_SETCURSORS
Write-Host '  Wallpaper set + cursors refreshed'

Write-Host ''
Write-Host 'Done. Sign out and back in (or restart explorer.exe) to see accent,' -ForegroundColor Green
Write-Host 'pointer, and title-bar changes everywhere.' -ForegroundColor Green
