#!/usr/bin/env bash

###############################################################################
# Container & Orchestration Tools Installation
###############################################################################

install_containers() {
    log_info "Installing Container & Orchestration tools..."

    # Check if we should do interactive tool selection
    if [[ "${INTERACTIVE_TOOLS:-false}" == "true" ]]; then
        select_container_tools
    else
        # Install all tools in category
        install_all_container_tools
    fi

    log_success "Container & Orchestration tools installation complete"
}

select_container_tools() {
    echo ""
    echo -e "${BLUE}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║     Select Individual Container Tools to Install          ║${NC}"
    echo -e "${BLUE}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""

    local tools=(
        "Docker:docker:install_docker"
        "Docker Compose:docker-compose:install_docker_compose"
        "Podman:podman:install_podman"
        "kubectl:kubectl:install_kubectl"
        "k9s:k9s:install_k9s"
        "Helm:helm:install_helm"
        "kind:kind:install_kind"
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

install_all_container_tools() {
    # Docker
    if ! is_installed docker; then
        install_docker
    fi

    # Docker Compose
    if ! is_installed docker-compose; then
        install_docker_compose
    fi

    # Podman
    if ! is_installed podman; then
        install_podman
    fi

    # kubectl
    if ! is_installed kubectl; then
        install_kubectl
    fi

    # k9s
    if ! is_installed k9s; then
        install_k9s
    fi

    # Helm
    if ! is_installed helm; then
        install_helm
    fi

    # kind
    if ! is_installed kind; then
        install_kind
    fi
}

install_docker() {
    log_info "Installing Docker..."
    
    case "$OS_FAMILY" in
        debian)
            # Install prerequisites
            sudo apt-get update
            sudo apt-get install -y ca-certificates curl gnupg lsb-release
            
            # Add Docker's official GPG key
            sudo mkdir -p /etc/apt/keyrings
            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
            
            # Set up repository
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
            
            # Install Docker
            sudo apt-get update
            sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
            ;;
        redhat)
            sudo $PKG_MANAGER install -y yum-utils
            sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
            sudo $PKG_MANAGER install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
            ;;
        arch)
            sudo pacman -S --noconfirm docker docker-compose
            ;;
    esac
    
    # Start and enable Docker
    sudo systemctl start docker
    sudo systemctl enable docker
    
    # Add current user to docker group
    sudo usermod -aG docker $USER
    
    verify_installation docker
    log_warning "You may need to log out and back in for docker group changes to take effect"
}

install_docker_compose() {
    log_info "Installing Docker Compose standalone..."
    
    local version=$(get_latest_github_release "docker/compose")
    local arch=$(get_arch)
    local os=$(get_os_type)
    
    local url="https://github.com/docker/compose/releases/download/${version}/docker-compose-${os}-$(uname -m)"
    
    sudo curl -fsSL "$url" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    
    verify_installation docker-compose
}

install_podman() {
    log_info "Installing Podman..."
    
    case "$OS_FAMILY" in
        debian)
            sudo apt-get update
            sudo apt-get install -y podman
            ;;
        redhat)
            sudo $PKG_MANAGER install -y podman
            ;;
        arch)
            sudo pacman -S --noconfirm podman
            ;;
    esac
    
    verify_installation podman
}

install_kubectl() {
    log_info "Installing kubectl..."
    
    local arch=$(get_arch)
    local os=$(get_os_type)
    
    # Download latest kubectl
    curl -fsSL "https://dl.k8s.io/release/$(curl -fsSL https://dl.k8s.io/release/stable.txt)/bin/${os}/${arch}/kubectl" -o /tmp/kubectl
    
    # Install
    sudo install -o root -g root -m 0755 /tmp/kubectl /usr/local/bin/kubectl
    rm /tmp/kubectl
    
    verify_installation kubectl
}

install_k9s() {
    log_info "Installing k9s..."
    
    install_from_github_release "derailed/k9s" "k9s" "k9s_{os}_{arch}.tar.gz"
}

install_helm() {
    log_info "Installing Helm..."
    
    local temp_dir=$(create_temp_dir)
    cd "$temp_dir"
    
    curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
    
    cleanup_temp_dir "$temp_dir"
    verify_installation helm
}

install_kind() {
    log_info "Installing kind..."
    
    local arch=$(get_arch)
    local os=$(get_os_type)
    
    # Download kind
    curl -fsSL "https://kind.sigs.k8s.io/dl/latest/kind-${os}-${arch}" -o /tmp/kind
    
    # Install
    sudo install -o root -g root -m 0755 /tmp/kind /usr/local/bin/kind
    rm /tmp/kind
    
    verify_installation kind
}
