#!/usr/bin/env bash

###############################################################################
# Nerd Fonts Installation
# Installs fonts patched with Nerd Font icons for better terminal experience
###############################################################################

install_nerd_fonts() {
    log_info "Installing Nerd Fonts..."

    case "$OS_FAMILY" in
        debian|redhat)
            install_nerd_fonts_linux
            ;;
        arch)
            install_nerd_fonts_arch
            ;;
        *)
            install_nerd_fonts_manual
            ;;
    esac
}

install_nerd_fonts_linux() {
    local fonts_dir="$HOME/.local/share/fonts"
    mkdir -p "$fonts_dir"

    # Popular Nerd Fonts to install
    local fonts=(
        "FiraCode"
        "JetBrainsMono"
        "Hack"
        "Inconsolata"
    )

    log_info "Installing Nerd Fonts to $fonts_dir..."

    for font in "${fonts[@]}"; do
        install_single_nerd_font "$font" "$fonts_dir"
    done

    # Refresh font cache
    fc-cache -fv "$fonts_dir" 2>/dev/null || true
    log_success "Nerd Fonts installed and cache refreshed"
}

install_nerd_fonts_arch() {
    log_info "Installing Nerd Fonts via pacman..."

    # Arch has some nerd fonts in AUR, but we'll install manually for consistency
    local fonts_dir="$HOME/.local/share/fonts"
    mkdir -p "$fonts_dir"

    local fonts=(
        "FiraCode"
        "JetBrainsMono"
        "Hack"
        "Inconsolata"
    )

    for font in "${fonts[@]}"; do
        install_single_nerd_font "$font" "$fonts_dir"
    done

    fc-cache -fv "$fonts_dir" 2>/dev/null || true
    log_success "Nerd Fonts installed"
}

install_nerd_fonts_manual() {
    log_info "Installing Nerd Fonts manually..."

    local fonts_dir="$HOME/.local/share/fonts"
    mkdir -p "$fonts_dir"

    local fonts=(
        "FiraCode"
        "JetBrainsMono"
        "Hack"
        "Inconsolata"
    )

    for font in "${fonts[@]}"; do
        install_single_nerd_font "$font" "$fonts_dir"
    done

    # Try to refresh cache if available
    if command_exists fc-cache; then
        fc-cache -fv "$fonts_dir" 2>/dev/null || true
    fi

    log_success "Nerd Fonts installed to $fonts_dir"
}

install_single_nerd_font() {
    local font_name=$1
    local fonts_dir=$2
    local nerd_fonts_repo="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts"

    log_info "Installing $font_name Nerd Font..."

    case "$font_name" in
        FiraCode)
            local url="${nerd_fonts_repo}/FiraCode/Regular/FiraCodeNerdFont-Regular.ttf"
            local font_file="FiraCodeNerdFont-Regular.ttf"
            ;;
        JetBrainsMono)
            local url="${nerd_fonts_repo}/JetBrainsMono/Regular/JetBrainsMonoNerdFont-Regular.ttf"
            local font_file="JetBrainsMonoNerdFont-Regular.ttf"
            ;;
        Hack)
            local url="${nerd_fonts_repo}/Hack/Regular/HackNerdFont-Regular.ttf"
            local font_file="HackNerdFont-Regular.ttf"
            ;;
        Inconsolata)
            local url="${nerd_fonts_repo}/Inconsolata/InconsolataNerdFont-Regular.ttf"
            local font_file="InconsolataNerdFont-Regular.ttf"
            ;;
        *)
            log_error "Unknown font: $font_name"
            return 1
            ;;
    esac

    if [[ ! -f "$fonts_dir/$font_file" ]]; then
        log_info "Downloading $font_name..."
        if curl -fsSL "$url" -o "$fonts_dir/$font_file"; then
            log_success "$font_name installed"
        else
            log_error "Failed to download $font_name"
            return 1
        fi
    else
        log_info "$font_name already installed"
    fi

    # Also install bold variant if available
    case "$font_name" in
        FiraCode)
            local bold_url="${nerd_fonts_repo}/FiraCode/Bold/FiraCodeNerdFont-Bold.ttf"
            local bold_file="FiraCodeNerdFont-Bold.ttf"
            ;;
        JetBrainsMono)
            local bold_url="${nerd_fonts_repo}/JetBrainsMono/Bold/JetBrainsMonoNerdFont-Bold.ttf"
            local bold_file="JetBrainsMonoNerdFont-Bold.ttf"
            ;;
        Hack)
            local bold_url="${nerd_fonts_repo}/Hack/Bold/HackNerdFont-Bold.ttf"
            local bold_file="HackNerdFont-Bold.ttf"
            ;;
        Inconsolata)
            # Inconsolata doesn't have bold
            return 0
            ;;
    esac

    if [[ ! -f "$fonts_dir/$bold_file" ]] && [[ -n "$bold_url" ]]; then
        log_info "Downloading $font_name Bold variant..."
        curl -fsSL "$bold_url" -o "$fonts_dir/$bold_file" || true
    fi
}

verify_nerd_fonts_installation() {
    local fonts_dir="$HOME/.local/share/fonts"

    if [[ ! -d "$fonts_dir" ]]; then
        log_error "Fonts directory not found: $fonts_dir"
        return 1
    fi

    local font_count=$(find "$fonts_dir" -name "*NerdFont*" -type f 2>/dev/null | wc -l)

    if [[ $font_count -gt 0 ]]; then
        log_success "Found $font_count Nerd Font files installed"
        log_info "Fonts are installed in: $fonts_dir"
        log_info "Configure your terminal to use one of the Nerd Fonts"
        return 0
    else
        log_warning "No Nerd Fonts found in $fonts_dir"
        return 1
    fi
}

list_installed_nerd_fonts() {
    local fonts_dir="$HOME/.local/share/fonts"

    echo ""
    echo -e "${BLUE}Installed Nerd Fonts:${NC}"
    echo "Location: $fonts_dir"
    echo ""

    if [[ -d "$fonts_dir" ]]; then
        find "$fonts_dir" -name "*NerdFont*" -type f | while read -r font; do
            echo "  - $(basename "$font")"
        done
    else
        echo "  (Fonts directory not found)"
    fi
    echo ""
}

# Allow sourcing as a function
export -f install_nerd_fonts
export -f install_single_nerd_font
export -f verify_nerd_fonts_installation
export -f list_installed_nerd_fonts
