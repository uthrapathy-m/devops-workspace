#!/usr/bin/env bash

###############################################################################
# DevOps Workspace Installer
# Cross-Linux installer for DevOps tools with interactive selection
###############################################################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source core utilities
source "${SCRIPT_DIR}/scripts/core/detect_os.sh"
source "${SCRIPT_DIR}/scripts/core/utils.sh"
source "${SCRIPT_DIR}/scripts/core/nerd-fonts.sh"

# Installation tracking
INSTALL_LOG="${HOME}/.devops-workspace-install.log"
INSTALLED_TOOLS=()

###############################################################################
# Helper Functions
###############################################################################

print_banner() {
    echo -e "${BLUE}"
    cat << "EOF"
╔═══════════════════════════════════════════════════════════╗
║                                                           ║
║        DevOps Workspace Installer                        ║
║        Cross-Linux DevOps Tools Setup                    ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

show_usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Options:
    -h, --help              Show this help message
    -a, --all               Install all tools (non-interactive)
    -c, --category NAME     Install specific category only
                            (containers|cloud|iac|cicd|monitoring|productivity|network|languages)
    -l, --list              List all available tools
    -i, --interactive       Interactive mode (default)

Examples:
    $0                                  # Interactive menu
    $0 --all                           # Install everything
    $0 --category containers           # Install only container tools
    $0 --category productivity         # Install only productivity tools

EOF
}

list_tools() {
    echo -e "${GREEN}Available Tool Categories:${NC}\n"

    echo -e "${YELLOW}1. Containers & Orchestration${NC}"
    echo "   docker, podman, kubectl, k9s, helm, kind, docker-compose"

    echo -e "\n${YELLOW}2. Cloud CLI Tools${NC}"
    echo "   aws-cli, azure-cli, gcloud, terraform, pulumi, opentofu"

    echo -e "\n${YELLOW}3. Infrastructure as Code${NC}"
    echo "   ansible, packer, vagrant"

    echo -e "\n${YELLOW}4. CI/CD Tools${NC}"
    echo "   github-cli, gitlab-cli, argocd-cli"

    echo -e "\n${YELLOW}5. Monitoring & Observability${NC}"
    echo "   stern, ctop, htop, btop"

    echo -e "\n${YELLOW}6. Productivity CLI${NC}"
    echo "   tmux, fzf, ripgrep, bat, eza, fd, jq, yq, zoxide, neovim, lazyvim, ncdu, duf, lazydocker, tldr"

    echo -e "\n${YELLOW}7. Network & Security${NC}"
    echo "   net-tools, nmap, trivy, cosign, openssl"

    echo -e "\n${YELLOW}8. Languages & Runtimes${NC}"
    echo "   python3, node.js, go"

    echo -e "\n${YELLOW}9. Themes & Fonts${NC}"
    echo "   Nerd Fonts (FiraCode, JetBrains Mono, Hack, Inconsolata)"
    echo "   Terminal Themes (Dracula, Nord, Gruvbox, Solarized, Tokyo Night, Catppuccin)"

    echo ""
}

check_prerequisites() {
    log_info "Checking prerequisites..."

    # Check for sudo
    if ! command_exists sudo; then
        log_error "sudo is required but not installed. Please install sudo first."
        exit 1
    fi

    # Check for curl or wget
    if ! command_exists curl && ! command_exists wget; then
        log_error "Either curl or wget is required. Installing curl..."
        install_package curl
    fi

    # Check for basic build tools
    if ! command_exists make || ! command_exists gcc; then
        log_info "Installing build essentials..."
        install_build_essentials
    fi

    # Check and install common dependencies (unzip, jq, tar, gzip)
    ensure_common_dependencies

    log_success "Prerequisites check complete"
}

install_build_essentials() {
    case "$OS_FAMILY" in
        debian)
            sudo apt-get update && sudo apt-get install -y build-essential
            ;;
        redhat)
            sudo $PKG_MANAGER groupinstall -y "Development Tools"
            ;;
        arch)
            sudo pacman -S --noconfirm base-devel
            ;;
    esac
}

install_category() {
    local category=$1
    local script="${SCRIPT_DIR}/scripts/categories/${category}.sh"
    
    if [[ ! -f "$script" ]]; then
        log_error "Category script not found: $script"
        return 1
    fi
    
    log_info "Installing ${category} tools..."
    source "$script"
    
    # Call the install function (each category script has install_<category> function)
    local install_func="install_${category}"
    if declare -f "$install_func" > /dev/null; then
        $install_func
    else
        log_error "Install function not found: $install_func"
        return 1
    fi
}

setup_aliases() {
    log_info "Setting up DevOps aliases..."

    local shell_rc="$HOME/.bashrc"

    # Backup existing rc file
    if [[ -f "$shell_rc" ]]; then
        cp "$shell_rc" "${shell_rc}.backup.$(date +%Y%m%d_%H%M%S)"
    fi

    # Create .devops-workspace directory for configs
    mkdir -p "$HOME/.devops-workspace"

    # Copy cheatsheet
    if [[ -f "${SCRIPT_DIR}/config/ALIAS_CHEATSHEET.md" ]]; then
        cp "${SCRIPT_DIR}/config/ALIAS_CHEATSHEET.md" "$HOME/.devops-workspace/ALIAS_CHEATSHEET.md"
        log_success "Installed alias cheatsheet (type 'cheat' to view)"
    fi

    # Add source line for aliases if not already present
    if ! grep -q "source.*devops-workspace.*aliases.sh" "$shell_rc" 2>/dev/null; then
        echo "" >> "$shell_rc"
        echo "# DevOps Workspace Aliases" >> "$shell_rc"
        echo "[ -f \"${SCRIPT_DIR}/config/aliases.sh\" ] && source \"${SCRIPT_DIR}/config/aliases.sh\"" >> "$shell_rc"
        log_success "Added aliases to $shell_rc"
    else
        log_info "Aliases already configured in $shell_rc"
    fi
}

setup_dotfiles() {
    log_info "Setting up dotfiles..."

    # tmux config
    if [[ -f "${SCRIPT_DIR}/config/.tmux.conf" ]]; then
        cp "${SCRIPT_DIR}/config/.tmux.conf" "$HOME/.tmux.conf"
        log_success "Installed .tmux.conf"
    fi

    # vim config
    if [[ -f "${SCRIPT_DIR}/config/.vimrc" ]]; then
        cp "${SCRIPT_DIR}/config/.vimrc" "$HOME/.vimrc"
        log_success "Installed .vimrc"
    fi
}

setup_themes() {
    log_info "Setting up themes and fonts..."

    # Copy theme files
    if [[ -d "${SCRIPT_DIR}/config/themes" ]]; then
        mkdir -p "$HOME/.devops-workspace"
        log_info "Installing terminal themes..."

        # Interactive theme selection
        source "${SCRIPT_DIR}/config/themes/theme-manager.sh"

        echo ""
        echo -e "${BLUE}╔═══════════════════════════════════════════════════════════╗${NC}"
        echo -e "${BLUE}║           Select a Terminal Theme                         ║${NC}"
        echo -e "${BLUE}╚═══════════════════════════════════════════════════════════╝${NC}"
        echo ""

        show_theme_menu

        read -p "Select theme (1-${#THEMES[@]}, or press Enter for dracula): " theme_choice

        if [[ -z "$theme_choice" ]] || [[ $theme_choice -eq 1 ]]; then
            theme_choice=1
        fi

        if [[ "$theme_choice" =~ ^[0-9]+$ ]] && [[ $theme_choice -ge 1 ]] && [[ $theme_choice -le ${#THEMES[@]} ]]; then
            SELECTED_THEME=$(get_theme_name "$theme_choice")
            if [[ -n "$SELECTED_THEME" ]]; then
                # Source the theme
                source "${SCRIPT_DIR}/config/themes/${SELECTED_THEME}.sh"
                save_theme_config "$SELECTED_THEME" "Default"
                log_success "Theme selected: $SELECTED_THEME"
            fi
        else
            log_info "Using default theme: dracula"
            save_theme_config "dracula" "Default"
        fi
    fi

    # Install Nerd Fonts
    echo ""
    read -p "Install Nerd Fonts? (y/n, default: y): " install_fonts

    if [[ "$install_fonts" != "n" ]]; then
        install_nerd_fonts
        verify_nerd_fonts_installation
    fi

    log_success "Theme and font setup complete"
}

save_install_log() {
    {
        echo "# DevOps Workspace Installation Log"
        echo "# Installed on: $(date)"
        echo "# OS: $OS_NAME $OS_VERSION"
        echo ""
        echo "INSTALLED_TOOLS=("
        for tool in "${INSTALLED_TOOLS[@]}"; do
            echo "    \"$tool\""
        done
        echo ")"
    } > "$INSTALL_LOG"
    
    log_success "Installation log saved to: $INSTALL_LOG"
}

###############################################################################
# Main Installation Flow
###############################################################################

main() {
    print_banner
    
    # Parse arguments
    case "${1:-}" in
        -h|--help)
            show_usage
            exit 0
            ;;
        -l|--list)
            list_tools
            exit 0
            ;;
        -a|--all)
            INSTALL_ALL=true
            ;;
        -c|--category)
            CATEGORY="${2:-}"
            if [[ -z "$CATEGORY" ]]; then
                log_error "Category name required"
                show_usage
                exit 1
            fi
            ;;
        -i|--interactive|"")
            INTERACTIVE=true
            ;;
        *)
            log_error "Unknown option: $1"
            show_usage
            exit 1
            ;;
    esac
    
    # Detect OS
    detect_os
    log_info "Detected: $OS_NAME $OS_VERSION ($OS_FAMILY)"
    
    # Check prerequisites
    check_prerequisites
    
    # Installation logic
    if [[ "${INSTALL_ALL:-false}" == "true" ]]; then
        log_info "Installing all tools..."
        for category in containers cloud_tools iac_tools cicd_tools monitoring productivity network_security languages; do
            install_category "$category"
        done
        setup_themes
    elif [[ -n "${CATEGORY:-}" ]]; then
        if [[ "$CATEGORY" == "themes" || "$CATEGORY" == "fonts" ]]; then
            setup_themes
        else
            install_category "$CATEGORY"
        fi
    else
        # Interactive mode
        source "${SCRIPT_DIR}/menus/interactive_menu.sh"
        show_interactive_menu
    fi

    # Setup aliases and dotfiles
    setup_aliases
    setup_dotfiles
    setup_themes

    # Save installation log
    save_install_log
    
    # Final message
    echo ""
    echo -e "${GREEN}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                                                           ║${NC}"
    echo -e "${GREEN}║  Installation Complete! 🎉                                ║${NC}"
    echo -e "${GREEN}║                                                           ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    log_info "Please restart your shell or run: source ~/.bashrc"
    echo ""
    log_info "View installed tools: cat $INSTALL_LOG"
    log_info "View alias cheatsheet: cheat"
    log_info "Test your aliases: alias | grep -E 'kubectl|docker|terraform'"
    echo ""
}

# Run main function
main "$@"
