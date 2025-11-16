#!/usr/bin/env bash

###############################################################################
# Theme Switcher - Switch between installed themes
###############################################################################

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
THEME_DIR="${SCRIPT_DIR}/config/themes"
CONF_DIR="$HOME/.devops-workspace"

# Source theme manager
source "${THEME_DIR}/theme-manager.sh"

switch_theme() {
    local theme=$1

    if [[ -z "$theme" ]]; then
        echo -e "${RED}Error: Theme name required${NC}"
        return 1
    fi

    # Check if theme file exists
    if [[ ! -f "${THEME_DIR}/${theme}.sh" ]]; then
        echo -e "${RED}Error: Theme '${theme}' not found${NC}"
        echo -e "${YELLOW}Available themes:${NC}"
        list_themes
        return 1
    fi

    # Source the theme
    source "${THEME_DIR}/${theme}.sh"

    # Update tmux config to use the theme
    local tmux_conf="$CONF_DIR/.tmux-${theme}.conf"
    if [[ -f "$tmux_conf" ]]; then
        mkdir -p "$CONF_DIR"
        cp "$tmux_conf" "$CONF_DIR/.tmux-active-theme.conf"
        echo -e "${GREEN}Tmux theme updated${NC}"
    fi

    # Save configuration
    save_theme_config "$theme" "${SELECTED_FONT:-Default}"

    # Update shell prompt (if bash)
    if [[ "${SHELL##*/}" == "bash" ]]; then
        update_bash_prompt "$theme"
    fi

    echo -e "${GREEN}Theme switched to: ${YELLOW}${theme}${GREEN}${NC}"
    echo -e "${CYAN}Run 'tmux kill-server' and restart tmux to see changes${NC}"

    return 0
}

update_bash_prompt() {
    local theme=$1

    # Source theme to get color variables
    source "${THEME_DIR}/${theme}.sh"

    # Create prompt file
    local prompt_file="$CONF_DIR/.bash-theme-prompt"

    cat > "$prompt_file" << EOF
# Theme-based Bash Prompt for $theme

# Get git branch if in git repo
get_git_branch() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        local branch=\$(git branch --show-current 2>/dev/null)
        if [[ -n "\$branch" ]]; then
            echo " (${PROMPT_SECONDARY}\${branch}${PROMPT_RESET})"
        fi
    fi
}

# PS1 with theme colors
export PS1="${PROMPT_PRIMARY}\\u@\\h${PROMPT_RESET} ${PROMPT_SECONDARY}\\w${PROMPT_RESET}\$(get_git_branch) ${PROMPT_ERROR}❯${PROMPT_RESET} "
EOF

    echo -e "${GREEN}Bash prompt updated${NC}"
}

interactive_switch() {
    echo -e "${BLUE}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║              Switch Terminal Theme                        ║${NC}"
    echo -e "${BLUE}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""

    show_theme_menu

    read -p "Select theme number: " choice

    if [[ ! "$choice" =~ ^[0-9]+$ ]] || [[ $choice -lt 1 ]] || [[ $choice -gt ${#THEMES[@]} ]]; then
        echo -e "${RED}Invalid selection${NC}"
        return 1
    fi

    local selected_theme=$(get_theme_name "$choice")
    if [[ -n "$selected_theme" ]]; then
        switch_theme "$selected_theme"
        return 0
    else
        echo -e "${RED}Failed to select theme${NC}"
        return 1
    fi
}

interactive_font_switch() {
    echo -e "${BLUE}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║              Switch Nerd Font                             ║${NC}"
    echo -e "${BLUE}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""

    show_font_menu

    read -p "Select font number: " choice

    if [[ ! "$choice" =~ ^[0-9]+$ ]] || [[ $choice -lt 1 ]] || [[ $choice -gt ${#NERD_FONTS[@]} ]]; then
        echo -e "${RED}Invalid selection${NC}"
        return 1
    fi

    local selected_font=$(get_font_name "$choice")
    if [[ -n "$selected_font" ]]; then
        # Update theme config with font
        if [[ -f "$CONF_DIR/theme.conf" ]]; then
            sed -i "s/CURRENT_FONT=.*/CURRENT_FONT=\"${selected_font}\"/" "$CONF_DIR/theme.conf"
        fi

        echo -e "${GREEN}Font switched to: ${YELLOW}${selected_font}${GREEN}${NC}"
        echo -e "${CYAN}Note: Configure your terminal emulator to use this font${NC}"
        return 0
    else
        echo -e "${RED}Failed to select font${NC}"
        return 1
    fi
}

show_current_theme() {
    local current_theme=$(get_current_theme)
    local current_font=$(get_current_font)

    echo -e "${BLUE}Current Configuration:${NC}"
    echo "  Theme: ${YELLOW}${current_theme:-Not set}${NC}"
    echo "  Font:  ${YELLOW}${current_font:-Default}${NC}"
    echo ""
}

list_theme_previews() {
    echo -e "${BLUE}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║              Theme Color Previews                         ║${NC}"
    echo -e "${BLUE}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""

    for theme_name in "${!THEMES[@]}"; do
        source "${THEME_DIR}/${theme_name}.sh" 2>/dev/null || continue

        echo -e "${PROMPT_PRIMARY}● ${theme_name}${PROMPT_RESET} - ${PROMPT_SUCCESS}Success${PROMPT_RESET} ${PROMPT_ERROR}Error${PROMPT_RESET} ${PROMPT_SECONDARY}Secondary${PROMPT_RESET}"
    done

    echo ""
}

# Parse arguments
case "${1:-}" in
    list)
        show_current_theme
        list_themes
        ;;
    list-fonts)
        list_fonts
        ;;
    preview)
        list_theme_previews
        ;;
    switch)
        if [[ -z "${2:-}" ]]; then
            interactive_switch
        else
            switch_theme "$2"
        fi
        ;;
    font)
        if [[ -z "${2:-}" ]]; then
            interactive_font_switch
        else
            # Validate and switch font
            local valid=false
            for font in "${NERD_FONTS[@]}"; do
                if [[ "$font" == "$2" ]]; then
                    valid=true
                    break
                fi
            done

            if [[ "$valid" == "true" ]]; then
                if [[ -f "$CONF_DIR/theme.conf" ]]; then
                    sed -i "s/CURRENT_FONT=.*/CURRENT_FONT=\"$2\"/" "$CONF_DIR/theme.conf"
                fi
                echo -e "${GREEN}Font switched to: ${YELLOW}$2${GREEN}${NC}"
            else
                echo -e "${RED}Invalid font: $2${NC}"
                list_fonts
                return 1
            fi
        fi
        ;;
    *)
        cat << EOF
Usage: theme-switcher [COMMAND] [OPTION]

Commands:
  switch [THEME]        Switch to a theme (interactive if no theme specified)
  font [FONT]           Switch to a Nerd Font (interactive if no font specified)
  list                  List available themes and show current configuration
  list-fonts            List available Nerd Fonts
  preview               Preview all theme colors

Examples:
  theme-switcher switch dracula
  theme-switcher font "FiraCode"
  theme-switcher preview
  theme-switcher list

Available themes:
EOF
        list_themes
        ;;
esac
