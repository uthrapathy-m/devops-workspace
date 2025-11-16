# DevOps Workspace: Themes and Nerd Fonts

This guide covers the theme and font system available in your DevOps workspace.

## Overview

Your workspace comes with **6 premium terminal themes** and support for **Nerd Fonts**, which provide beautiful icons and enhanced visual appearance for your terminal and CLI tools.

### Available Themes

1. **Dracula** - Dark purple-based theme with high contrast
   - Great for: Developers who prefer dark themes with strong colors
   - Color scheme: Purple, pink, cyan accents on dark background

2. **Nord** - Cool arctic colors inspired by the north
   - Great for: Reducing eye strain in low-light environments
   - Color scheme: Cool blues and greens on dark background

3. **Gruvbox** - Retro warm colors inspired by old video games
   - Great for: Cozy development sessions with warm tones
   - Color scheme: Warm oranges, yellows, browns on dark background

4. **Solarized Dark** - Precision colors for machines and people
   - Great for: Professional work with optimized color contrast
   - Color scheme: Balanced colors optimized for readability

5. **Tokyo Night** - Modern neon colors inspired by Tokyo at night
   - Great for: Contemporary developers who like vibrant colors
   - Color scheme: Neon blues, pinks, and yellows on dark background

6. **Catppuccin** - Soothing pastel theme with excellent readability
   - Great for: Long coding sessions with soft, inviting colors
   - Color scheme: Soft pastels on dark background

### Available Nerd Fonts

Nerd Fonts include thousands of additional icons in terminal-friendly formats:

1. **FiraCode** - Excellent ligature support for operators
2. **JetBrains Mono** - Professional monospace font
3. **Hack** - Excellent for code readability
4. **Inconsolata** - Clean and minimal font

## Installation

### During Initial Setup

When running the installer, you'll be prompted to:

```bash
./install.sh
```

1. Select a terminal theme from the interactive menu
2. Choose to install Nerd Fonts (yes/no)

### After Installation

#### Switching Themes

Use the theme switcher script to change themes:

```bash
# Interactive theme selection
~/.devops-workspace/scripts/core/theme-switcher.sh switch

# Switch to a specific theme
~/.devops-workspace/scripts/core/theme-switcher.sh switch dracula
~/.devops-workspace/scripts/core/theme-switcher.sh switch nord
~/.devops-workspace/scripts/core/theme-switcher.sh switch gruvbox
```

#### Switching Fonts

To switch fonts:

```bash
# Interactive font selection
~/.devops-workspace/scripts/core/theme-switcher.sh font

# Switch to a specific font
~/.devops-workspace/scripts/core/theme-switcher.sh font "FiraCode"
~/.devops-workspace/scripts/core/theme-switcher.sh font "JetBrains Mono"
```

#### Viewing Current Theme

```bash
# Show current theme and font
~/.devops-workspace/scripts/core/theme-switcher.sh list

# Preview all theme colors
~/.devops-workspace/scripts/core/theme-switcher.sh preview

# List available fonts
~/.devops-workspace/scripts/core/theme-switcher.sh list-fonts
```

## Configuration

### Theme Configuration File

Your current theme is saved in `~/.devops-workspace/theme.conf`:

```bash
CURRENT_THEME="dracula"
CURRENT_FONT="FiraCode"
LAST_UPDATED="2024-01-15 10:30:00"
```

### Tmux Theme Configuration

The theme is applied to tmux through `~/.tmux.conf`. When you switch themes, the colors update automatically.

To reload tmux with the new theme:

```bash
# Inside tmux
Ctrl+a r

# Or kill and restart
tmux kill-server
tmux
```

### Shell Prompt Theme

When you switch themes, your shell prompt colors update via `~/.devops-workspace/.bash-theme-prompt`.

To apply theme changes immediately:

```bash
source ~/.bashrc
```

## Customization

### Creating a Custom Theme

To create your own theme, create a new file in `config/themes/`:

```bash
# Copy an existing theme as a template
cp config/themes/dracula.sh config/themes/my-theme.sh
```

Edit `config/themes/my-theme.sh`:

```bash
#!/usr/bin/env bash

# My Custom Theme

# Color definitions
export COLOR_BACKGROUND="#1e1e1e"
export COLOR_FOREGROUND="#e0e0e0"

# Terminal colors
export PROMPT_PRIMARY='\033[38;5;123m'
export PROMPT_SECONDARY='\033[38;5;145m'
export PROMPT_SUCCESS='\033[38;5;156m'
export PROMPT_ERROR='\033[38;5;203m'
export PROMPT_RESET='\033[0m'

# Tmux theme configuration
cat > "$HOME/.tmux-my-theme.conf" << 'EOF'
set -g status-style bg="#1e1e1e",fg="#e0e0e0"
set -g status-left "#[fg=#123456]Session: #S"
# ... more tmux config
EOF

echo "My custom theme loaded"
```

Then switch to it:

```bash
~/.devops-workspace/scripts/core/theme-switcher.sh switch my-theme
```

### Installing Additional Nerd Fonts

To install more fonts, download them from the [Nerd Fonts](https://www.nerdfonts.com/) repository and place them in:

```bash
~/.local/share/fonts/
```

Then refresh your font cache:

```bash
fc-cache -fv ~/.local/share/fonts/
```

## Terminal Emulator Configuration

To use your theme and fonts, configure your terminal emulator:

### GNOME Terminal

1. Edit → Preferences
2. Select your profile
3. Go to "Colors" tab
4. Create a new profile with your theme colors
5. Go to "Text" tab
6. Set Font to one of the installed Nerd Fonts

### VS Code Terminal

Add to your `settings.json`:

```json
{
  "terminal.external.linuxExec": "x-terminal-emulator",
  "terminal.integrated.fontFamily": "FiraCode Nerd Font",
  "terminal.integrated.fontSize": 12,
  "workbench.colorTheme": "Dracula"
}
```

### Alacritty

Edit `~/.config/alacritty/alacritty.yml`:

```yaml
font:
  normal:
    family: "FiraCode Nerd Font"
    style: Regular
  size: 12

colors:
  primary:
    background: '#282a36'
    foreground: '#f8f8f2'
  # ... define your color palette
```

### iTerm2 (macOS)

1. iTerm2 → Preferences → Profiles → Colors
2. Click "Load Presets" and select or import your theme
3. Go to Text tab
4. Change Font Family to a Nerd Font

### Windows Terminal

Edit your `settings.json`:

```json
{
  "profiles": {
    "defaults": {
      "font": {
        "face": "FiraCode Nerd Font",
        "size": 11
      },
      "colorScheme": "Dracula"
    }
  }
}
```

## Troubleshooting

### Theme Not Applied to Tmux

1. Kill the tmux server: `tmux kill-server`
2. Start a new tmux session: `tmux`
3. Check that `~/.devops-workspace/theme.conf` exists
4. Reload tmux config: `Ctrl+a r`

### Nerd Font Icons Not Displaying

1. Verify fonts are installed: `ls ~/.local/share/fonts/ | grep -i nerd`
2. Refresh font cache: `fc-cache -fv ~/.local/share/fonts/`
3. Configure your terminal to use the Nerd Font
4. Restart your terminal application

### Theme Colors Look Wrong in SSH Session

1. Ensure the remote system supports 256 colors: `echo $TERM`
2. Set `TERM=screen-256color` before connecting
3. Or add to your `~/.bashrc`: `export TERM=screen-256color`

### Symbols/Icons Not Working in Shell

1. Verify your terminal uses a Nerd Font
2. Check that your shell prompt sources the theme: `echo $PROMPT_PRIMARY`
3. Reload your shell: `exec bash` or `exec zsh`

## Tips & Tricks

### Switch Theme Based on Time of Day

Create a script to automatically switch themes:

```bash
#!/bin/bash
HOUR=$(date +%H)

if [[ $HOUR -lt 6 || $HOUR -gt 18 ]]; then
    # Night theme
    ~/.devops-workspace/scripts/core/theme-switcher.sh switch nord
else
    # Day theme
    ~/.devops-workspace/scripts/core/theme-switcher.sh switch gruvbox
fi
```

### Create Theme Aliases

Add to your `.bashrc`:

```bash
alias theme-dark="~/.devops-workspace/scripts/core/theme-switcher.sh switch dracula"
alias theme-light="~/.devops-workspace/scripts/core/theme-switcher.sh switch gruvbox"
alias theme-cool="~/.devops-workspace/scripts/core/theme-switcher.sh switch nord"
```

### Preview All Themes

```bash
~/.devops-workspace/scripts/core/theme-switcher.sh preview
```

## Further Reading

- [Nerd Fonts Official Site](https://www.nerdfonts.com/)
- [Dracula Theme](https://draculatheme.com/)
- [Nord Theme](https://www.nordtheme.com/)
- [Gruvbox](https://github.com/morhetz/gruvbox)
- [Solarized](https://ethanschoonover.com/solarized/)
- [Tokyo Night Theme](https://github.com/enkia/tokyo-night-vscode-theme)
- [Catppuccin](https://catppuccin.com/)

## Support

For issues with themes or fonts:

1. Check your terminal emulator's font settings
2. Verify Nerd Fonts are installed: `fc-list | grep -i nerd`
3. Review the troubleshooting section above
4. Check the issue tracker on GitHub
