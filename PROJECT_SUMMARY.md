# DevOps Workspace - Project Summary

## Overview

DevOps Workspace is a comprehensive, cross-Linux distribution installer for DevOps engineers. It provides selective installation of 40+ essential DevOps tools with an interactive menu system, pre-configured aliases, and dotfiles.

## Key Features

✅ **Cross-Linux Support**: Ubuntu, Debian, Fedora, CentOS, Rocky, Alma, Arch, Manjaro, openSUSE
✅ **Selective Installation**: Choose exactly which tools to install
✅ **100+ DevOps Aliases**: Practical, work-focused shortcuts
✅ **Interactive Menu**: Easy tool selection with keyboard navigation
✅ **Category-Based**: Tools organized by function (Containers, Cloud, IaC, CI/CD, etc.)
✅ **Dotfiles Included**: Pre-configured tmux, vim configurations
✅ **Automated Installation**: GitHub releases, package managers, binary downloads
✅ **Uninstaller**: Clean removal with backups
✅ **CI/CD Ready**: GitHub Actions workflow included

## Project Structure

```
devops-workspace/
├── README.md                          # Main documentation
├── QUICKSTART.md                      # Quick start guide
├── LICENSE                            # MIT License
├── .gitignore                         # Git ignore rules
├── install.sh                         # Main installer (interactive)
├── uninstall.sh                       # Uninstaller with backups
│
├── config/
│   ├── aliases.sh                     # 100+ DevOps bash/zsh aliases
│   ├── .tmux.conf                     # tmux configuration
│   └── .vimrc                         # vim configuration
│
├── scripts/
│   ├── core/
│   │   ├── detect_os.sh               # OS detection & package manager
│   │   └── utils.sh                   # Common utility functions
│   │
│   └── categories/
│       ├── containers.sh              # Docker, kubectl, k9s, Helm, kind
│       ├── cloud_tools.sh             # AWS, Azure, GCloud, Terraform, Pulumi
│       ├── iac_tools.sh               # Ansible, Packer, Vagrant
│       ├── cicd_tools.sh              # GitHub CLI, GitLab CLI, ArgoCD
│       ├── monitoring.sh              # stern, ctop, htop, btop
│       ├── productivity.sh            # fzf, ripgrep, bat, eza, fd, jq, yq, etc.
│       ├── network_security.sh        # nmap, trivy, cosign
│       └── languages.sh               # Python3, Node.js, Go
│
├── menus/
│   └── interactive_menu.sh            # Interactive TUI menu
│
├── docs/
│   ├── TOOLS.md                       # Complete tool list & documentation
│   ├── INSTALLATION.md                # Installation guide
│   ├── CUSTOMIZATION.md               # Customization guide
│   └── TROUBLESHOOTING.md             # Troubleshooting guide
│
├── tests/
│   └── (Test scripts - to be added)
│
└── .github/
    └── workflows/
        └── test.yml                   # CI/CD workflow
```

## Installation Categories

### 1. Containers & Orchestration
- Docker & Docker Compose
- Podman
- kubectl
- k9s (Kubernetes TUI)
- Helm
- kind (Kubernetes in Docker)

### 2. Cloud CLI Tools
- AWS CLI v2
- Azure CLI
- Google Cloud SDK
- Terraform
- Pulumi
- OpenTofu

### 3. Infrastructure as Code
- Ansible
- Packer
- Vagrant

### 4. CI/CD Tools
- GitHub CLI (gh)
- GitLab CLI (glab)
- ArgoCD CLI

### 5. Monitoring & Observability
- stern (multi-pod log tailing)
- ctop (container metrics)
- htop
- btop

### 6. Productivity CLI Tools
- tmux (terminal multiplexer)
- zsh + oh-my-zsh
- fzf (fuzzy finder)
- ripgrep (fast grep)
- bat (better cat)
- eza (better ls)
- fd (better find)
- jq (JSON processor)
- yq (YAML processor)
- neovim
- ncdu (disk usage)
- tldr (simplified man pages)

### 7. Network & Security
- nmap
- trivy (container scanner)
- cosign (container signing)
- openssl

### 8. Languages & Runtimes
- Python 3 + pip
- Node.js + npm
- Go (golang)

## DevOps Aliases Highlights

The aliases are focused on **real DevOps work** scenarios:

### Kubernetes (30+ aliases)
```bash
k, kgp, kgd, kgs, kdp, kl, klf, kex, ka, kctx, kcn, kpf, kscale, kroll...
```

### Docker (25+ aliases)
```bash
d, dps, di, dex, dl, dc, dcu, dcd, dcl, dprune, db, dpush...
```

### Terraform (15+ aliases)
```bash
tf, tfi, tfp, tfa, tfaa, tfd, tfv, tff, tfo, tfws...
```

### Git (25+ aliases)
```bash
g, gs, ga, gc, gp, gpl, gco, gb, gm, gl, gd, gst...
```

### AWS CLI (10+ aliases)
```bash
aws, awsp, ec2-ls, ec2-start, s3-ls, ecr-login, lambda-ls...
```

### Custom Functions
```bash
klog()      # Get logs by label
kctxns()    # Switch context and namespace
kresources() # Get pod resources
kpfl()      # Port-forward by label
tfplan()    # Plan with output file
gcp()       # Git commit and push
dbp()       # Docker build and push
```

## Usage Examples

### Interactive Installation
```bash
./install.sh
# Select categories with Space, Enter to install
```

### Install All Tools
```bash
./install.sh --all
```

### Install Specific Category
```bash
./install.sh --category containers
./install.sh --category productivity
```

### List Available Tools
```bash
./install.sh --list
```

### Uninstall
```bash
./uninstall.sh
```

## Technical Implementation

### OS Detection
- Automatically detects Linux distribution
- Supports multiple package managers (apt, dnf, yum, pacman, zypper)
- Cross-distribution package name mapping

### Installation Methods
1. **Package Managers**: apt, dnf, yum, pacman, zypper
2. **GitHub Releases**: Automatic version detection and download
3. **Official Scripts**: Cloud CLIs, Terraform, Pulumi
4. **Binary Downloads**: kubectl, helm, k9s, etc.

### Error Handling
- Comprehensive error checking
- Installation logging
- Backup of existing configurations
- Rollback capabilities

### Modular Design
- Each category is independent
- Easy to add new tools
- Clean separation of concerns
- Reusable utility functions

## File Counts

- **Total Scripts**: 11 bash scripts (~3000+ lines)
- **Configuration Files**: 3 dotfiles
- **Documentation**: 5 comprehensive guides
- **Total Lines of Code**: ~3500 lines
- **Aliases Defined**: 100+ DevOps shortcuts

## CI/CD Integration

GitHub Actions workflow tests:
- Ubuntu 20.04, 22.04, 24.04
- Fedora latest
- Syntax checking with shellcheck
- Installation verification
- Uninstall testing

## Best Practices Implemented

1. ✅ **Idempotent**: Safe to run multiple times
2. ✅ **Non-destructive**: Backs up existing configs
3. ✅ **Logged**: All installations tracked
4. ✅ **Verified**: Post-install verification
5. ✅ **Documented**: Comprehensive documentation
6. ✅ **Tested**: CI/CD pipeline
7. ✅ **Modular**: Easy to extend
8. ✅ **User-friendly**: Interactive menus

## Customization Support

- Personal alias files
- Custom tool categories
- Environment variable configuration
- Plugin systems (tmux, vim)
- Team configuration sharing

## Future Enhancements (Suggestions)

- [ ] Add more language runtimes (Rust, Ruby, Java)
- [ ] Support for macOS
- [ ] Configuration profiles (minimal, standard, full)
- [ ] Auto-update functionality
- [ ] Shell plugin integrations (zsh-autosuggestions, etc.)
- [ ] Container-based testing for all distros
- [ ] Tool version pinning
- [ ] Backup/restore configurations
- [ ] Web dashboard for tool management

## License

MIT License - Free for personal and commercial use

## Target Audience

- DevOps Engineers
- SRE (Site Reliability Engineers)
- Cloud Engineers
- Platform Engineers
- Infrastructure Engineers
- Kubernetes Administrators
- Anyone managing cloud infrastructure

## Quick Start

```bash
# Clone
git clone https://github.com/yourusername/devops-workspace.git
cd devops-workspace

# Install
./install.sh

# Reload shell
source ~/.bashrc

# Start using
k get pods
d ps
tf plan
```

## Support & Documentation

- **Quick Start**: QUICKSTART.md
- **Installation Guide**: docs/INSTALLATION.md
- **Tool List**: docs/TOOLS.md
- **Customization**: docs/CUSTOMIZATION.md
- **Troubleshooting**: docs/TROUBLESHOOTING.md

---

**Created for DevOps engineers who want a fast, practical, cross-Linux tool setup without the hassle.**

🚀 Install once. Use everywhere. Work faster.
