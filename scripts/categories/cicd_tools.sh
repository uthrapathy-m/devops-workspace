#!/usr/bin/env bash

###############################################################################
# CI/CD Tools Installation
###############################################################################

install_cicd_tools() {
    log_info "Installing CI/CD tools..."
    
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
    
    log_success "CI/CD tools installation complete"
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
    
    case "$OS_FAMILY" in
        debian)
            # Add GitLab CLI repository
            curl -fsSL https://gitlab.com/gitlab-org/cli/-/releases/permalink/latest/downloads/glab_$(dpkg --print-architecture).deb -o /tmp/glab.deb
            sudo dpkg -i /tmp/glab.deb
            rm /tmp/glab.deb
            ;;
        redhat)
            local version=$(get_latest_github_release "gitlab-org/cli")
            curl -fsSL "https://gitlab.com/gitlab-org/cli/-/releases/${version}/downloads/glab_$(uname -m).rpm" -o /tmp/glab.rpm
            sudo $PKG_MANAGER install -y /tmp/glab.rpm
            rm /tmp/glab.rpm
            ;;
        *)
            # Manual installation
            local version=$(get_latest_github_release "gitlab-org/cli")
            local arch=$(get_arch)
            local os=$(get_os_type)
            
            curl -fsSL "https://gitlab.com/gitlab-org/cli/-/releases/${version}/downloads/glab_${version#v}_${os}_${arch}.tar.gz" -o /tmp/glab.tar.gz
            
            tar -xzf /tmp/glab.tar.gz -C /tmp
            sudo install -m 755 /tmp/bin/glab /usr/local/bin/glab
            rm -rf /tmp/glab.tar.gz /tmp/bin
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
