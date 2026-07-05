# Kanagawa Mint-Csupo Theme Specification Sheet
**Author:** Dark Lunch Studios  
**Version:** 1.3.0  
**Design Paradigm:** Traditional Japanese Earth Tones meets High-Energy Cyberpunk Mint

---

## 1. Design Philosophy & Vision

**Kanagawa Mint-Csupo** is a sophisticated fusion theme that bridges the organic, historical aesthetics of classical Japan with an electric, futuristic cyberpunk edge. 

Built on top of the iconic **Kanagawa** framework, it inherits the deep, non-fatiguing neutral background of traditional *Sumi Ink* (`#1f1f28`) and the comfortable, warm parchment text color (`#c8c093`). However, instead of adhering strictly to the muted, natural accents of the original palette, **Mint-Csupo** introduces a deliberate, high-contrast shock of **Electric Mint / Neon Cyan** (`#54e3b2`). 

This primary accent is strategically deployed across the user interface and syntax highlighting to draw the eye immediately to critical operational context: active line numbers, focused borders, active tabs, and code functions. The result is a highly legible, deeply atmospheric environment tailored for long-haul development sessions where focus and aesthetic precision are paramount.

---

## 2. Core Color Palette

### 2.1 Base & UI Elements
These colors establish the structural foundation of the interface, prioritizing depth, softness, and low eye strain.

| Token Name | Hex Code | Visual Swatch | Purpose / Application |
| :--- | :--- | :--- | :--- |
| `background` | `#1f1f28` | ⬛ | Main editor window, workspace background, gutter background. |
| `chrome.background` | `#181820` | ⬛ | Title bar, tab bar, status bar, and elevated surfaces (popovers, menus). |
| `panel.background` | `#1a1a22` | ⬛ | Sidebars, panels, inactive tabs, editor subheaders. |
| `ink.deepest` | `#16161d` | ⬛ | Deepest layer: reserved for terminal ANSI black. |
| `text` | `#c8c093` | 🟨 | Default active foreground text, standard operators, and punctuation. |
| `text.muted` | `#727169` | ⬜ | Code comments, secondary UI text, disabled actions. |
| `border` | `#2a2a37` | ⬛ | Subtle structural separation lines between workspace panels. |
| `element.hover` | `#223249` | 🟦 | Subtle deep blue-grey tint for element hover states. |
| `element.active` | `#2d4f67` | 🟦 | Selection highlight background and active interactive states. |

### 2.2 The Signature Accents
The defining signature colors that give the theme its modern, high-voltage look.

| Token Name | Hex Code | Visual Swatch | Purpose / Application |
| :--- | :--- | :--- | :--- |
| `accent / Mint` | `#54e3b2` | 🟩 | **Primary Accent:** Focused borders, active tabs, active line numbers, and functions. |
| `accent.focused`| `#54e3b2` | 🟩 | High-visibility ring indicating system focus. |
| `cursor` | `#54e3b2` | 🟩 | Editor and terminal cursor color. |

---

## 3. Syntax Highlighting Specification

The syntax rules use a highly readable hierarchical structure, mapping specific color signals to semantic code structures.

```
       [#b06ecf] KEYWORD (Control Flow)
          │
          ├── [#54e3b2] FUNCTION (Action / Execution)
          │      │
          │      ├── [#e6c384] VARIABLE (Identifiers / Context)
          │      │
          │      └── [#ff9e3b] PROPERTY / CONSTANT (Data Structure Keys)
          │
          └── [#7e9cd8] TYPE (Data Definitions / Classes)
```

| Token Type | Hex Code | Visual Target | Application Example |
| :--- | :--- | :--- | :--- |
| `function` | `#54e3b2` | Mint | `Calculated Fields`, `methods()`, `invocations()` |
| `keyword` | `#b06ecf` | Saturated Violet | `return`, `if`, `const`, `import`, `export`, `class` |
| `type` | `#7e9cd8` | Soft Blue | `String`, `number`, `interface`, `custom_t` |
| `variable` | `#e6c384` | Warm Yellow | local variables, parameters, instances |
| `property` | `#ff9e3b` | Terracotta Orange | `object.property`, JSON keys, struct fields |
| `constant` | `#ff9e3b` | Terracotta Orange | `MAX_BUFFER`, `true`, `false`, global configurations |
| `string` | `#98bb6c` | Olive Green | `"literal strings"`, `'template literals'` |
| `number` | `#e46876` | Soft Red | `42`, `0xff`, floating point decimals |
| `comment` | `#727169` | Muted Grey-Green | `// Technical documentation and inline annotations` |
| `operator` | `#c8c093` | Parchment | `=`, `+`, `===`, `=>`, `&&`, `?` |
| `punctuation`| `#c8c093` | Parchment | `;`, `,`, `(`, `)`, `{`, `}` |

---

## 4. Terminal ANSI Color Mapping

Designed to map natively to command line tools (`ls`, `git`, customized prompts), keeping the theme consistent across CLI tools.

| ANSI Color Type | Normal (Standard) | Bright (Vibrant variant) |
| :--- | :--- | :--- |
| **Black** | `#16161d` (Panel Depth) | `#54546d` (Slate Grey) |
| **Red** | `#c34043` (Crimson) | `#e46876` (Coral Pink) |
| **Green** | `#76946a` (Forest Green) | `#98bb6c` (Light Olive Green) |
| **Yellow** | `#c0a36e` (Muted Gold) | `#e6c384` (Warm Amber) |
| **Blue** | `#7e9cd8` (Soft Blue) | `#7fb4ca` (Light Sky Blue) |
| **Magenta** | `#957fb8` (Soft Violet) | `#938aa9` (Light Amethyst) |
| **Cyan** | `#54e3b2` (Electric Mint) | `#7aa89f` (Patina Cyan) |
| **White** | `#dcd7ba` (Old Parchment) | `#ffffff` (Pure White) |

---

## 5. UI Application Reference Matrix

To maintain theme cohesion when porting to other platforms (e.g., VS Code, Neovim, Alacritty), follow this structural mapping checklist:

* **Editor Layer:**
    * Set your primary editor canvas to `#1f1f28`.
    * Set active selection/highlight backgrounds to `#2d4f67` with transparency (e.g., `45-50%` alpha block).
* **Sidebar & Chrome Layer:**
    * Follow the four-layer Sumi Ink stack: `#16161d` (deepest, ANSI black) → `#181820` (title/tab/status bars, elevated surfaces) → `#1a1a22` (sidebars, panels, inactive tabs) → `#1f1f28` (editor canvas). The stepped shades create visual framing without hard borders.
* **Interactivity Alerts:**
    * Any active, focused interface outline, tab highlight indicator, or primary cursor target should explicitly use `#54e3b2` to snap attention instantly.
