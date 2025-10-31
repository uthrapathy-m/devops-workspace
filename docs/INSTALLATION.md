# Installation Guide

Complete guide for installing and using DevOps Workspace.

## System Requirements

- Linux distribution (Ubuntu, Debian, Fedora, CentOS, Rocky, Alma, Arch, Manjaro, openSUSE)
- sudo/root access
- curl or wget
- 2GB free disk space (varies based on selected tools)
- Internet connection

## Quick Installation

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/devops-workspace.git
cd devops-workspace
```

### 2. Make Script Executable

```bash
chmod +x install.sh
```

### 3. Run Installation

```bash
./install.sh
```

This will launch the interactive menu where you can select which tools to install.

## Installation Modes

### Interactive Mode (Default)

Launch the interactive menu to select tools:

```bash
./install.sh
# or
./install.sh --interactive
```

Use arrow keys to navigate, Space to select/deselect, Enter to proceed.

### Install All Tools

Install everything without prompting:

```bash
./install.sh --all
```

⚠️ **Warning**: This will install all tools and may take 20-30 minutes depending on your internet speed.

### Install Specific Category

Install only one category of tools:

```bash
# Install only container tools
./install.sh --category containers

# Install only productivity tools
./install.sh --category productivity

# Install only cloud CLI tools
./install.sh --category cloud_tools
```

Available categories:
- `containers` - Docker, kubectl, k9s, Helm, etc.
- `cloud_tools` - AWS CLI, Azure CLI, GCloud, Terraform
- `iac_tools` - Ansible, Packer, Vagrant
- `cicd_tools` - GitHub CLI, GitLab CLI, ArgoCD
- `monitoring` - stern, ctop, htop, btop
- `productivity` - fzf, ripgrep, bat, eza, jq, yq
- `network_security` - nmap, trivy, cosign
- `languages` - Python3, Node.js, Go

### List Available Tools

View all available tools without installing:

```bash
./install.sh --list
```

## Post-Installation

### 1. Reload Your Shell

After installation, reload your shell configuration:

```bash
# For bash users
source ~/.bashrc

# For zsh users
source ~/.zshrc

# Or simply restart your terminal
```

### 2. Verify Installation

Check installed tools:

```bash
cat ~/.devops-workspace-install.log
```

Test some commands:

```bash
# Kubernetes
kubectl version --client

# Docker
docker --version

# Terraform
terraform version

# Check aliases
alias | grep kubectl
```

### 3. Configure Tools

Some tools require additional configuration:

#### AWS CLI
```bash
aws configure
```

#### Google Cloud SDK
```bash
gcloud init
```

#### kubectl
```bash
# Set your kubeconfig
export KUBECONFIG=/path/to/your/kubeconfig
```

#### GitHub CLI
```bash
gh auth login
```

#### GitLab CLI
```bash
glab auth login
```

## Customization

### Modify Aliases

Edit the aliases file:

```bash
vim ~/devops-workspace/config/aliases.sh
```

Then reload:

```bash
source ~/.bashrc  # or ~/.zshrc
```

### Customize tmux

Edit tmux configuration:

```bash
vim ~/devops-workspace/config/.tmux.conf
```

Reload tmux:

```bash
tmux source-file ~/.tmux.conf
```

### Customize vim

Edit vim configuration:

```bash
vim ~/devops-workspace/config/.vimrc
```

## Upgrading Tools

### Update Repository

```bash
cd devops-workspace
git pull origin main
```

### Reinstall Tools

Run the installer again to update tools:

```bash
./install.sh --category containers  # Update specific category
# or
./install.sh --all  # Update everything
```

Most tools will be updated to their latest versions.

## Docker Post-Installation

After installing Docker, you may need to:

### 1. Log Out and Back In

The installer adds your user to the `docker` group. To apply this:

```bash
# Log out and log back in
# Or run:
newgrp docker
```

### 2. Start Docker Service

```bash
sudo systemctl start docker
sudo systemctl enable docker
```

### 3. Verify Docker

```bash
docker run hello-world
```

## Troubleshooting Installation

### Permission Denied

If you get permission errors:

```bash
# Make sure you have sudo access
sudo -v

# Or run with sudo (not recommended for main script)
sudo ./install.sh
```

### Network Issues

If downloads fail:

```bash
# Check internet connection
ping -c 3 google.com

# Try with verbose output
bash -x ./install.sh
```

### Package Manager Errors

Update your package cache first:

```bash
# Ubuntu/Debian
sudo apt-get update

# Fedora/RHEL
sudo dnf check-update

# Arch
sudo pacman -Sy
```

### Space Issues

Check available disk space:

```bash
df -h /
```

Minimum 2GB free space recommended.

## Uninstallation

To remove installed tools:

```bash
./uninstall.sh
```

This will:
- Remove installed binaries
- Remove configuration files
- Restore backup of shell rc files
- Keep logs for reference

## Getting Help

- Check documentation: `docs/`
- Review installation log: `~/.devops-workspace-install.log`
- Check tool-specific docs: `docs/TOOLS.md`
- Troubleshooting: `docs/TROUBLESHOOTING.md`

## Next Steps

After installation:

1. Review available aliases: `alias | less`
2. Test Kubernetes tools: `kubectl version --client`
3. Configure cloud CLIs: `aws configure`, `gcloud init`
4. Try tmux: `tmux`
5. Explore productivity tools: `fzf`, `bat`, `eza`

Happy DevOps-ing! 🚀
