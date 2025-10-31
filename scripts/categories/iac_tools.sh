#!/usr/bin/env bash

###############################################################################
# Infrastructure as Code Tools Installation
###############################################################################

install_iac_tools() {
    log_info "Installing Infrastructure as Code tools..."
    
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
    
    log_success "IaC tools installation complete"
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
    
    local temp_dir=$(create_temp_dir)
    cd "$temp_dir"
    
    # Get latest version from HashiCorp
    local version=$(curl -fsSL https://checkpoint-api.hashicorp.com/v1/check/packer | jq -r .current_version)
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
    
    case "$OS_FAMILY" in
        debian)
            local temp_dir=$(create_temp_dir)
            cd "$temp_dir"
            
            # Get latest version
            local version=$(curl -fsSL https://checkpoint-api.hashicorp.com/v1/check/vagrant | jq -r .current_version)
            local arch=$(dpkg --print-architecture)
            
            curl -fsSL "https://releases.hashicorp.com/vagrant/${version}/vagrant_${version}-1_${arch}.deb" -o vagrant.deb
            sudo dpkg -i vagrant.deb
            
            cleanup_temp_dir "$temp_dir"
            ;;
        redhat)
            local version=$(curl -fsSL https://checkpoint-api.hashicorp.com/v1/check/vagrant | jq -r .current_version)
            sudo $PKG_MANAGER install -y "https://releases.hashicorp.com/vagrant/${version}/vagrant_${version}-1_$(uname -m).rpm"
            ;;
        arch)
            sudo pacman -S --noconfirm vagrant
            ;;
    esac
    
    verify_installation vagrant
}
