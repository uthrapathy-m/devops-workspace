# DevOps Workspace Installer

A cross-Linux distribution installer for DevOps engineers. Select and install only the tools you need with an interactive menu system.

## Features

- 🐧 **Cross-Linux Support**: Works on Ubuntu, Debian, Fedora, CentOS, Arch, and more
- 🎯 **Selective Installation**: Choose exactly which tools to install
- 📦 **Categorized Tools**: Organized by Container, Cloud, IaC, CI/CD, Monitoring, Productivity, etc.
- ⚡ **DevOps Aliases**: Pre-configured bash/zsh aliases for faster workflows
- 🔧 **Dotfiles Included**: Optimized configurations for tmux, vim, and shell

## Quick Start

```bash
git clone https://github.com/yourusername/devops-workspace.git
cd devops-workspace
chmod +x install.sh
./install.sh
```

## Tool Categories

- **Containers & Orchestration**: Docker, Podman, kubectl, k9s, Helm, Kind
- **Cloud CLI Tools**: AWS CLI, Azure CLI, Google Cloud SDK, Terraform, Pulumi
- **Infrastructure as Code**: Ansible, Packer, Vagrant, OpenTofu
- **CI/CD**: GitHub CLI, GitLab CLI, ArgoCD CLI
- **Monitoring**: Prometheus tools, k9s, stern, ctop, htop
- **Productivity CLI**: fzf, ripgrep, bat, eza, fd, jq, yq, tmux, neovim
- **Network & Security**: nmap, trivy, cosign, openssl
- **Languages**: Python3, Node.js, Go

## Usage

### Interactive Mode (Recommended)
```bash
./install.sh
```

### Install Specific Category
```bash
./install.sh --category containers
./install.sh --category productivity
```

### Install All Tools
```bash
./install.sh --all
```

### Uninstall
```bash
./uninstall.sh
```

## DevOps Aliases

After installation, your shell will have 50+ DevOps aliases. Reload your shell:
```bash
source ~/.bashrc  # or ~/.zshrc
```

See all aliases:
```bash
alias | grep -E "kubectl|docker|terraform|git|aws"
```

## Documentation

- [Installation Guide](docs/INSTALLATION.md)
- [Complete Tool List](docs/TOOLS.md)
- [Customization Guide](docs/CUSTOMIZATION.md)
- [Troubleshooting](docs/TROUBLESHOOTING.md)

## Requirements

- Linux distribution (Ubuntu, Debian, Fedora, CentOS, Arch, etc.)
- sudo/root access
- curl or wget
- Basic build tools (automatically installed if missing)

## Contributing

Contributions welcome! Please read our contributing guidelines first.

## License

MIT License - see LICENSE file for details

## Author

DevOps Workspace Installer - A practical tool installer for DevOps engineers
