#!/usr/bin/env bash

###############################################################################
# Monitoring & Observability Tools Installation
###############################################################################

install_monitoring() {
    log_info "Installing Monitoring & Observability tools..."
    
    # stern (kubectl logs viewer)
    if ! is_installed stern; then
        install_stern
    fi
    
    # ctop (container metrics)
    if ! is_installed ctop; then
        install_ctop
    fi
    
    # htop (system monitor)
    if ! is_installed htop; then
        install_htop
    fi
    
    # btop (better htop)
    if ! is_installed btop; then
        install_btop
    fi
    
    log_success "Monitoring tools installation complete"
}

install_stern() {
    log_info "Installing stern..."
    
    install_from_github_release "stern/stern" "stern" "stern_{version}_{os}_{arch}.tar.gz"
}

install_ctop() {
    log_info "Installing ctop..."
    
    local arch=$(get_arch)
    local os=$(get_os_type)
    
    curl -fsSL "https://github.com/bcicen/ctop/releases/download/v0.7.7/ctop-0.7.7-${os}-${arch}" -o /tmp/ctop
    
    sudo install -m 755 /tmp/ctop /usr/local/bin/ctop
    rm /tmp/ctop
    
    verify_installation ctop
}

install_htop() {
    log_info "Installing htop..."
    
    install_package htop
    verify_installation htop
}

install_btop() {
    log_info "Installing btop..."
    
    case "$OS_FAMILY" in
        debian)
            sudo apt-get update
            sudo apt-get install -y btop
            ;;
        redhat)
            sudo $PKG_MANAGER install -y btop
            ;;
        arch)
            sudo pacman -S --noconfirm btop
            ;;
        *)
            log_warning "btop not available in package manager, skipping..."
            return
            ;;
    esac
    
    verify_installation btop
}
