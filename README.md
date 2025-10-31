# DevOps Workspace Installer

A cross-Linux distribution installer for DevOps engineers. Select and install only the tools you need with an interactive, terminal-based menu system.

## Features

- 🐧 **Cross-Linux Support**: Works on Ubuntu, Debian, Fedora, CentOS, Arch, and more
- 🎯 **Two-Level Selection**: Choose categories, then select individual tools within each
- 📦 **Categorized Tools**: Organized by Container, Cloud, IaC, CI/CD, Monitoring, Productivity, etc.
- ⚡ **Modern DevOps Aliases**: Pre-configured bash aliases with modern CLI tools (eza, zoxide, fzf)
- 🔧 **Productive Configs**: Optimized configurations for tmux, neovim, and shell
- 🚀 **Smart Dependency Management**: Auto-installs required dependencies

## Quick Start

```bash
git clone https://github.com/yourusername/devops-workspace.git
cd devops-workspace
chmod +x install.sh
./install.sh
```

## Tool Categories

### 1. Containers & Orchestration
Docker, Podman, kubectl, k9s, Helm, kind, minikube

### 2. Cloud CLI Tools
AWS CLI, Azure CLI, Google Cloud SDK, DigitalOcean CLI

### 3. Infrastructure as Code
Terraform, OpenTofu, Ansible, Pulumi, Packer, Vagrant

### 4. CI/CD & GitOps
GitHub CLI, GitLab CLI, ArgoCD, Flux

### 5. Monitoring & Observability
stern, ctop, htop, btop

### 6. Productivity CLI Tools
- **Terminal multiplexer**: tmux
- **Fuzzy finder**: fzf
- **Search**: ripgrep, fd
- **File viewing**: bat, eza
- **Data processing**: jq, yq
- **Modern navigation**: zoxide (smart cd)
- **Editor**: neovim with productive config, LazyVim
- **Disk usage**: ncdu, duf
- **Docker TUI**: lazydocker
- **Quick docs**: tldr

### 7. Network & Security
net-tools, nmap, trivy, cosign, openssl

### 8. Languages & Runtimes
Python3, Node.js, Go

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

After installation, your shell will have 100+ DevOps aliases. Reload your shell:
```bash
source ~/.bashrc
```

### Modern CLI Aliases
```bash
ls    # eza with icons and git status
lt    # tree view with git info
ff    # fzf with bat preview
cd    # zoxide (smart cd based on frecency)
```

### Kubernetes Shortcuts
```bash
k     # kubectl
kgp   # kubectl get pods
kl    # kubectl logs
kex   # kubectl exec -it
```

### Docker Shortcuts
```bash
d     # docker
dps   # docker ps
dl    # docker logs
dex   # docker exec -it
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
