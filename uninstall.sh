#!/usr/bin/env bash

###############################################################################
# DevOps Workspace Uninstaller
# Remove installed tools and configurations
###############################################################################

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_LOG="${HOME}/.devops-workspace-install.log"

print_banner() {
    echo -e "${RED}"
    cat << "EOF"
╔═══════════════════════════════════════════════════════════╗
║                                                           ║
║        DevOps Workspace Uninstaller                      ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

log_info() {
    echo -e "${BLUE}[INFO]${NC} $*"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $*"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $*"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $*" >&2
}

confirm_uninstall() {
    echo ""
    log_warning "This will remove DevOps Workspace tools and configurations."
    echo ""
    read -p "Are you sure you want to continue? [y/N] " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Uninstall cancelled."
        exit 0
    fi
}

remove_binaries() {
    log_info "Removing installed binaries from /usr/local/bin..."
    
    local binaries=(
        "kubectl" "k9s" "helm" "kind"
        "terraform" "tofu" "packer"
        "argocd" "stern" "ctop"
        "yq" "cosign" "trivy"
    )
    
    for binary in "${binaries[@]}"; do
        if [[ -f "/usr/local/bin/$binary" ]]; then
            sudo rm -f "/usr/local/bin/$binary"
            log_success "Removed $binary"
        fi
    done
}

remove_configs() {
    log_info "Removing configuration files..."
    
    # Backup before removal
    local backup_dir="$HOME/.devops-workspace-backup-$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$backup_dir"
    
    # Backup and remove .tmux.conf
    if [[ -f "$HOME/.tmux.conf" ]]; then
        cp "$HOME/.tmux.conf" "$backup_dir/"
        rm "$HOME/.tmux.conf"
        log_success "Removed .tmux.conf (backed up to $backup_dir)"
    fi
    
    # Backup and remove .vimrc if it's ours
    if [[ -f "$HOME/.vimrc" ]] && grep -q "DevOps Workspace" "$HOME/.vimrc" 2>/dev/null; then
        cp "$HOME/.vimrc" "$backup_dir/"
        rm "$HOME/.vimrc"
        log_success "Removed .vimrc (backed up to $backup_dir)"
    fi
    
    log_info "Configuration backups saved to: $backup_dir"
}

remove_shell_modifications() {
    log_info "Removing shell modifications..."
    
    for rc_file in "$HOME/.bashrc" "$HOME/.zshrc"; do
        if [[ -f "$rc_file" ]]; then
            # Create backup
            cp "$rc_file" "${rc_file}.backup-$(date +%Y%m%d_%H%M%S)"
            
            # Remove our additions
            sed -i '/# DevOps Workspace Aliases/d' "$rc_file"
            sed -i '\|devops-workspace.*aliases\.sh|d' "$rc_file"
            
            log_success "Cleaned $(basename $rc_file)"
        fi
    done
}

remove_optional_tools() {
    log_info "The following tools were installed via package managers:"
    log_warning "Docker, Ansible, Node.js, Python packages, etc."
    echo ""
    read -p "Do you want to remove these as well? [y/N] " -n 1 -r
    echo ""
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        log_info "Removing package-managed tools..."
        
        # This is distribution-specific
        if command -v apt-get &> /dev/null; then
            sudo apt-get remove -y docker-ce docker-ce-cli containerd.io || true
            sudo apt-get remove -y ansible || true
            sudo apt-get autoremove -y
        elif command -v dnf &> /dev/null; then
            sudo dnf remove -y docker-ce ansible || true
        elif command -v yum &> /dev/null; then
            sudo yum remove -y docker-ce ansible || true
        fi
        
        log_success "Removed package-managed tools"
    else
        log_info "Keeping package-managed tools"
    fi
}

cleanup_install_log() {
    if [[ -f "$INSTALL_LOG" ]]; then
        mv "$INSTALL_LOG" "${INSTALL_LOG}.removed-$(date +%Y%m%d_%H%M%S)"
        log_success "Moved installation log to backup"
    fi
}

main() {
    print_banner
    
    confirm_uninstall
    
    remove_binaries
    remove_configs
    remove_shell_modifications
    remove_optional_tools
    cleanup_install_log
    
    echo ""
    echo -e "${GREEN}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                                                           ║${NC}"
    echo -e "${GREEN}║  Uninstallation Complete! 👋                              ║${NC}"
    echo -e "${GREEN}║                                                           ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    log_info "Backups have been saved in your home directory"
    log_info "Please restart your shell: exec \$SHELL"
    echo ""
}

main "$@"
