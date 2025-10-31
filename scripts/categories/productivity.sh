#!/usr/bin/env bash

###############################################################################
# Productivity CLI Tools Installation
###############################################################################

install_productivity() {
    log_info "Installing Productivity CLI tools..."

    # Check if we should do interactive tool selection
    if [[ "${INTERACTIVE_TOOLS:-false}" == "true" ]]; then
        select_productivity_tools
    else
        # Install all tools in category
        install_all_productivity_tools
    fi

    log_success "Productivity CLI tools installation complete"
}

select_productivity_tools() {
    echo ""
    echo -e "${BLUE}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║     Select Individual Productivity Tools to Install       ║${NC}"
    echo -e "${BLUE}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""

    local tools=(
        "tmux:tmux:install_tmux"
        "fzf:fzf:install_fzf"
        "ripgrep:rg:install_ripgrep"
        "bat:bat:install_bat"
        "eza:eza:install_eza"
        "fd:fd:install_fd"
        "jq:jq:install_jq"
        "yq:yq:install_yq"
        "neovim:nvim:install_neovim"
        "ncdu:ncdu:install_ncdu"
        "duf:duf:install_duf"
        "lazydocker:lazydocker:install_lazydocker"
        "tldr:tldr:install_tldr"
    )

    local selected_tools=()

    PS3="Select tool to install (0 to finish and install, q to quit): "

    while true; do
        echo ""
        echo "Currently selected tools:"
        if [[ ${#selected_tools[@]} -eq 0 ]]; then
            echo "  (none)"
        else
            for tool in "${selected_tools[@]}"; do
                local tool_name=$(echo "$tool" | cut -d: -f1)
                echo "  - $tool_name"
            done
        fi
        echo ""

        local menu_options=()
        for tool_info in "${tools[@]}"; do
            local tool_name=$(echo "$tool_info" | cut -d: -f1)
            local tool_cmd=$(echo "$tool_info" | cut -d: -f2)

            # Check if already installed
            if is_installed "$tool_cmd"; then
                menu_options+=("$tool_name (already installed)")
            else
                menu_options+=("$tool_name")
            fi
        done

        menu_options+=("Install All" "Done - Start Installation" "Quit")

        select opt in "${menu_options[@]}"; do
            if [[ "$REPLY" == "q" ]]; then
                echo "Installation cancelled."
                exit 0
            elif [[ "$REPLY" -ge 1 ]] && [[ "$REPLY" -le ${#tools[@]} ]]; then
                local tool_index=$((REPLY - 1))
                local tool_info="${tools[$tool_index]}"
                local tool_name=$(echo "$tool_info" | cut -d: -f1)
                local tool_cmd=$(echo "$tool_info" | cut -d: -f2)

                if is_installed "$tool_cmd"; then
                    echo "  $tool_name is already installed, skipping..."
                else
                    selected_tools+=("$tool_info")
                    echo "  Added: $tool_name"
                fi
                break
            elif [[ "$REPLY" -eq $((${#tools[@]} + 1)) ]]; then
                # Install All
                for tool_info in "${tools[@]}"; do
                    selected_tools+=("$tool_info")
                done
                echo "  Added: All tools"
                break
            elif [[ "$REPLY" -eq $((${#tools[@]} + 2)) ]]; then
                # Done - Start Installation
                if [[ ${#selected_tools[@]} -eq 0 ]]; then
                    echo "No tools selected. Please select at least one."
                    break
                fi

                echo ""
                log_info "Starting installation of selected tools..."
                for tool_info in "${selected_tools[@]}"; do
                    local tool_name=$(echo "$tool_info" | cut -d: -f1)
                    local tool_cmd=$(echo "$tool_info" | cut -d: -f2)
                    local install_func=$(echo "$tool_info" | cut -d: -f3)

                    if ! is_installed "$tool_cmd"; then
                        $install_func
                    fi
                done
                return 0
            elif [[ "$REPLY" -eq $((${#tools[@]} + 3)) ]]; then
                # Quit
                echo "Installation cancelled."
                exit 0
            else
                echo "Invalid option"
                break
            fi
        done
    done
}

install_all_productivity_tools() {
    # tmux
    if ! is_installed tmux; then
        install_tmux
    fi

    # fzf (fuzzy finder)
    if ! is_installed fzf; then
        install_fzf
    fi

    # ripgrep
    if ! is_installed rg; then
        install_ripgrep
    fi

    # bat (better cat)
    if ! is_installed bat; then
        install_bat
    fi

    # eza (better ls)
    if ! is_installed eza; then
        install_eza
    fi

    # fd (better find)
    if ! is_installed fd; then
        install_fd
    fi

    # jq (JSON processor)
    if ! is_installed jq; then
        install_jq
    fi

    # yq (YAML processor)
    if ! is_installed yq; then
        install_yq
    fi

    # neovim
    if ! is_installed nvim; then
        install_neovim
    fi

    # ncdu (disk usage)
    if ! is_installed ncdu; then
        install_ncdu
    fi

    # duf (disk usage/free)
    if ! is_installed duf; then
        install_duf
    fi

    # lazydocker (Docker TUI)
    if ! is_installed lazydocker; then
        install_lazydocker
    fi

    # tldr (simplified man pages)
    if ! is_installed tldr; then
        install_tldr
    fi
}

install_tmux() {
    log_info "Installing tmux..."
    install_package tmux
    verify_installation tmux
}

install_fzf() {
    log_info "Installing fzf..."

    # Clone fzf repository
    if [[ ! -d "$HOME/.fzf" ]]; then
        git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
        "$HOME/.fzf/install" --all --no-fish
    else
        log_info "fzf already installed"
    fi

    verify_installation fzf
}

install_ripgrep() {
    log_info "Installing ripgrep..."
    
    case "$OS_FAMILY" in
        debian)
            install_package ripgrep
            ;;
        redhat)
            install_package ripgrep
            ;;
        arch)
            install_package ripgrep
            ;;
        *)
            # Manual installation
            install_from_github_release "BurntSushi/ripgrep" "rg" "ripgrep-{version}-$(uname -m)-unknown-linux-musl.tar.gz"
            ;;
    esac
    
    verify_installation rg
}

install_bat() {
    log_info "Installing bat..."
    
    case "$OS_FAMILY" in
        debian)
            install_package bat
            # Create symlink if installed as batcat
            if command_exists batcat && ! command_exists bat; then
                sudo ln -sf $(which batcat) /usr/local/bin/bat
            fi
            ;;
        redhat)
            install_package bat
            ;;
        arch)
            install_package bat
            ;;
        *)
            install_from_github_release "sharkdp/bat" "bat" "bat-{version}-$(uname -m)-unknown-linux-musl.tar.gz"
            ;;
    esac
    
    verify_installation bat
}

install_eza() {
    log_info "Installing eza..."
    
    case "$OS_FAMILY" in
        debian|redhat)
            # Manual installation for debian/redhat
            local version=$(get_latest_github_release "eza-community/eza")
            local arch=$(uname -m)
            
            curl -fsSL "https://github.com/eza-community/eza/releases/download/${version}/eza_${arch}-unknown-linux-gnu.tar.gz" -o /tmp/eza.tar.gz
            
            sudo tar -xzf /tmp/eza.tar.gz -C /usr/local/bin
            rm /tmp/eza.tar.gz
            ;;
        arch)
            install_package eza
            ;;
    esac
    
    verify_installation eza
}

install_fd() {
    log_info "Installing fd..."
    
    case "$OS_FAMILY" in
        debian)
            install_package fd-find
            # Create symlink
            if command_exists fdfind && ! command_exists fd; then
                sudo ln -sf $(which fdfind) /usr/local/bin/fd
            fi
            ;;
        redhat)
            install_package fd-find
            ;;
        arch)
            install_package fd
            ;;
        *)
            install_from_github_release "sharkdp/fd" "fd" "fd-{version}-$(uname -m)-unknown-linux-musl.tar.gz"
            ;;
    esac
    
    verify_installation fd
}

install_jq() {
    log_info "Installing jq..."
    install_package jq
    verify_installation jq
}

install_yq() {
    log_info "Installing yq..."
    
    local version=$(get_latest_github_release "mikefarah/yq")
    local arch=$(get_arch)
    local os=$(get_os_type)
    
    curl -fsSL "https://github.com/mikefarah/yq/releases/download/${version}/yq_${os}_${arch}" -o /tmp/yq
    
    sudo install -m 755 /tmp/yq /usr/local/bin/yq
    rm /tmp/yq
    
    verify_installation yq
}

install_neovim() {
    log_info "Installing neovim..."
    
    case "$OS_FAMILY" in
        debian)
            # Add neovim PPA for latest version
            sudo apt-get install -y software-properties-common
            sudo add-apt-repository -y ppa:neovim-ppa/stable
            sudo apt-get update
            install_package neovim
            ;;
        redhat)
            install_package neovim
            ;;
        arch)
            install_package neovim
            ;;
    esac
    
    verify_installation nvim
}

install_ncdu() {
    log_info "Installing ncdu..."
    install_package ncdu
    verify_installation ncdu
}

install_duf() {
    log_info "Installing duf..."

    local version=$(get_latest_github_release "muesli/duf")
    if [[ -z "$version" ]]; then
        log_error "Failed to get duf version"
        return 1
    fi

    local arch=$(get_arch)
    local os=$(get_os_type)

    case "$OS_FAMILY" in
        debian)
            local deb_url="https://github.com/muesli/duf/releases/download/${version}/duf_${version#v}_${os}_${arch}.deb"
            log_info "Downloading from: $deb_url"

            curl -fsSL "$deb_url" -o /tmp/duf.deb
            if [[ ! -f /tmp/duf.deb || ! -s /tmp/duf.deb ]]; then
                log_error "Failed to download duf"
                return 1
            fi
            sudo dpkg -i /tmp/duf.deb
            rm /tmp/duf.deb
            ;;
        redhat)
            local rpm_url="https://github.com/muesli/duf/releases/download/${version}/duf_${version#v}_${os}_${arch}.rpm"
            log_info "Downloading from: $rpm_url"

            curl -fsSL "$rpm_url" -o /tmp/duf.rpm
            if [[ ! -f /tmp/duf.rpm || ! -s /tmp/duf.rpm ]]; then
                log_error "Failed to download duf"
                return 1
            fi
            sudo $PKG_MANAGER install -y /tmp/duf.rpm
            rm /tmp/duf.rpm
            ;;
        *)
            # Manual installation from tar.gz
            local tar_url="https://github.com/muesli/duf/releases/download/${version}/duf_${version#v}_${os}_${arch}.tar.gz"
            log_info "Downloading from: $tar_url"

            local temp_dir=$(create_temp_dir)
            curl -fsSL "$tar_url" -o "$temp_dir/duf.tar.gz"

            if [[ ! -f "$temp_dir/duf.tar.gz" || ! -s "$temp_dir/duf.tar.gz" ]]; then
                log_error "Failed to download duf"
                cleanup_temp_dir "$temp_dir"
                return 1
            fi

            tar -xzf "$temp_dir/duf.tar.gz" -C "$temp_dir"
            local duf_bin=$(find "$temp_dir" -name "duf" -type f | head -n1)

            if [[ -z "$duf_bin" ]]; then
                log_error "duf binary not found in archive"
                cleanup_temp_dir "$temp_dir"
                return 1
            fi

            sudo install -m 755 "$duf_bin" /usr/local/bin/duf
            cleanup_temp_dir "$temp_dir"
            ;;
    esac

    verify_installation duf
}

install_lazydocker() {
    log_info "Installing lazydocker..."

    local version=$(get_latest_github_release "jesseduffield/lazydocker")
    if [[ -z "$version" ]]; then
        log_error "Failed to get lazydocker version"
        return 1
    fi

    local arch=$(get_arch)
    local os=$(get_os_type)

    # Map architecture - lazydocker uses x86_64 not amd64
    local ld_arch="$arch"
    if [[ "$arch" == "amd64" ]]; then
        ld_arch="x86_64"
    fi

    local tar_url="https://github.com/jesseduffield/lazydocker/releases/download/${version}/lazydocker_${version#v}_${os}_${ld_arch}.tar.gz"
    log_info "Downloading from: $tar_url"

    local temp_dir=$(create_temp_dir)
    curl -fsSL "$tar_url" -o "$temp_dir/lazydocker.tar.gz"

    if [[ ! -f "$temp_dir/lazydocker.tar.gz" || ! -s "$temp_dir/lazydocker.tar.gz" ]]; then
        log_error "Failed to download lazydocker"
        cleanup_temp_dir "$temp_dir"
        return 1
    fi

    tar -xzf "$temp_dir/lazydocker.tar.gz" -C "$temp_dir"

    local ld_bin=$(find "$temp_dir" -name "lazydocker" -type f | head -n1)
    if [[ -z "$ld_bin" ]]; then
        log_error "lazydocker binary not found in archive"
        cleanup_temp_dir "$temp_dir"
        return 1
    fi

    sudo install -m 755 "$ld_bin" /usr/local/bin/lazydocker
    cleanup_temp_dir "$temp_dir"

    verify_installation lazydocker
}

install_tldr() {
    log_info "Installing tldr..."

    # Install via npm if available, otherwise pip
    if command_exists npm; then
        sudo npm install -g tldr
    else
        pip3 install --user tldr
        add_to_path "$HOME/.local/bin"
    fi

    verify_installation tldr
}
