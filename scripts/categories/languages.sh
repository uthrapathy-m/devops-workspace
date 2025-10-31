#!/usr/bin/env bash

###############################################################################
# Programming Languages & Runtimes Installation
###############################################################################

install_languages() {
    log_info "Installing Programming Languages & Runtimes..."
    
    # Python 3
    if ! is_installed python3; then
        install_python3
    fi
    
    # Node.js
    if ! is_installed node; then
        install_nodejs
    fi
    
    # Go
    if ! is_installed go; then
        install_golang
    fi
    
    log_success "Languages & Runtimes installation complete"
}

install_python3() {
    log_info "Installing Python 3..."
    
    case "$OS_FAMILY" in
        debian)
            install_package python3
            install_package python3-pip
            install_package python3-venv
            ;;
        redhat)
            install_package python3
            install_package python3-pip
            ;;
        arch)
            install_package python
            install_package python-pip
            ;;
    esac
    
    verify_installation python3
    verify_installation pip3
}

install_nodejs() {
    log_info "Installing Node.js LTS..."
    
    case "$OS_FAMILY" in
        debian)
            # Install NodeSource repository for latest LTS
            curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
            install_package nodejs
            ;;
        redhat)
            # Install NodeSource repository for latest LTS
            curl -fsSL https://rpm.nodesource.com/setup_lts.x | sudo bash -
            install_package nodejs
            ;;
        arch)
            install_package nodejs
            install_package npm
            ;;
    esac
    
    verify_installation node
    verify_installation npm
}

install_golang() {
    log_info "Installing Go..."
    
    local temp_dir=$(create_temp_dir)
    cd "$temp_dir"
    
    # Get latest stable version
    local version=$(curl -fsSL 'https://go.dev/VERSION?m=text' | head -n1)
    local arch=$(get_arch)
    
    curl -fsSL "https://go.dev/dl/${version}.linux-${arch}.tar.gz" -o go.tar.gz
    
    # Remove existing Go installation
    sudo rm -rf /usr/local/go
    
    # Extract new version
    sudo tar -C /usr/local -xzf go.tar.gz
    
    cleanup_temp_dir "$temp_dir"
    
    # Add to PATH
    add_to_path "/usr/local/go/bin"
    
    # Also add GOPATH/bin
    add_to_path "$HOME/go/bin"
    
    export PATH="/usr/local/go/bin:$PATH"
    verify_installation go
}
