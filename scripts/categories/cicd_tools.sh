#!/usr/bin/env bash

###############################################################################
# CI/CD Tools Installation
###############################################################################

install_cicd_tools() {
    log_info "Installing CI/CD tools..."

    # Check if we should do interactive tool selection
    if [[ "${INTERACTIVE_TOOLS:-false}" == "true" ]]; then
        select_cicd_tools
    else
        # Install all tools in category
        install_all_cicd_tools
    fi

    log_success "CI/CD tools installation complete"
}

select_cicd_tools() {
    echo ""
    echo -e "${BLUE}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║     Select Individual CI/CD Tools to Install              ║${NC}"
    echo -e "${BLUE}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""

    local tools=(
        "GitHub CLI:gh:install_github_cli"
        "GitLab CLI:glab:install_gitlab_cli"
        "ArgoCD CLI:argocd:install_argocd_cli"
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

install_all_cicd_tools() {
    # GitHub CLI
    if ! is_installed gh; then
        install_github_cli
    fi

    # GitLab CLI
    if ! is_installed glab; then
        install_gitlab_cli
    fi

    # ArgoCD CLI
    if ! is_installed argocd; then
        install_argocd_cli
    fi
}

install_github_cli() {
    log_info "Installing GitHub CLI..."
    
    case "$OS_FAMILY" in
        debian)
            # Add GitHub CLI repository
            curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
            sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
            
            sudo apt-get update
            sudo apt-get install -y gh
            ;;
        redhat)
            sudo $PKG_MANAGER install -y 'dnf-command(config-manager)'
            sudo $PKG_MANAGER config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
            sudo $PKG_MANAGER install -y gh
            ;;
        arch)
            sudo pacman -S --noconfirm github-cli
            ;;
        *)
            # Manual installation
            install_from_github_release "cli/cli" "gh" "gh_{version}_{os}_{arch}.tar.gz"
            ;;
    esac
    
    verify_installation gh
}

install_gitlab_cli() {
    log_info "Installing GitLab CLI..."

    local version=$(get_latest_github_release "gitlab-org/cli")
    if [[ -z "$version" ]]; then
        log_error "Failed to get GitLab CLI version"
        return 1
    fi

    local arch=$(get_arch)
    local os=$(get_os_type)

    # Map architecture for GitLab CLI
    case "$arch" in
        amd64) arch="amd64" ;;
        arm64) arch="arm64" ;;
        *)
            log_error "Unsupported architecture: $arch"
            return 1
            ;;
    esac

    case "$OS_FAMILY" in
        debian)
            # Use GitHub releases for Debian
            local deb_url="https://github.com/gitlab-org/cli/releases/download/${version}/glab_${version#v}_${os}_${arch}.deb"
            log_info "Downloading from: $deb_url"

            curl -fsSL "$deb_url" -o /tmp/glab.deb
            if [[ ! -f /tmp/glab.deb || ! -s /tmp/glab.deb ]]; then
                log_error "Failed to download GitLab CLI"
                return 1
            fi
            sudo dpkg -i /tmp/glab.deb
            rm /tmp/glab.deb
            ;;
        redhat)
            local rpm_url="https://github.com/gitlab-org/cli/releases/download/${version}/glab_${version#v}_${os}_${arch}.rpm"
            log_info "Downloading from: $rpm_url"

            curl -fsSL "$rpm_url" -o /tmp/glab.rpm
            if [[ ! -f /tmp/glab.rpm || ! -s /tmp/glab.rpm ]]; then
                log_error "Failed to download GitLab CLI"
                return 1
            fi
            sudo $PKG_MANAGER install -y /tmp/glab.rpm
            rm /tmp/glab.rpm
            ;;
        *)
            # Manual installation from tar.gz
            local tar_url="https://github.com/gitlab-org/cli/releases/download/${version}/glab_${version#v}_${os}_${arch}.tar.gz"
            log_info "Downloading from: $tar_url"

            curl -fsSL "$tar_url" -o /tmp/glab.tar.gz
            if [[ ! -f /tmp/glab.tar.gz || ! -s /tmp/glab.tar.gz ]]; then
                log_error "Failed to download GitLab CLI"
                return 1
            fi

            local temp_dir=$(create_temp_dir)
            tar -xzf /tmp/glab.tar.gz -C "$temp_dir"

            # Find the glab binary
            local glab_bin=$(find "$temp_dir" -name "glab" -type f | head -n1)
            if [[ -z "$glab_bin" ]]; then
                log_error "glab binary not found in archive"
                cleanup_temp_dir "$temp_dir"
                rm /tmp/glab.tar.gz
                return 1
            fi

            sudo install -m 755 "$glab_bin" /usr/local/bin/glab
            cleanup_temp_dir "$temp_dir"
            rm /tmp/glab.tar.gz
            ;;
    esac

    verify_installation glab
}

install_argocd_cli() {
    log_info "Installing ArgoCD CLI..."
    
    local version=$(get_latest_github_release "argoproj/argo-cd")
    local arch=$(get_arch)
    local os=$(get_os_type)
    
    curl -fsSL "https://github.com/argoproj/argo-cd/releases/download/${version}/argocd-${os}-${arch}" -o /tmp/argocd
    
    sudo install -m 755 /tmp/argocd /usr/local/bin/argocd
    rm /tmp/argocd
    
    verify_installation argocd
}
