# Kanagawa Mint-Csupo â€” Windows 11 Setup Guide
**Author:** Dark Lunch Studios Â· **Spec version:** 1.3.0

Theming Windows 11 to the Mint-Csupo spec using only built-in features.
Every tweak below lists the manual route (Settings UI) and, where one exists,
the registry/script equivalent used by `apply-kmc-windows.ps1`.

**Quick start:** right-click `apply-kmc-windows.ps1` â†’ *Run with PowerShell*,
then sign out and back in (or restart Explorer) for everything to take effect.

---

## 1. Wallpaper â€” `wallpapers/wave.png`
| | |
| :--- | :--- |
| Manual | Settings â†’ Personalization â†’ Background â†’ Browse photos |
| Scripted | `SystemParametersInfo(SPI_SETDESKWALLPAPER)` â€” instant, no sign-out |
| Spec tokens | Sky `#16161dâ†’#1f1f28`, waves `#223249`/`#2d4f67`, crests `#54e3b2`, sun `#ff9e3b`/`#e6c384` |

## 2. Dark mode (system + apps)
| | |
| :--- | :--- |
| Manual | Settings â†’ Personalization â†’ Colors â†’ Choose your mode â†’ **Dark** |
| Registry | `HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize` â†’ `AppsUseLightTheme=0`, `SystemUsesLightTheme=0` (DWORD) |

## 3. Accent color â€” Electric Mint `#54E3B2`
| | |
| :--- | :--- |
| Manual | Settings â†’ Personalization â†’ Colors â†’ Accent color â†’ **Custom** â†’ `#54E3B2` (RGB 84, 227, 178) |
| Registry | `HKCU\...\Explorer\Accent` â†’ `AccentColorMenu` and `StartColorMenu` = `0xFFB2E354` (DWORD, **ABGR** byte order) |
| Note | Windows renders dark text on this accent because it is high-luminance. That is expected and matches the theme. |

## 4. Accent on Start, taskbar, and title bars
| | |
| :--- | :--- |
| Manual | Settings â†’ Personalization â†’ Colors â†’ toggle **Show accent color on Start and taskbar** and **...on title bars and window borders** |
| Registry | Start/taskbar: `HKCU\...\Themes\Personalize` â†’ `ColorPrevalence=1`. Title bars: `HKCU\Software\Microsoft\Windows\DWM` â†’ `ColorPrevalence=1`, `AccentColor=0xFFB2E354` (ABGR), `ColorizationColor=0xC454E3B2` (ARGB) |
| Bonus (registry-only) | `HKCU\...\DWM` â†’ `AccentColorInactive=0xFF372A2A` gives unfocused windows the spec border color `#2a2a37` â€” not exposed in Settings at all. |

## 5. Mouse pointer â€” mint
| | |
| :--- | :--- |
| Manual | Settings â†’ Accessibility â†’ Mouse pointer and touch â†’ **Custom** â†’ `#54E3B2` |
| Registry | `HKCU\Software\Microsoft\Accessibility` â†’ `CursorType=6`, `CursorColor=0x00B2E354` (DWORD, BGR). Requires `SystemParametersInfo(SPI_SETCURSORS)` or sign-out to refresh. |

## 6. Text cursor indicator â€” mint
| | |
| :--- | :--- |
| Manual | Settings â†’ Accessibility â†’ Text cursor â†’ enable **Text cursor indicator** â†’ pick the teal swatch or Custom `#54E3B2` |
| Registry | `HKCU\Software\Microsoft\Accessibility\CursorIndicator` â†’ `IndicatorColor=0x00B2E354` (DWORD, BGR). May need sign-out. |

## 7. Windows Terminal â€” scheme + chrome
| | |
| :--- | :--- |
| Manual | Paste `ports/windows-terminal/kanagawa-mint-csupo.json` into the `"schemes"` array of Terminal's `settings.json`, add the ink-stack window theme (Â§below), set the profile `colorScheme` |
| Scripted | The apply script patches `settings.json` in place (backs it up first) |

Window theme for the four-layer ink stack:
```json
{
  "name": "Kanagawa Mint-Csupo",
  "tab": { "background": "#1A1A22FF", "unfocusedBackground": "#181820FF" },
  "tabRow": { "background": "#181820FF", "unfocusedBackground": "#181820FF" },
  "window": { "applicationTheme": "dark" }
}
```

## 8. The `.theme` file (alternative bundle)
`kmc-windows.theme` bundles wallpaper + dark mode + accent into one
double-clickable file â€” Windows-native, good for sharing. The apply script
covers everything the `.theme` file does plus the accessibility and Terminal
tweaks, so use one or the other.

---

## Color reference (byte-order cheat sheet)
Mint `#54E3B2` appears in three encodings across Windows registries:

| Encoding | Value | Used by |
| :--- | :--- | :--- |
| RGB hex | `54 E3 B2` | Settings UI pickers |
| ABGR DWORD | `0xFFB2E354` | `AccentColor`, `AccentColorMenu`, `StartColorMenu` |
| BGR DWORD | `0x00B2E354` | `CursorColor`, `IndicatorColor` |
| ARGB DWORD | `0xC454E3B2` | `ColorizationColor` (C4 = intensity) |

## Undo
- Re-pick any color/mode in Settings â†’ Personalization (registry keys are the same ones Settings writes).
- Terminal: the script saves `settings.json.kmc-backup` next to the original.
- Or apply any other `.theme` from Settings â†’ Personalization â†’ Themes.

