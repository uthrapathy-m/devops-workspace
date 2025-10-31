# Customization Guide

How to customize DevOps Workspace for your needs.

## Table of Contents

1. [Adding Custom Aliases](#adding-custom-aliases)
2. [Modifying Existing Aliases](#modifying-existing-aliases)
3. [Adding New Tools](#adding-new-tools)
4. [Customizing Shell Configuration](#customizing-shell-configuration)
5. [Customizing tmux](#customizing-tmux)
6. [Customizing vim/neovim](#customizing-vimneovim)
7. [Creating Custom Categories](#creating-custom-categories)

---

## Adding Custom Aliases

### Personal Aliases File

Create your own aliases file that won't be overwritten:

```bash
# Create personal aliases file
cat > ~/.devops-aliases-personal.sh << 'EOF'
#!/usr/bin/env bash

# My custom DevOps aliases
alias myalias='command'
alias k8s-prod='kubectl --context=production'
alias deploy-staging='./scripts/deploy.sh staging'
EOF

# Source it in your shell rc
echo 'source ~/.devops-aliases-personal.sh' >> ~/.bashrc
source ~/.bashrc
```

### Project-Specific Aliases

For specific projects:

```bash
# Create .aliases file in project directory
cat > ~/my-project/.aliases << 'EOF'
alias dev='docker-compose -f docker-compose.dev.yml'
alias prod='docker-compose -f docker-compose.prod.yml'
alias logs-api='docker-compose logs -f api'
EOF

# Source when entering project
cd ~/my-project && source .aliases
```

---

## Modifying Existing Aliases

### Override Default Aliases

Edit your personal aliases file to override defaults:

```bash
# In ~/.bashrc or ~/.zshrc, AFTER sourcing default aliases:
source ~/devops-workspace/config/aliases.sh

# Override specific aliases
alias k='kubectl --namespace=my-namespace'  # Override default
alias tf='terraform fmt && terraform'        # Extend default
```

### Edit Core Aliases

Directly modify the main aliases file:

```bash
# Edit aliases
vim ~/devops-workspace/config/aliases.sh

# Reload
source ~/.bashrc
```

---

## Adding New Tools

### Method 1: Create Custom Installation Script

```bash
# Create new category script
cat > ~/devops-workspace/scripts/categories/my_tools.sh << 'EOF'
#!/usr/bin/env bash

install_my_tools() {
    log_info "Installing my custom tools..."
    
    # Example: Install custom tool
    if ! is_installed mytool; then
        install_mytool
    fi
    
    log_success "My tools installation complete"
}

install_mytool() {
    log_info "Installing mytool..."
    
    local version="v1.0.0"
    local arch=$(get_arch)
    local os=$(get_os_type)
    
    curl -fsSL "https://example.com/mytool-${os}-${arch}" -o /tmp/mytool
    sudo install -m 755 /tmp/mytool /usr/local/bin/mytool
    rm /tmp/mytool
    
    verify_installation mytool
}
EOF

# Make executable
chmod +x ~/devops-workspace/scripts/categories/my_tools.sh

# Install your tools
cd ~/devops-workspace
./install.sh --category my_tools
```

### Method 2: Manual Installation

```bash
# Install tool manually
curl -fsSL https://example.com/tool -o /tmp/tool
sudo install -m 755 /tmp/tool /usr/local/bin/tool

# Add to install log
echo "tool" >> ~/.devops-workspace-install.log
```

---

## Customizing Shell Configuration

### Adding Custom Functions

```bash
# Add to ~/.bashrc or ~/.zshrc

# Function to switch kubectl context and namespace
kswitch() {
    local context=$1
    local namespace=${2:-default}
    kubectl config use-context "$context"
    kubectl config set-context --current --namespace="$namespace"
    echo "Switched to context: $context, namespace: $namespace"
}

# Function to tail logs from all pods matching label
klogs() {
    local label=$1
    local namespace=${2:-default}
    kubectl logs -f -l "$label" -n "$namespace" --all-containers=true
}

# Function to quickly create disposable containers
drun() {
    docker run --rm -it "$@" /bin/bash
}

# Function to backup and apply terraform
tfapply-safe() {
    terraform plan -out=tfplan
    read -p "Apply this plan? (yes/no): " confirm
    if [[ "$confirm" == "yes" ]]; then
        terraform apply tfplan
    fi
    rm tfplan
}
```

### Custom Environment Variables

```bash
# Add to ~/.bashrc or ~/.zshrc

# Default AWS profile
export AWS_PROFILE=production

# Default kubectl context
export KUBECONFIG=~/.kube/config

# Terraform settings
export TF_LOG=INFO
export TF_LOG_PATH=./terraform.log

# Go settings
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# Custom editor
export EDITOR=nvim
export VISUAL=nvim
```

---

## Customizing tmux

### Personal tmux Configuration

```bash
# Edit your tmux config
vim ~/.tmux.conf

# Add custom bindings
cat >> ~/.tmux.conf << 'EOF'

# My custom tmux settings

# Easy window switching
bind -n C-h previous-window
bind -n C-l next-window

# Custom status bar
set -g status-right "#[fg=yellow]#(kubectl config current-context) #[fg=cyan]%H:%M"

# New window in same directory
bind c new-window -c "#{pane_current_path}"
bind '"' split-window -c "#{pane_current_path}"
bind % split-window -h -c "#{pane_current_path}"
EOF

# Reload config
tmux source-file ~/.tmux.conf
```

### tmux Plugin Manager

```bash
# Install TPM
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Add to ~/.tmux.conf
cat >> ~/.tmux.conf << 'EOF'

# List of plugins
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'tmux-plugins/tmux-resurrect'

# Initialize TPM
run '~/.tmux/plugins/tpm/tpm'
EOF

# Install plugins: Prefix + I
```

---

## Customizing vim/neovim

### Add Plugins with vim-plug

```bash
# Install vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Add plugins to ~/.vimrc
cat >> ~/.vimrc << 'EOF'

call plug#begin('~/.vim/plugged')

" File explorer
Plug 'preservim/nerdtree'

" Fuzzy finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Git integration
Plug 'tpope/vim-fugitive'

" Status line
Plug 'vim-airline/vim-airline'

" Syntax highlighting
Plug 'sheerun/vim-polyglot'

" Auto-completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()

" Plugin settings
map <C-n> :NERDTreeToggle<CR>
nmap <C-p> :Files<CR>
EOF

# Install plugins
vim +PlugInstall +qall
```

### Language-Specific Settings

```bash
# Add to ~/.vimrc

" YAML files (Kubernetes manifests)
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType yaml setlocal cursorcolumn

" Terraform files
autocmd BufNewFile,BufRead *.tf setlocal filetype=terraform
autocmd BufNewFile,BufRead *.tfvars setlocal filetype=terraform

" Dockerfile
autocmd BufNewFile,BufRead Dockerfile* setlocal filetype=dockerfile

" JSON
autocmd FileType json syntax match Comment +\/\/.\+$+
autocmd FileType json setlocal ts=2 sts=2 sw=2 expandtab
```

---

## Creating Custom Categories

### Complete Custom Category Example

```bash
# Create directory structure
mkdir -p ~/devops-workspace/scripts/categories/custom

# Create installation script
cat > ~/devops-workspace/scripts/categories/custom/monitoring.sh << 'EOF'
#!/usr/bin/env bash

install_custom_monitoring() {
    log_info "Installing custom monitoring tools..."
    
    # Prometheus
    if ! is_installed prometheus; then
        install_prometheus
    fi
    
    # Grafana
    if ! is_installed grafana; then
        install_grafana
    fi
    
    # Alertmanager
    if ! is_installed alertmanager; then
        install_alertmanager
    fi
    
    log_success "Custom monitoring tools installed"
}

install_prometheus() {
    local version=$(get_latest_github_release "prometheus/prometheus")
    local arch=$(get_arch)
    local os=$(get_os_type)
    
    curl -fsSL "https://github.com/prometheus/prometheus/releases/download/${version}/prometheus-${version#v}.${os}-${arch}.tar.gz" -o /tmp/prometheus.tar.gz
    
    tar -xzf /tmp/prometheus.tar.gz -C /tmp
    sudo install -m 755 /tmp/prometheus-*/prometheus /usr/local/bin/
    
    verify_installation prometheus
}

install_grafana() {
    case "$OS_FAMILY" in
        debian)
            sudo apt-get install -y software-properties-common
            sudo add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"
            wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
            sudo apt-get update
            sudo apt-get install -y grafana
            ;;
        redhat)
            cat > /tmp/grafana.repo <<'REPO'
[grafana]
name=grafana
baseurl=https://packages.grafana.com/oss/rpm
enabled=1
gpgcheck=1
gpgkey=https://packages.grafana.com/gpg.key
REPO
            sudo mv /tmp/grafana.repo /etc/yum.repos.d/
            sudo $PKG_MANAGER install -y grafana
            ;;
    esac
    
    verify_installation grafana-server "--version"
}

install_alertmanager() {
    install_from_github_release "prometheus/alertmanager" "alertmanager" "alertmanager-{version}.{os}-{arch}.tar.gz"
}
EOF

# Add to main installer's category list
# Edit install.sh and add 'custom_monitoring' to the categories array
```

### Custom Aliases for Your Tools

```bash
# Create aliases file for your tools
cat > ~/devops-workspace/config/custom-aliases.sh << 'EOF'
#!/usr/bin/env bash

# Custom monitoring aliases
alias prom='prometheus'
alias prom-config='vim /etc/prometheus/prometheus.yml'
alias prom-reload='killall -HUP prometheus'

alias graf='sudo systemctl status grafana-server'
alias graf-start='sudo systemctl start grafana-server'
alias graf-stop='sudo systemctl stop grafana-server'
alias graf-log='sudo journalctl -u grafana-server -f'
EOF

# Source in main aliases file
echo 'source ~/devops-workspace/config/custom-aliases.sh' >> ~/devops-workspace/config/aliases.sh
```

---

## Advanced Customization

### Custom Installation Options

Create a configuration file:

```bash
# Create config file
cat > ~/devops-workspace/.custom-config << 'EOF'
# Custom installation preferences

# Skip these tools
SKIP_TOOLS="vagrant packer"

# Custom versions
TERRAFORM_VERSION="1.5.0"
KUBECTL_VERSION="1.27.0"

# Custom paths
CUSTOM_BIN_PATH="/opt/devops/bin"

# Installation options
INSTALL_DOCKER_COMPOSE=true
INSTALL_OH_MY_ZSH=true
EOF
```

### Integration with Dotfiles Repository

```bash
# Link devops-workspace with your dotfiles
cd ~/dotfiles
git submodule add https://github.com/yourusername/devops-workspace

# Create symlinks
ln -sf ~/dotfiles/devops-workspace/config/aliases.sh ~/.devops-aliases.sh
ln -sf ~/dotfiles/devops-workspace/config/.tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/devops-workspace/config/.vimrc ~/.vimrc

# Commit to your dotfiles
git add .
git commit -m "Add devops-workspace as submodule"
```

---

## Sharing Customizations

### Export Your Configuration

```bash
# Create customization bundle
tar czf my-devops-config.tar.gz \
    ~/.bashrc \
    ~/.devops-aliases-personal.sh \
    ~/.tmux.conf \
    ~/.vimrc \
    ~/devops-workspace/scripts/categories/custom/

# Share with team
scp my-devops-config.tar.gz teammate@server:
```

### Team Configuration Repository

```bash
# Create team config repo
mkdir -p ~/team-devops-config
cd ~/team-devops-config

# Add team-specific configurations
mkdir -p {aliases,scripts,configs}

# Commit and share
git init
git add .
git commit -m "Initial team DevOps configuration"
git remote add origin git@github.com:team/devops-config.git
git push -u origin main
```

---

## Tips and Best Practices

1. **Keep Personal Configs Separate**: Don't modify core files directly
2. **Use Version Control**: Track your customizations in git
3. **Document Changes**: Comment your custom configurations
4. **Test Before Deploying**: Test new aliases/functions in a separate shell
5. **Backup Regularly**: Keep backups of your configurations
6. **Share with Team**: Create shared configurations for consistency

Happy customizing! 🚀
