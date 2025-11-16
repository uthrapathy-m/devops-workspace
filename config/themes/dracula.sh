#!/usr/bin/env bash

# Dracula Theme - Dark purple-based theme
# Perfect for terminal work with high contrast

export COLOR_BACKGROUND="#282A36"
export COLOR_FOREGROUND="#F8F8F2"
export COLOR_CURSOR="#F8F8F0"
export COLOR_SELECTION="#44475A"

# Dracula color palette
export COLOR_BLACK="#282A36"
export COLOR_RED="#FF5555"
export COLOR_GREEN="#50FA7B"
export COLOR_YELLOW="#F1FA8C"
export COLOR_BLUE="#BD93F9"
export COLOR_MAGENTA="#FF79C6"
export COLOR_CYAN="#8BE9FD"
export COLOR_WHITE="#F8F8F2"

# Bright variants
export COLOR_BRIGHT_BLACK="#6272A4"
export COLOR_BRIGHT_RED="#FF6E6E"
export COLOR_BRIGHT_GREEN="#69FF94"
export COLOR_BRIGHT_YELLOW="#FFFFA5"
export COLOR_BRIGHT_BLUE="#D6ACFF"
export COLOR_BRIGHT_MAGENTA="#FF92DF"
export COLOR_BRIGHT_CYAN="#A4FFFF"
export COLOR_BRIGHT_WHITE="#FFFFFF"

# Terminal PS1 Colors for Dracula
export PROMPT_PRIMARY='\033[38;5;189m'      # BD93F9 - Purple
export PROMPT_SECONDARY='\033[38;5;141m'    # Magenta accent
export PROMPT_SUCCESS='\033[38;5;84m'       # Green
export PROMPT_ERROR='\033[38;5;203m'        # Red
export PROMPT_RESET='\033[0m'

# Tmux theme configuration
cat > "$HOME/.tmux-dracula.conf" << 'EOF'
# Dracula Theme for tmux

# Status bar
set -g status-style bg="#282A36",fg="#F8F8F2"
set -g status-left-length 40
set -g status-left "#[fg=#BD93F9]Session: #S #[fg=#F1FA8C]#I #[fg=#8BE9FD]#P"
set -g status-right "#[fg=#8BE9FD]%d %b %R"

# Pane border styling
set -g pane-border-style fg="#44475A"
set -g pane-active-border-style fg="#BD93F9"

# Window status styling
setw -g window-status-style fg="#6272A4"
setw -g window-status-current-style fg="#FF79C6",bold

# Message styling
set -g message-style bg="#282A36",fg="#F1FA8C"
EOF

echo "Dracula theme loaded"
