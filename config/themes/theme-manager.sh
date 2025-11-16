#!/usr/bin/env bash

###############################################################################
# DevOps Workspace Theme Manager
# Manages terminal themes and nerd font integration
###############################################################################

# Source color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Available themes
declare -A THEMES=(
    [dracula]="dracula:Dracula theme with purple accents"
    [nord]="nord:Nord theme with cool, arctic colors"
    [gruvbox]="gruvbox:Gruvbox retro theme with warm colors"
    [solarized-dark]="solarized-dark:Solarized dark theme"
    [solarized-light]="solarized-light:Solarized light theme"
    [monokai]="monokai:Monokai theme with vibrant colors"
    [tokyo-night]="tokyo-night:Tokyo Night theme with neon colors"
    [catppuccin]="catppuccin:Catppuccin theme with soft colors"
    [one-dark]="one-dark:Atom One Dark theme"
    [cyberpunk]="cyberpunk:Cyberpunk neon theme"
)

# Nerd fonts available
declare -a NERD_FONTS=(
    "FiraCode"
    "JetBrains Mono"
    "Fira Code"
    "Hack"
    "Roboto Mono"
    "Cousine"
    "Source Code Pro"
    "DejaVu Sans Mono"
    "Ubuntu Mono"
    "Inconsolata"
)

show_theme_menu() {
    echo -e "${BLUE}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║           Available Terminal Themes with Nerd Fonts         ║${NC}"
    echo -e "${BLUE}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""

    local i=1
    for theme in "${!THEMES[@]}"; do
        local description="${THEMES[$theme]}"
        printf "%2d. %-20s - %s\n" "$i" "$theme" "${description#*:}"
        ((i++))
    done
    echo ""
}

show_font_menu() {
    echo -e "${BLUE}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║              Available Nerd Fonts                           ║${NC}"
    echo -e "${BLUE}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""

    local i=1
    for font in "${NERD_FONTS[@]}"; do
        printf "%2d. %s\n" "$i" "$font"
        ((i++))
    done
    echo ""
}

list_themes() {
    echo -e "${GREEN}Available Themes:${NC}"
    for theme in "${!THEMES[@]}"; do
        local description="${THEMES[$theme]}"
        echo "  - $theme: ${description#*:}"
    done
    echo ""
}

list_fonts() {
    echo -e "${GREEN}Available Nerd Fonts:${NC}"
    for font in "${NERD_FONTS[@]}"; do
        echo "  - $font"
    done
    echo ""
}

get_theme_name() {
    local index=$1
    local i=1
    for theme in "${!THEMES[@]}"; do
        if [[ $i -eq $index ]]; then
            echo "$theme"
            return 0
        fi
        ((i++))
    done
    return 1
}

get_font_name() {
    local index=$1
    if [[ $index -ge 1 ]] && [[ $index -le ${#NERD_FONTS[@]} ]]; then
        echo "${NERD_FONTS[$((index - 1))]}"
        return 0
    fi
    return 1
}

interactive_theme_selection() {
    echo -e "${CYAN}Select a theme for your terminal:${NC}"
    show_theme_menu

    read -p "Enter theme number (1-${#THEMES[@]}): " theme_choice

    if [[ ! "$theme_choice" =~ ^[0-9]+$ ]] || [[ $theme_choice -lt 1 ]] || [[ $theme_choice -gt ${#THEMES[@]} ]]; then
        echo -e "${RED}Invalid selection${NC}"
        return 1
    fi

    SELECTED_THEME=$(get_theme_name "$theme_choice")
    echo -e "${GREEN}Selected theme: $SELECTED_THEME${NC}"
    return 0
}

interactive_font_selection() {
    echo -e "${CYAN}Select a nerd font for your terminal:${NC}"
    show_font_menu

    read -p "Enter font number (1-${#NERD_FONTS[@]}): " font_choice

    if [[ ! "$font_choice" =~ ^[0-9]+$ ]] || [[ $font_choice -lt 1 ]] || [[ $font_choice -gt ${#NERD_FONTS[@]} ]]; then
        echo -e "${RED}Invalid selection${NC}"
        return 1
    fi

    SELECTED_FONT=$(get_font_name "$font_choice")
    echo -e "${GREEN}Selected font: $SELECTED_FONT${NC}"
    return 0
}

export_theme_variables() {
    local theme=$1
    local theme_file="$SCRIPT_DIR/config/themes/${theme}.sh"

    if [[ -f "$theme_file" ]]; then
        source "$theme_file"
        return 0
    else
        echo -e "${RED}Theme file not found: $theme_file${NC}"
        return 1
    fi
}

get_current_theme() {
    grep "CURRENT_THEME=" "$HOME/.devops-workspace/theme.conf" 2>/dev/null | cut -d'=' -f2 | tr -d '"'
}

get_current_font() {
    grep "CURRENT_FONT=" "$HOME/.devops-workspace/theme.conf" 2>/dev/null | cut -d'=' -f2 | tr -d '"'
}

save_theme_config() {
    local theme=$1
    local font=$2

    mkdir -p "$HOME/.devops-workspace"
    cat > "$HOME/.devops-workspace/theme.conf" << EOF
# DevOps Workspace Theme Configuration
CURRENT_THEME="$theme"
CURRENT_FONT="$font"
LAST_UPDATED="$(date)"
EOF

    echo -e "${GREEN}Theme configuration saved${NC}"
}
