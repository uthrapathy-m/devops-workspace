#!/usr/bin/env bash

###############################################################################
# Infrastructure as Code Tools Installation
###############################################################################

install_iac_tools() {
    log_info "Installing Infrastructure as Code tools..."

    # Check if we should do interactive tool selection
    if [[ "${INTERACTIVE_TOOLS:-false}" == "true" ]]; then
        select_iac_tools
    else
        # Install all tools in category
        install_all_iac_tools
    fi

    log_success "IaC tools installation complete"
}

select_iac_tools() {
    echo ""
    echo -e "${BLUE}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║     Select Individual IaC Tools to Install                ║${NC}"
    echo -e "${BLUE}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""

    local tools=(
        "Ansible:ansible:install_ansible"
        "Packer:packer:install_packer"
        "Vagrant:vagrant:install_vagrant"
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

install_all_iac_tools() {
    # Ansible
    if ! is_installed ansible; then
        install_ansible
    fi

    # Packer
    if ! is_installed packer; then
        install_packer
    fi

    # Vagrant
    if ! is_installed vagrant; then
        install_vagrant
    fi
}

install_ansible() {
    log_info "Installing Ansible..."
    
    case "$OS_FAMILY" in
        debian)
            sudo apt-get update
            sudo apt-get install -y software-properties-common
            sudo add-apt-repository --yes --update ppa:ansible/ansible
            sudo apt-get install -y ansible
            ;;
        redhat)
            sudo $PKG_MANAGER install -y ansible
            ;;
        arch)
            sudo pacman -S --noconfirm ansible
            ;;
        *)
            # Use pip as fallback
            log_info "Installing Ansible via pip..."
            pip3 install --user ansible
            add_to_path "$HOME/.local/bin"
            ;;
    esac
    
    verify_installation ansible
}

install_packer() {
    log_info "Installing Packer..."

    # Ensure required dependencies are available
    ensure_dependency unzip
    ensure_dependency jq

    local temp_dir=$(create_temp_dir)
    cd "$temp_dir"

    # Get latest version from HashiCorp
    local version=$(curl -fsSL https://checkpoint-api.hashicorp.com/v1/check/packer | jq -r .current_version)

    if [[ -z "$version" || "$version" == "null" ]]; then
        log_error "Failed to fetch Packer version. Using fallback version 1.10.0"
        version="1.10.0"
    fi

    local arch=$(get_arch)
    local os=$(get_os_type)

    local url="https://releases.hashicorp.com/packer/${version}/packer_${version}_${os}_${arch}.zip"

    curl -fsSL "$url" -o packer.zip
    unzip -q packer.zip

    install_binary packer

    cleanup_temp_dir "$temp_dir"
    verify_installation packer
}

install_vagrant() {
    log_info "Installing Vagrant..."

    # Ensure jq is available
    ensure_dependency jq

    case "$OS_FAMILY" in
        debian)
            local temp_dir=$(create_temp_dir)
            cd "$temp_dir"

            # Get latest version
            local version=$(curl -fsSL https://checkpoint-api.hashicorp.com/v1/check/vagrant | jq -r .current_version)

            if [[ -z "$version" || "$version" == "null" ]]; then
                log_error "Failed to fetch Vagrant version. Using fallback version 2.4.0"
                version="2.4.0"
            fi

            local arch=$(dpkg --print-architecture)

            curl -fsSL "https://releases.hashicorp.com/vagrant/${version}/vagrant_${version}-1_${arch}.deb" -o vagrant.deb
            sudo dpkg -i vagrant.deb

            cleanup_temp_dir "$temp_dir"
            ;;
        redhat)
            local version=$(curl -fsSL https://checkpoint-api.hashicorp.com/v1/check/vagrant | jq -r .current_version)

            if [[ -z "$version" || "$version" == "null" ]]; then
                log_error "Failed to fetch Vagrant version. Using fallback version 2.4.0"
                version="2.4.0"
            fi

            sudo $PKG_MANAGER install -y "https://releases.hashicorp.com/vagrant/${version}/vagrant_${version}-1_$(uname -m).rpm"
            ;;
        arch)
            sudo pacman -S --noconfirm vagrant
            ;;
    esac

    verify_installation vagrant
}
