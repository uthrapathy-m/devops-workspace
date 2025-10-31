#!/usr/bin/env bash

###############################################################################
# Network & Security Tools Installation
###############################################################################

install_network_security() {
    log_info "Installing Network & Security tools..."
    
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
    
    log_success "Network & Security tools installation complete"
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
