#!/usr/bin/env bash

# Nord Theme - Cool arctic colors
# Great for reducing eye strain with cool palette

export COLOR_BACKGROUND="#2E3440"
export COLOR_FOREGROUND="#ECEFF4"
export COLOR_CURSOR="#D8DEE9"
export COLOR_SELECTION="#434C5E"

# Nord color palette (Polar Night, Snow Storm, Frost, Aurora)
export COLOR_BLACK="#2E3440"
export COLOR_RED="#BF616A"
export COLOR_GREEN="#A3BE8C"
export COLOR_YELLOW="#EBCB8B"
export COLOR_BLUE="#81A1C1"
export COLOR_MAGENTA="#B48EAD"
export COLOR_CYAN="#88C0D0"
export COLOR_WHITE="#ECEFF4"

# Bright variants
export COLOR_BRIGHT_BLACK="#3B4252"
export COLOR_BRIGHT_RED="#D08770"
export COLOR_BRIGHT_GREEN="#8FBCBB"
export COLOR_BRIGHT_YELLOW="#E5C890"
export COLOR_BRIGHT_BLUE="#5E81AC"
export COLOR_BRIGHT_MAGENTA="#C397D8"
export COLOR_BRIGHT_CYAN="#81A1C1"
export COLOR_BRIGHT_WHITE="#FFFFFF"

# Terminal PS1 Colors for Nord
export PROMPT_PRIMARY='\033[38;5;136m'      # 81A1C1 - Blue
export PROMPT_SECONDARY='\033[38;5;108m'    # Frost
export PROMPT_SUCCESS='\033[38;5;109m'      # Green
export PROMPT_ERROR='\033[38;5;167m'        # Red
export PROMPT_RESET='\033[0m'

# Tmux theme configuration
cat > "$HOME/.tmux-nord.conf" << 'EOF'
# Nord Theme for tmux

# Status bar
set -g status-style bg="#2E3440",fg="#ECEFF4"
set -g status-left-length 40
set -g status-left "#[fg=#81A1C1]Session: #S #[fg=#EBCB8B]#I #[fg=#88C0D0]#P"
set -g status-right "#[fg=#88C0D0]%d %b %R"

# Pane border styling
set -g pane-border-style fg="#3B4252"
set -g pane-active-border-style fg="#81A1C1"

# Window status styling
setw -g window-status-style fg="#4C566A"
setw -g window-status-current-style fg="#B48EAD",bold

# Message styling
set -g message-style bg="#2E3440",fg="#EBCB8B"
EOF

echo "Nord theme loaded"
