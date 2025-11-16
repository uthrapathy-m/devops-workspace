#!/usr/bin/env bash

# Solarized Dark Theme - Precision colors for machines and people
# Carefully chosen colors that work well in different lighting conditions

export COLOR_BACKGROUND="#002B36"
export COLOR_FOREGROUND="#839496"
export COLOR_CURSOR="#93A1A1"
export COLOR_SELECTION="#073642"

# Solarized Dark color palette
export COLOR_BLACK="#073642"
export COLOR_RED="#DC322F"
export COLOR_GREEN="#859900"
export COLOR_YELLOW="#B58900"
export COLOR_BLUE="#268BD2"
export COLOR_MAGENTA="#D33682"
export COLOR_CYAN="#2AA198"
export COLOR_WHITE="#EEE8D5"

# Bright variants (Solarized uses a different approach)
export COLOR_BRIGHT_BLACK="#002B36"
export COLOR_BRIGHT_RED="#CB4B16"
export COLOR_BRIGHT_GREEN="#586E75"
export COLOR_BRIGHT_YELLOW="#657B83"
export COLOR_BRIGHT_BLUE="#839496"
export COLOR_BRIGHT_MAGENTA="#6C71C4"
export COLOR_BRIGHT_CYAN="#93A1A1"
export COLOR_BRIGHT_WHITE="#FDF6E3"

# Terminal PS1 Colors for Solarized Dark
export PROMPT_PRIMARY='\033[38;5;33m'       # 268BD2 - Blue
export PROMPT_SECONDARY='\033[38;5;125m'    # D33682 - Magenta
export PROMPT_SUCCESS='\033[38;5;100m'      # 859900 - Green
export PROMPT_ERROR='\033[38;5;160m'        # DC322F - Red
export PROMPT_RESET='\033[0m'

# Tmux theme configuration
cat > "$HOME/.tmux-solarized-dark.conf" << 'EOF'
# Solarized Dark Theme for tmux

# Status bar
set -g status-style bg="#002B36",fg="#839496"
set -g status-left-length 40
set -g status-left "#[fg=#268BD2]Session: #S #[fg=#B58900]#I #[fg=#2AA198]#P"
set -g status-right "#[fg=#2AA198]%d %b %R"

# Pane border styling
set -g pane-border-style fg="#073642"
set -g pane-active-border-style fg="#268BD2"

# Window status styling
setw -g window-status-style fg="#586E75"
setw -g window-status-current-style fg="#D33682",bold

# Message styling
set -g message-style bg="#002B36",fg="#B58900"
EOF

echo "Solarized Dark theme loaded"
