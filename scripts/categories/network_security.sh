#!/usr/bin/env bash

###############################################################################
# Network & Security Tools Installation
###############################################################################

install_network_security() {
    log_info "Installing Network & Security tools..."

    # Check if we should do interactive tool selection
    if [[ "${INTERACTIVE_TOOLS:-false}" == "true" ]]; then
        select_network_security_tools
    else
        # Install all tools in category
        install_all_network_security_tools
    fi

    log_success "Network & Security tools installation complete"
}

select_network_security_tools() {
    echo ""
    echo -e "${BLUE}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║     Select Individual Network/Security Tools to Install   ║${NC}"
    echo -e "${BLUE}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""

    local tools=(
        "nmap:nmap:install_nmap"
        "trivy:trivy:install_trivy"
        "cosign:cosign:install_cosign"
        "openssl:openssl:install_openssl"
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

install_all_network_security_tools() {
    # nmap
    if ! is_installed nmap; then
        install_nmap
    fi

    # trivy (container security scanner)
    if ! is_installed trivy; then
        install_trivy
    fi

    # cosign (container signing)
    if ! is_installed cosign; then
        install_cosign
    fi

    # openssl (usually pre-installed)
    if ! is_installed openssl; then
        install_openssl
    fi
}

install_nmap() {
    log_info "Installing nmap..."
    install_package nmap
    verify_installation nmap
}

install_trivy() {
    log_info "Installing trivy..."
    
    case "$OS_FAMILY" in
        debian)
            # Add Aqua Security repository
            sudo apt-get install -y wget apt-transport-https gnupg lsb-release
            wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
            echo "deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee -a /etc/apt/sources.list.d/trivy.list
            sudo apt-get update
            install_package trivy
            ;;
        redhat)
            cat > /tmp/trivy.repo <<EOF
[trivy]
name=Trivy repository
baseurl=https://aquasecurity.github.io/trivy-repo/rpm/releases/\$basearch/
gpgcheck=0
enabled=1
EOF
            sudo mv /tmp/trivy.repo /etc/yum.repos.d/trivy.repo
            sudo $PKG_MANAGER install -y trivy
            ;;
        *)
            # Manual installation
            local version=$(get_latest_github_release "aquasecurity/trivy")
            local arch=$(get_arch)
            local os=$(get_os_type)
            
            curl -fsSL "https://github.com/aquasecurity/trivy/releases/download/${version}/trivy_${version#v}_${os}-${arch}.tar.gz" -o /tmp/trivy.tar.gz
            
            tar -xzf /tmp/trivy.tar.gz -C /tmp
            sudo install -m 755 /tmp/trivy /usr/local/bin/trivy
            rm /tmp/trivy.tar.gz /tmp/trivy
            ;;
    esac
    
    verify_installation trivy
}

install_cosign() {
    log_info "Installing cosign..."
    
    local version=$(get_latest_github_release "sigstore/cosign")
    local arch=$(get_arch)
    local os=$(get_os_type)
    
    curl -fsSL "https://github.com/sigstore/cosign/releases/download/${version}/cosign-${os}-${arch}" -o /tmp/cosign
    
    sudo install -m 755 /tmp/cosign /usr/local/bin/cosign
    rm /tmp/cosign
    
    verify_installation cosign
}

install_openssl() {
    log_info "Installing openssl..."
    install_package openssl
    verify_installation openssl
}
