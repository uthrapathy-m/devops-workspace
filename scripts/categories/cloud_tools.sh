#!/usr/bin/env bash

###############################################################################
# Cloud CLI Tools Installation
###############################################################################

install_cloud_tools() {
    log_info "Installing Cloud CLI tools..."
    
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
    
    log_success "Cloud CLI tools installation complete"
}

install_aws_cli() {
    log_info "Installing AWS CLI v2..."
    
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
    
    local temp_dir=$(create_temp_dir)
    cd "$temp_dir"
    
    # Get latest version
    local version=$(curl -fsSL https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r .current_version)
    local arch=$(get_arch)
    local os=$(get_os_type)
    
    local url="https://releases.hashicorp.com/terraform/${version}/terraform_${version}_${os}_${arch}.zip"
    
    curl -fsSL "$url" -o terraform.zip
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
