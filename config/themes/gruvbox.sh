#!/usr/bin/env bash

# Gruvbox Theme - Retro warm colors
# Warm, comfortable palette inspired by old video game consoles

export COLOR_BACKGROUND="#282828"
export COLOR_FOREGROUND="#EBDBB2"
export COLOR_CURSOR="#FBF1C7"
export COLOR_SELECTION="#3C3836"

# Gruvbox color palette (Dark variant)
export COLOR_BLACK="#282828"
export COLOR_RED="#CC241D"
export COLOR_GREEN="#98971A"
export COLOR_YELLOW="#D79921"
export COLOR_BLUE="#458588"
export COLOR_MAGENTA="#B16286"
export COLOR_CYAN="#689D6A"
export COLOR_WHITE="#EBDBB2"

# Bright variants
export COLOR_BRIGHT_BLACK="#928374"
export COLOR_BRIGHT_RED="#FB4934"
export COLOR_BRIGHT_GREEN="#B8BB26"
export COLOR_BRIGHT_YELLOW="#FABD2F"
export COLOR_BRIGHT_BLUE="#83A598"
export COLOR_BRIGHT_MAGENTA="#D3869B"
export COLOR_BRIGHT_CYAN="#8EC07C"
export COLOR_BRIGHT_WHITE="#FBF1C7"

# Terminal PS1 Colors for Gruvbox
export PROMPT_PRIMARY='\033[38;5;175m'      # B16286 - Magenta
export PROMPT_SECONDARY='\033[38;5;214m'    # D79921 - Yellow
export PROMPT_SUCCESS='\033[38;5;106m'      # 98971A - Green
export PROMPT_ERROR='\033[38;5;167m'        # CC241D - Red
export PROMPT_RESET='\033[0m'

# Tmux theme configuration
cat > "$HOME/.tmux-gruvbox.conf" << 'EOF'
# Gruvbox Theme for tmux

# Status bar
set -g status-style bg="#282828",fg="#EBDBB2"
set -g status-left-length 40
set -g status-left "#[fg=#B16286]Session: #S #[fg=#D79921]#I #[fg=#689D6A]#P"
set -g status-right "#[fg=#689D6A]%d %b %R"

# Pane border styling
set -g pane-border-style fg="#3C3836"
set -g pane-active-border-style fg="#B16286"

# Window status styling
setw -g window-status-style fg="#928374"
setw -g window-status-current-style fg="#D79921",bold

# Message styling
set -g message-style bg="#282828",fg="#D79921"
EOF

echo "Gruvbox theme loaded"
