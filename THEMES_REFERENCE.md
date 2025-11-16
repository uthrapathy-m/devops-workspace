# DevOps Workspace Themes - Reference Card

## Quick Command Reference

### Theme Switching

```bash
theme                  # Interactive theme selector
theme-dracula         # Switch to Dracula theme (🟣 Purple)
theme-nord            # Switch to Nord theme (🔵 Blue/Green)
theme-gruvbox         # Switch to Gruvbox theme (🟡 Warm)
theme-solarized       # Switch to Solarized theme (⚪ Balanced)
theme-tokyo           # Switch to Tokyo Night theme (🌙 Neon)
theme-catppuccin      # Switch to Catppuccin theme (💜 Pastel)
```

### Font Management

```bash
font                  # Interactive font selector
font "FiraCode"      # Switch to FiraCode Nerd Font
font "JetBrains Mono" # Switch to JetBrains Mono
font "Hack"          # Switch to Hack Nerd Font
font "Inconsolata"   # Switch to Inconsolata
```

### Information Commands

```bash
theme-list           # Show current theme & font
theme-preview        # Preview all 6 themes
font-list           # List available fonts
cheat               # View alias cheatsheet
```

## Theme Color Reference

### Dracula 🟣
| Component | Color | Hex |
|-----------|-------|-----|
| Background | Dark Grey | #282A36 |
| Text | White | #F8F8F2 |
| Primary | Purple | #BD93F9 |
| Success | Green | #50FA7B |
| Error | Red | #FF5555 |

### Nord 🔵
| Component | Color | Hex |
|-----------|-------|-----|
| Background | Dark Blue-Grey | #2E3440 |
| Text | Light Grey | #ECEFF4 |
| Primary | Blue | #81A1C1 |
| Success | Green | #A3BE8C |
| Error | Red | #BF616A |

### Gruvbox 🟡
| Component | Color | Hex |
|-----------|-------|-----|
| Background | Very Dark | #282828 |
| Text | Cream | #EBDBB2 |
| Primary | Magenta | #B16286 |
| Success | Green | #98971A |
| Error | Red | #CC241D |

### Solarized 🔆
| Component | Color | Hex |
|-----------|-------|-----|
| Background | Dark Blue | #002B36 |
| Text | Light Grey | #839496 |
| Primary | Blue | #268BD2 |
| Success | Green | #859900 |
| Error | Red | #DC322F |

### Tokyo Night 🌙
| Component | Color | Hex |
|-----------|-------|-----|
| Background | Very Dark | #1A1B26 |
| Text | Light Blue | #C0CAF5 |
| Primary | Blue | #7AA2F7 |
| Success | Green | #9ECE6A |
| Error | Red | #F7768E |

### Catppuccin 💜
| Component | Color | Hex |
|-----------|-------|-----|
| Background | Dark Blue | #1E1E2E |
| Text | Light Blue | #CDD6F4 |
| Primary | Blue | #89B4FA |
| Success | Green | #A6E3A1 |
| Error | Red | #F38BA8 |

## Font Installation Details

### FiraCode
- **Type:** Monospace with ligatures
- **Use Case:** Code with operators
- **Files:** Regular, Bold, Italic variants
- **Size Range:** 9-16pt recommended

### JetBrains Mono
- **Type:** Clean professional monospace
- **Use Case:** All-purpose development
- **Files:** Multiple weights available
- **Size Range:** 10-14pt recommended

### Hack
- **Type:** Excellent readability monospace
- **Use Case:** Terminal work
- **Files:** Regular and Bold variants
- **Size Range:** 11-15pt recommended

### Inconsolata
- **Type:** Simple elegant monospace
- **Use Case:** Minimal terminal aesthetic
- **Files:** Regular variant
- **Size Range:** 12-16pt recommended

## File Locations

```
~/.devops-workspace/
├── theme.conf                 # Current theme config
├── .tmux-dracula.conf        # Tmux Dracula theme
├── .tmux-nord.conf           # Tmux Nord theme
├── .tmux-gruvbox.conf        # Tmux Gruvbox theme
├── .tmux-solarized-dark.conf # Tmux Solarized theme
├── .tmux-tokyo-night.conf    # Tmux Tokyo Night theme
├── .tmux-catppuccin.conf     # Tmux Catppuccin theme
└── .bash-theme-prompt        # Shell prompt colors

~/.local/share/fonts/
├── FiraCodeNerdFont-Regular.ttf
├── FiraCodeNerdFont-Bold.ttf
├── JetBrainsMonoNerdFont-Regular.ttf
├── JetBrainsMonoNerdFont-Bold.ttf
├── HackNerdFont-Regular.ttf
├── HackNerdFont-Bold.ttf
├── InconsolataNerdFont-Regular.ttf
└── ... (other variants)

~/.config/nvim/
└── (Neovim will use theme colors automatically)
```

## Terminal Emulator Settings

### GNOME Terminal
- Path: Preferences → Profile → Colors
- Action: Load color scheme from theme
- Font: Text tab → Select Nerd Font

### Alacritty
- File: `~/.config/alacritty/alacritty.yml`
- Set: `font.family` and color palette
- Size: `font.size` (11-12 recommended)

### VS Code
- File: `.vscode/settings.json`
- Settings:
  ```json
  "terminal.integrated.fontFamily": "FiraCode Nerd Font"
  "terminal.integrated.fontSize": 12
  "workbench.colorTheme": "Dracula"
  ```

### iTerm2 (macOS)
- Path: Preferences → Profiles → Colors
- Action: Import .plist or JSON color profile
- Font: Text tab → Select Nerd Font

### Windows Terminal
- File: `settings.json`
- Path: `%APPDATA%\Local\Packages\Microsoft.WindowsTerminal_*\LocalState\`
- Add profile with font and colorScheme

## Troubleshooting Quick Fixes

| Issue | Solution |
|-------|----------|
| Theme not applying | `tmux kill-server` then `tmux` |
| Fonts not showing | Check terminal font setting |
| Colors wrong in SSH | Add `export TERM=screen-256color` to `.bashrc` |
| Icons missing | Install Nerd Fonts via `font-install` |
| Prompt colors off | Run `source ~/.bashrc` |
| Tmux colors pale | Check `$TERM` value: `echo $TERM` |

## Configuration Examples

### Tmux Theme Application
```tmux
# ~/.tmux.conf includes:
if-shell "test -f ~/.devops-workspace/theme.conf" \
  "source ~/.devops-workspace/theme.conf"

# This loads your current theme colors
```

### Bash Prompt Colors
```bash
# ~/.devops-workspace/.bash-theme-prompt includes:
export PROMPT_PRIMARY='\033[38;5;189m'  # Theme primary color
export PROMPT_ERROR='\033[38;5;203m'    # Theme error color
PS1="${PROMPT_PRIMARY}\u@\h${PROMPT_RESET} ${PROMPT_SECONDARY}\w${PROMPT_RESET}> "
```

## Advanced Usage

### Create Custom Theme
```bash
# Copy template
cp config/themes/dracula.sh config/themes/custom.sh

# Edit colors
nano config/themes/custom.sh

# Switch to it
theme-switcher switch custom
```

### Auto-Switch Based on Time
```bash
# Add to ~/.bashrc
HOUR=$(date +%H)
if [[ $HOUR -gt 18 || $HOUR -lt 6 ]]; then
    theme-nord  # Night theme
else
    theme-dracula  # Day theme
fi
```

### List All Installed Fonts
```bash
fc-list : family | grep -i "nerd\|fire\|jetbrain\|hack\|inconsolata"
```

### Force Font Cache Refresh
```bash
fc-cache -fv ~/.local/share/fonts/
fc-cache -r  # Rebuild cache
```

## Best Practices

1. **Always use Nerd Fonts** - Standard fonts won't display icons
2. **Match terminal + tmux themes** - Switch both for consistency
3. **Test in tmux** - Reload with `Ctrl+a r` after switching
4. **SSH connections** - Set `TERM=screen-256color` for consistency
5. **Backup custom themes** - Keep them in version control
6. **Font sizing** - Adjust to your preference (11-14pt typical)

## Performance Tips

- Themes load in < 100ms - no startup delay
- Fonts are installed once - no recurring downloads
- No impact on alias or tool execution speed
- Safe to switch themes frequently

## Key Bindings (for Tmux)

| Binding | Action |
|---------|--------|
| `Ctrl+a r` | Reload tmux config (apply theme) |
| `Ctrl+a ,` | Rename window |
| `Ctrl+a -` | Split pane vertically |
| `Ctrl+a \|` | Split pane horizontally |

## Related Commands

```bash
# Terminal utilities
eza           # Better ls (with theme colors)
bat           # Better cat (with theme colors)
fzf           # Fuzzy finder (uses theme colors)
tmux          # Terminal multiplexer (themed)
nvim          # Neovim (uses theme colors)

# Theme commands
theme         # Switch theme (interactive)
theme-list    # Show current theme
theme-preview # Preview all themes
font          # Switch font (interactive)
font-list     # List all fonts
```

## Resources

- **Documentation:** `docs/THEMES_AND_FONTS.md`
- **Quick Start:** `THEMES_QUICK_START.md`
- **Implementation:** `IMPLEMENTATION_SUMMARY.md`
- **Official Sites:**
  - Nerd Fonts: https://www.nerdfonts.com/
  - Dracula: https://draculatheme.com/
  - Nord: https://www.nordtheme.com/
  - Gruvbox: https://github.com/morhetz/gruvbox

---

**Happy Theming!** 🎨

Pick a theme that matches your mood and coding style.
