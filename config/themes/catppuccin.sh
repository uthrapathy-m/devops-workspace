#!/usr/bin/env bash

# Catppuccin Theme - Soothing pastel theme
# Soft, warm, and inviting color palette with excellent readability

export COLOR_BACKGROUND="#1E1E2E"
export COLOR_FOREGROUND="#CDD6F4"
export COLOR_CURSOR="#F5E0DC"
export COLOR_SELECTION="#313244"

# Catppuccin Mocha color palette
export COLOR_BLACK="#45475A"
export COLOR_RED="#F38BA8"
export COLOR_GREEN="#A6E3A1"
export COLOR_YELLOW="#F9E2AF"
export COLOR_BLUE="#89B4FA"
export COLOR_MAGENTA="#F5C2E7"
export COLOR_CYAN="#94E2D5"
export COLOR_WHITE="#CDD6F4"

# Bright variants
export COLOR_BRIGHT_BLACK="#585B70"
export COLOR_BRIGHT_RED="#F38BA8"
export COLOR_BRIGHT_GREEN="#A6E3A1"
export COLOR_BRIGHT_YELLOW="#F9E2AF"
export COLOR_BRIGHT_BLUE="#89B4FA"
export COLOR_BRIGHT_MAGENTA="#F5C2E7"
export COLOR_BRIGHT_CYAN="#94E2D5"
export COLOR_BRIGHT_WHITE="#FFFFFF"

# Terminal PS1 Colors for Catppuccin
export PROMPT_PRIMARY='\033[38;5;117m'      # 89B4FA - Blue
export PROMPT_SECONDARY='\033[38;5;183m'    # F5C2E7 - Magenta
export PROMPT_SUCCESS='\033[38;5;157m'      # A6E3A1 - Green
export PROMPT_ERROR='\033[38;5;211m'        # F38BA8 - Red
export PROMPT_RESET='\033[0m'

# Tmux theme configuration
cat > "$HOME/.tmux-catppuccin.conf" << 'EOF'
# Catppuccin Theme for tmux

# Status bar
set -g status-style bg="#1E1E2E",fg="#CDD6F4"
set -g status-left-length 40
set -g status-left "#[fg=#89B4FA]Session: #S #[fg=#F9E2AF]#I #[fg=#94E2D5]#P"
set -g status-right "#[fg=#94E2D5]%d %b %R"

# Pane border styling
set -g pane-border-style fg="#313244"
set -g pane-active-border-style fg="#89B4FA"

# Window status styling
setw -g window-status-style fg="#585B70"
setw -g window-status-current-style fg="#F9E2AF",bold

# Message styling
set -g message-style bg="#1E1E2E",fg="#F9E2AF"
EOF

echo "Catppuccin theme loaded"
