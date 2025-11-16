#!/usr/bin/env bash

# Tokyo Night Theme - Modern neon colors inspired by Tokyo at night
# Contemporary theme with vibrant, tech-forward colors

export COLOR_BACKGROUND="#1A1B26"
export COLOR_FOREGROUND="#C0CAF5"
export COLOR_CURSOR="#7AA2F7"
export COLOR_SELECTION="#283457"

# Tokyo Night color palette
export COLOR_BLACK="#1A1B26"
export COLOR_RED="#F7768E"
export COLOR_GREEN="#9ECE6A"
export COLOR_YELLOW="#E0AF68"
export COLOR_BLUE="#7AA2F7"
export COLOR_MAGENTA="#AD8EE6"
export COLOR_CYAN="#449DAB"
export COLOR_WHITE="#C0CAF5"

# Bright variants
export COLOR_BRIGHT_BLACK="#414868"
export COLOR_BRIGHT_RED="#F7768E"
export COLOR_BRIGHT_GREEN="#9ECE6A"
export COLOR_BRIGHT_YELLOW="#E0AF68"
export COLOR_BRIGHT_BLUE="#7AA2F7"
export COLOR_BRIGHT_MAGENTA="#BB9AF7"
export COLOR_BRIGHT_CYAN="#7DCFFF"
export COLOR_BRIGHT_WHITE="#E0AF68"

# Terminal PS1 Colors for Tokyo Night
export PROMPT_PRIMARY='\033[38;5;117m'      # 7AA2F7 - Blue
export PROMPT_SECONDARY='\033[38;5;176m'    # AD8EE6 - Magenta
export PROMPT_SUCCESS='\033[38;5;150m'      # 9ECE6A - Green
export PROMPT_ERROR='\033[38;5;203m'        # F7768E - Red
export PROMPT_RESET='\033[0m'

# Tmux theme configuration
cat > "$HOME/.tmux-tokyo-night.conf" << 'EOF'
# Tokyo Night Theme for tmux

# Status bar
set -g status-style bg="#1A1B26",fg="#C0CAF5"
set -g status-left-length 40
set -g status-left "#[fg=#7AA2F7]Session: #S #[fg=#E0AF68]#I #[fg=#7DCFFF]#P"
set -g status-right "#[fg=#7DCFFF]%d %b %R"

# Pane border styling
set -g pane-border-style fg="#283457"
set -g pane-active-border-style fg="#7AA2F7"

# Window status styling
setw -g window-status-style fg="#414868"
setw -g window-status-current-style fg="#E0AF68",bold

# Message styling
set -g message-style bg="#1A1B26",fg="#E0AF68"
EOF

echo "Tokyo Night theme loaded"
