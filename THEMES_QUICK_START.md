# DevOps Workspace Themes - Quick Start Guide

## What's New?

Your DevOps workspace now includes **6 beautiful terminal themes** with **Nerd Font support** for a stunning terminal experience with icons and special characters.

## Installation

When you run the installer, you'll be asked:
1. **Choose a theme** from: Dracula, Nord, Gruvbox, Solarized Dark, Tokyo Night, or Catppuccin
2. **Install Nerd Fonts** (FiraCode, JetBrains Mono, Hack, Inconsolata)

```bash
./install.sh
```

## Quick Commands

### Switch Themes

```bash
# Interactive menu
theme

# Or use specific theme
theme-dracula
theme-nord
theme-gruvbox
theme-solarized
theme-tokyo
theme-catppuccin
```

### Switch Fonts

```bash
# Interactive font selector
font

# Or use specific font
font "FiraCode"
```

### View Theme Info

```bash
# Show current theme and font
theme-list

# Preview all theme colors
theme-preview

# List available fonts
font-list
```

## Available Themes

| Theme | Best For | Colors |
|-------|----------|--------|
| **Dracula** | High contrast, purple lover | Purple, pink, cyan |
| **Nord** | Eye strain reduction | Cool blues, greens |
| **Gruvbox** | Warm, cozy coding | Warm oranges, browns |
| **Solarized** | Professional work | Balanced, optimized |
| **Tokyo Night** | Modern, vibrant | Neon blues, pinks |
| **Catppuccin** | Soft, pastel lover | Soft pastels |

## Available Fonts

- **FiraCode** - Great ligature support
- **JetBrains Mono** - Professional and modern
- **Hack** - Excellent readability
- **Inconsolata** - Clean and minimal

## How It Works

### Tmux
- Themes automatically apply to your tmux status bar
- Colors update when you switch themes
- Reload with `Ctrl+a r` inside tmux

### Shell Prompt
- Shell prompt colors update based on current theme
- Shows success/error states with theme colors
- Git branch info displayed in theme color

### Terminal
- Install fonts to `~/.local/share/fonts/`
- Configure your terminal emulator to use a Nerd Font
- Supports all modern terminal emulators

## Files Created

```
config/themes/
├── theme-manager.sh          # Theme management functions
├── dracula.sh                # Dracula theme
├── nord.sh                   # Nord theme
├── gruvbox.sh                # Gruvbox theme
├── solarized-dark.sh         # Solarized Dark theme
├── tokyo-night.sh            # Tokyo Night theme
└── catppuccin.sh             # Catppuccin theme

scripts/core/
├── nerd-fonts.sh             # Font installation
└── theme-switcher.sh         # Theme switching utility

~/.devops-workspace/
└── theme.conf                # Your current theme config
```

## Example Usage

```bash
# Install with specific theme
./install.sh --category themes

# Switch to Dracula theme
theme-dracula

# Preview all themes
theme-preview

# List available fonts
font-list

# Switch to JetBrains Mono font
font "JetBrains Mono"
```

## Customization

Create your own theme by copying an existing one:

```bash
cp config/themes/dracula.sh config/themes/my-theme.sh
# Edit my-theme.sh with your colors
theme-switcher switch my-theme
```

## Terminal Configuration

### GNOME Terminal
Preferences → Profile → Colors (import theme colors)

### Alacritty
Edit `~/.config/alacritty/alacritty.yml` with font and colors

### VS Code Terminal
Set `terminal.integrated.fontFamily` to a Nerd Font

### iTerm2
Preferences → Profiles → Colors (load theme preset)

### Windows Terminal
Edit settings.json with font and colorScheme

## Troubleshooting

**Nerd Font icons not showing?**
- Verify font is installed: `fc-list | grep -i nerd`
- Configure terminal to use the Nerd Font
- Restart terminal application

**Theme not applying to tmux?**
- Kill tmux: `tmux kill-server`
- Check theme.conf exists: `cat ~/.devops-workspace/theme.conf`
- Reload tmux: `Ctrl+a r`

**Colors look wrong in SSH?**
- Add to ~/.bashrc: `export TERM=screen-256color`
- Verify remote supports 256 colors: `echo $TERM`

## More Information

See [docs/THEMES_AND_FONTS.md](docs/THEMES_AND_FONTS.md) for:
- Detailed theme descriptions
- Creating custom themes
- Terminal emulator setup guides
- Advanced customization options
- Full troubleshooting guide

## Enjoy Your Colorful Terminal! 🎨

Switch themes, pick fonts, and make your terminal your own!

```
theme-dracula  # Beautiful purple theme
theme-preview  # See all theme colors
```
