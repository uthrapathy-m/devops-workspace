#!/usr/bin/env bash

###############################################################################
# Cloud CLI Tools Installation
###############################################################################

install_cloud_tools() {
    log_info "Installing Cloud CLI tools..."

    # Check if we should do interactive tool selection
    if [[ "${INTERACTIVE_TOOLS:-false}" == "true" ]]; then
        select_cloud_tools
    else
        # Install all tools in category
        install_all_cloud_tools
    fi

    log_success "Cloud CLI tools installation complete"
}

select_cloud_tools() {
    echo ""
    echo -e "${BLUE}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║     Select Individual Cloud Tools to Install              ║${NC}"
    echo -e "${BLUE}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""

    local tools=(
        "AWS CLI:aws:install_aws_cli"
        "Azure CLI:az:install_azure_cli"
        "Google Cloud SDK:gcloud:install_gcloud"
        "Terraform:terraform:install_terraform"
        "Pulumi:pulumi:install_pulumi"
        "OpenTofu:tofu:install_opentofu"
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

install_all_cloud_tools() {
    # AWS CLI
    if ! is_installed aws; then
        install_aws_cli
    fi

    # Azure CLI
    if ! is_installed az; then
        install_azure_cli
    fi

    # Google Cloud SDK
    if ! is_installed gcloud; then
        install_gcloud
    fi

    # Terraform
    if ! is_installed terraform; then
        install_terraform
    fi

    # Pulumi
    if ! is_installed pulumi; then
        install_pulumi
    fi

    # OpenTofu
    if ! is_installed tofu; then
        install_opentofu
    fi
}

install_aws_cli() {
    log_info "Installing AWS CLI v2..."

    # Ensure unzip is available
    ensure_dependency unzip

    local temp_dir=$(create_temp_dir)
    cd "$temp_dir"

    local arch=$(uname -m)

    if [[ "$arch" == "x86_64" ]]; then
        curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    elif [[ "$arch" == "aarch64" ]]; then
        curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"
    else
        log_error "Unsupported architecture for AWS CLI: $arch"
        cleanup_temp_dir "$temp_dir"
        return 1
    fi

    unzip -q awscliv2.zip
    sudo ./aws/install --update

    cleanup_temp_dir "$temp_dir"
    verify_installation aws
}

install_azure_cli() {
    log_info "Installing Azure CLI..."
    
    case "$OS_FAMILY" in
        debian)
            # Install prerequisites
            sudo apt-get update
            sudo apt-get install -y ca-certificates curl apt-transport-https lsb-release gnupg
            
            # Download and install Microsoft signing key
            curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/microsoft.gpg
            
            # Add Azure CLI repository
            AZ_REPO=$(lsb_release -cs)
            echo "deb [arch=$(dpkg --print-architecture)] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | sudo tee /etc/apt/sources.list.d/azure-cli.list
            
            # Install
            sudo apt-get update
            sudo apt-get install -y azure-cli
            ;;
        redhat)
            sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
            
            cat > /tmp/azure-cli.repo <<EOF
[azure-cli]
name=Azure CLI
baseurl=https://packages.microsoft.com/yumrepos/azure-cli
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF
            sudo mv /tmp/azure-cli.repo /etc/yum.repos.d/azure-cli.repo
            
            sudo $PKG_MANAGER install -y azure-cli
            ;;
        *)
            log_warning "Azure CLI automated install not supported on $OS_FAMILY. Using pip..."
            pip3 install --user azure-cli
            ;;
    esac
    
    verify_installation az
}

install_gcloud() {
    log_info "Installing Google Cloud SDK..."
    
    local temp_dir=$(create_temp_dir)
    cd "$temp_dir"
    
    local arch=$(uname -m)
    local os=$(get_os_type)
    
    if [[ "$arch" == "x86_64" ]]; then
        arch="x86_64"
    elif [[ "$arch" == "aarch64" ]]; then
        arch="arm"
    fi
    
    curl -fsSL "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-linux-${arch}.tar.gz" -o gcloud.tar.gz
    
    tar -xzf gcloud.tar.gz
    ./google-cloud-sdk/install.sh --quiet --usage-reporting false --path-update true --command-completion true
    
    # Add to PATH
    local install_path="$HOME/google-cloud-sdk"
    add_to_path "$install_path/bin"
    
    cleanup_temp_dir "$temp_dir"
    
    log_success "Google Cloud SDK installed. Run 'gcloud init' to configure."
}

install_terraform() {
    log_info "Installing Terraform..."

    # Ensure required dependencies are available
    ensure_dependency unzip
    ensure_dependency jq

    local temp_dir=$(create_temp_dir)
    cd "$temp_dir"

    # Get latest version
    local version=$(curl -fsSL https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r .current_version)

    if [[ -z "$version" || "$version" == "null" ]]; then
        log_error "Failed to fetch Terraform version. Using fallback version 1.6.0"
        version="1.6.0"
    fi

    local arch=$(get_arch)
    local os=$(get_os_type)

    local url="https://releases.hashicorp.com/terraform/${version}/terraform_${version}_${os}_${arch}.zip"

    log_info "Downloading Terraform from: $url"
    curl -fsSL "$url" -o terraform.zip

    if [[ ! -f terraform.zip || ! -s terraform.zip ]]; then
        log_error "Failed to download Terraform"
        cleanup_temp_dir "$temp_dir"
        return 1
    fi

    unzip -q terraform.zip

    install_binary terraform

    cleanup_temp_dir "$temp_dir"
    verify_installation terraform
}

install_pulumi() {
    log_info "Installing Pulumi..."
    
    curl -fsSL https://get.pulumi.com | sh
    
    # Add to PATH
    add_to_path "$HOME/.pulumi/bin"
    
    export PATH="$HOME/.pulumi/bin:$PATH"
    verify_installation pulumi
}

install_opentofu() {
    log_info "Installing OpenTofu..."

    local temp_dir=$(create_temp_dir)
    cd "$temp_dir"

    # Install from package manager if available
    case "$OS_FAMILY" in
        debian)
            # Add OpenTofu repository
            curl -fsSL https://get.opentofu.org/opentofu.gpg | sudo tee /etc/apt/trusted.gpg.d/opentofu.gpg > /dev/null
            curl -fsSL https://packages.opentofu.org/opentofu/tofu/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/opentofu-repo-archive-keyring.gpg
            echo "deb [signed-by=/usr/share/keyrings/opentofu-repo-archive-keyring.gpg] https://packages.opentofu.org/opentofu/tofu/any/ any main" | sudo tee /etc/apt/sources.list.d/opentofu.list > /dev/null

            sudo apt-get update
            sudo apt-get install -y tofu
            ;;
        *)
            # Ensure unzip is available for manual installation
            ensure_dependency unzip

            # Manual installation
            local version=$(get_latest_github_release "opentofu/opentofu")
            local arch=$(get_arch)
            local os=$(get_os_type)

            local url="https://github.com/opentofu/opentofu/releases/download/${version}/tofu_${version#v}_${os}_${arch}.zip"

            curl -fsSL "$url" -o tofu.zip
            unzip -q tofu.zip
            install_binary tofu
            ;;
    esac

    cleanup_temp_dir "$temp_dir"
    verify_installation tofu
}
