# Submitting Kanagawa Mint-Csupo to marketplaces

Per-marketplace requirements and steps for every port in this repo.
Store art lives in `assets/store/` (icon, screenshot, promo tile).

---

## VS Code Marketplace (`ports/vscode/`)
1. One-time: create a publisher at https://marketplace.visualstudio.com/manage
   (needs a free Azure DevOps account + Personal Access Token with
   "Marketplace: Manage" scope). Publisher id must match `"publisher"` in
   `package.json` (currently `darklunchstudios` — change if taken).
2. Package: `npm install -g @vscode/vsce`, then in `ports/vscode/`: `vsce package`
   → produces `kanagawa-mint-csupo-1.3.0.vsix`.
3. Publish: `vsce publish` (or upload the .vsix in the web dashboard).
- Cost: free. Review: automated, minutes.
- Local test first: `code --install-extension kanagawa-mint-csupo-1.3.0.vsix`

## Open VSX — for VSCodium (`ports/vscode/`, same package)
VSCodium cannot use the VS Code Marketplace; publish the identical .vsix here.
1. Account: sign in at https://open-vsx.org with GitHub; create an access token.
2. Sign the publisher agreement (once), create the `darklunchstudios` namespace:
   `npx ovsx create-namespace darklunchstudios -p <token>`
3. `npx ovsx publish kanagawa-mint-csupo-1.3.0.vsix -p <token>`
- Cost: free. Review: automated.

## Zed Extensions (`ports/zed/`)
Zed's registry is a Git monorepo — submission is a pull request.
1. Fork https://github.com/zed-industries/extensions
2. Add this repo as a git submodule under `extensions/kanagawa-mint-csupo`
   (the extension must live in its own public repo — this one).
3. Add an entry to `extensions.toml` (id, version, path) and open the PR.
- Cost: free. Review: human, usually a few days.
- Until then, users install via Extensions → Install Dev Extension.

## Firefox / AMO (`ports/firefox/`) — already in progress
Zip must contain `manifest.json` at the root:
`Compress-Archive ports/firefox/manifest.json kmc-firefox.zip`
Upload at https://addons.mozilla.org/developers/. Free, automated review.
Category: Abstract. License: CC BY-SA.

## Chrome Web Store — covers Chrome, Brave, Edge users (`ports/chromium/`)
1. One-time $5 registration: https://chrome.google.com/webstore/devconsole
2. Zip: `Compress-Archive ports/chromium/manifest.json kmc-chromium.zip`
3. Upload; required listing assets (in `assets/store/`):
   icon-128.png, screenshot-1280x800.png, promo-440x280.png.
- Review: automated for themes, typically < 1 day.

## Vivaldi Themes (`ports/vivaldi/`)
1. In Vivaldi: Settings → Themes → create/import — the JSON here matches
   Vivaldi's exported `settings.json` format. To make an installable
   `.zip` theme: zip the JSON renamed to `settings.json`.
2. Community gallery: https://themes.vivaldi.net — sign in with a Vivaldi
   account, upload the zip, add title/description/tags.
- Cost: free. Review: light human moderation.

## JetBrains (`ports/jetbrains/`)
Two routes:
- **Simple (no marketplace):** users import the `.icls` via
  Settings → Editor → Color Scheme → gear icon → Import Scheme. Ship as-is.
- **Marketplace plugin:** JetBrains requires themes to be packaged as a
  plugin (theme .json + plugin.xml built with the DevKit or the
  `platformPlugins` Gradle setup), then uploaded to
  https://plugins.jetbrains.com. Free account, human review (~2 business
  days). The `.icls` covers editor colors; a full UI theme .json would be
  a follow-up if the marketplace route is chosen.

## Sublime Text (`ports/sublime/`)
- Direct use: Preferences → Browse Packages → drop the `.sublime-color-scheme`
  into `User/`, then select it in Preferences → Select Color Scheme.
- Distribution: Package Control — make a dedicated GitHub repo (or use a
  release tag of this one), then PR an entry to
  https://github.com/wbond/package_control_channel (human review).

## Obsidian (`ports/obsidian/`)
1. Theme must live in its own GitHub repo containing `manifest.json` +
   `theme.css` at the root, with a GitHub release tagged matching the
   manifest version (1.3.0).
2. PR an entry to `community-css-themes.json` in
   https://github.com/obsidianmd/obsidian-releases (human review, ~1-2 weeks).
3. Listing wants a `screenshot.png` (16:9) in the theme repo.
- Local test: copy the folder to `<vault>/.obsidian/themes/Kanagawa Mint-Csupo/`
  and enable in Settings → Appearance.

## Neovim (`ports/neovim/`)
No marketplace — distribution is the GitHub repo itself. Users install with
any plugin manager pointing at this repo, or copy `colors/*.lua` into their
config. Getting listed: submit to awesome-neovim (PR) and post on
r/neovim — that's the discovery channel.

## kitty / Alacritty / WezTerm (`ports/kitty|alacritty|wezterm/`)
Config files; no store. Optional upstreaming for discovery:
- kitty: PR to https://github.com/kovidgoyal/kitty-themes
- Alacritty: PR to https://github.com/alacritty/alacritty-theme
- WezTerm: PR to https://github.com/wez/wezterm (colors/ dir; also picks up
  iTerm2-format schemes from the iTerm2-Color-Schemes repo)

---

### Suggested order
1. VS Code Marketplace + Open VSX (same artifact, biggest audience)
2. AMO (already underway) and CWS (when the $5 decision lands)
3. Zed extensions PR (needs this repo public on GitHub first)
4. Obsidian + Package Control + terminal-theme upstream PRs (all need the
   public repo too — do these after the GitHub push)
