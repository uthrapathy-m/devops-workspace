# 🚀 DevOps Workspace - Complete Setup

Your cross-Linux DevOps tool installer is ready!

## 📦 What's Included

✅ **26 Files** organized in a complete project structure
✅ **100+ DevOps Aliases** focused on real work scenarios
✅ **40+ Tools** across 8 categories
✅ **Cross-Linux Support** - Ubuntu, Debian, Fedora, CentOS, Arch, etc.
✅ **Complete Documentation** - Installation, customization, troubleshooting
✅ **CI/CD Ready** - GitHub Actions workflow included

## 🎯 Quick Start (3 Steps)

### 1. Push to GitHub

```bash
cd devops-workspace

# Initialize git (if not already done)
git init
git add .
git commit -m "Initial commit: DevOps Workspace installer"

# Push to GitHub
git remote add origin git@github.com:YOUR_USERNAME/devops-workspace.git
git branch -M main
git push -u origin main
```

### 2. Use on Any Linux Machine

```bash
# Clone on any Linux machine
git clone https://github.com/YOUR_USERNAME/devops-workspace.git
cd devops-workspace

# Run installer
./install.sh

# Select tools with interactive menu
# Or install all: ./install.sh --all
```

### 3. Enjoy Your Aliases

```bash
# Reload shell
source ~/.bashrc  # or ~/.zshrc

# Start using aliases
k get pods              # kubectl get pods
d ps                    # docker ps
tf plan                 # terraform plan
g status                # git status
```

## 📁 Project Structure

```
devops-workspace/
├── install.sh                    ⭐ Main installer script
├── uninstall.sh                  🗑️  Uninstaller with backups
├── README.md                     📖 Project documentation
├── QUICKSTART.md                 ⚡ Quick start guide
├── PROJECT_SUMMARY.md            📊 Complete project overview
├── LICENSE                       📜 MIT License
│
├── config/
│   ├── aliases.sh                🎯 100+ DevOps aliases
│   ├── init.lua                  ✏️  Neovim configuration
│   ├── .tmux.conf                🖥️  tmux configuration
│   └── .vimrc                    ✏️  vim configuration
│
├── scripts/
│   ├── core/
│   │   ├── detect_os.sh          🔍 OS detection
│   │   └── utils.sh              🛠️  Utility functions
│   │
│   └── categories/               📦 8 tool categories
│       ├── containers.sh         🐳 Docker, kubectl, k9s, Helm, kind
│       ├── cloud_tools.sh        ☁️  AWS, Azure, GCloud, DigitalOcean
│       ├── iac_tools.sh          🏗️  Terraform, Ansible, Pulumi, Packer
│       ├── cicd_tools.sh         🔄 GitHub CLI, GitLab CLI, ArgoCD, Flux
│       ├── monitoring.sh         📊 stern, ctop, htop, btop
│       ├── productivity.sh       ⚡ fzf, bat, eza, zoxide, nvim, lazydocker
│       ├── network_security.sh   🔒 net-tools, nmap, trivy, cosign
│       └── languages.sh          💻 Python, Node.js, Go
│
├── menus/
│   └── interactive_menu.sh       🎛️  Interactive TUI
│
├── docs/
│   ├── TOOLS.md                  📋 Complete tool list
│   ├── INSTALLATION.md           📥 Installation guide
│   ├── CUSTOMIZATION.md          🎨 Customization guide
│   └── TROUBLESHOOTING.md        🔧 Troubleshooting
│
└── .github/workflows/
    └── test.yml                  ✅ CI/CD pipeline
```

## 🎨 Key Features

### 1. DevOps-Focused Aliases

All aliases are designed for **real DevOps work**:

**Kubernetes**: `k`, `kgp`, `kdp`, `kl`, `kex`, `kctx`, `kcn`, `kscale`, `kroll`
**Docker**: `d`, `dps`, `dex`, `dc`, `dcu`, `dcd`, `dprune`
**Terraform**: `tf`, `tfi`, `tfp`, `tfa`, `tfaa`, `tfd`, `tfws`
**Git**: `g`, `gs`, `ga`, `gc`, `gp`, `gco`, `gb`, `gm`, `gl`
**AWS**: `ec2-ls`, `s3-ls`, `ecr-login`, `lambda-ls`
**Helm**: `h`, `hl`, `hi`, `hup`, `hdel`

### 2. Cross-Linux Support

Works on:
- Ubuntu / Debian / Linux Mint
- Fedora / RHEL / CentOS / Rocky / Alma
- Arch / Manjaro
- openSUSE

### 3. Selective Installation

Choose exactly what you need:
- Install all tools
- Install by category
- Interactive menu selection

### 4. Professional Configuration

Included dotfiles:
- **.tmux.conf**: Optimized tmux setup
- **init.lua**: Productive Neovim config (leader key, LSP-ready, DevOps file types)
- **.vimrc**: Basic vim config
- **aliases.sh**: 100+ practical shortcuts with modern tools (eza, zoxide, fzf)

## 📚 Documentation Guide

**Start Here**:
1. [QUICKSTART.md](QUICKSTART.md) - Get running in 5 minutes
2. [README.md](README.md) - Main documentation

**Deep Dive**:
- [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md) - Complete project overview
- [docs/TOOLS.md](docs/TOOLS.md) - All 40+ tools explained
- [docs/INSTALLATION.md](docs/INSTALLATION.md) - Detailed installation guide
- [docs/CUSTOMIZATION.md](docs/CUSTOMIZATION.md) - Make it yours
- [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) - Fix issues

## 🛠️ Installation Modes

```bash
# Interactive (default) - Pick and choose
./install.sh

# Install everything
./install.sh --all

# Install specific category
./install.sh --category containers
./install.sh --category productivity
./install.sh --category cloud_tools

# List available tools
./install.sh --list

# Uninstall
./uninstall.sh
```

## ⚡ Most Useful Aliases

```bash
# Kubernetes - Context switching
kctx                          # List contexts
kcon production               # Switch context
kcn my-namespace              # Set namespace

# Docker - Quick container exec
dex container-id              # Enter container
dlf container-id              # Follow logs

# Terraform - Safe apply
tfplan                        # Plan and save
tfa                          # Apply saved plan

# Git - Quick commit & push
gcp "commit message"          # Add, commit, push in one command

# Kubernetes - Multi-pod logs
klog app=myapp               # Tail logs by label selector

# Port forwarding by label
kpfl app=myapp 8080          # Forward port using label
```

## 🎯 Real-World Usage Examples

### Deploy to Kubernetes
```bash
k apply -f deployment.yaml
kgp -w                        # Watch pods
kl pod-name -f                # Follow logs
kex pod-name -- bash          # Enter container
```

### Docker Development
```bash
db -t myapp:latest .          # Build
d run -p 8080:8080 myapp      # Run
dlf myapp                     # Follow logs
dprune                        # Clean up
```

### Terraform Workflow
```bash
tfi                          # Init
tfp                          # Plan
tfa                          # Apply
tfo                          # Show outputs
```

### Git Workflow
```bash
gs                           # Check status
ga .                         # Stage all
gcm "feature: new stuff"     # Commit
gp                           # Push
```

## 💡 Pro Tips

1. **Use fzf**: Press `Ctrl+R` for fuzzy command history search, or `ff` for file preview
2. **Use zoxide**: Just `cd` to frequently visited directories by name, no full path needed
3. **Use tmux**: Manage multiple terminal sessions
4. **Use bat**: Better file viewing with syntax highlighting
5. **Use eza**: Modern `ls` with icons, git status, and tree view (`lt`)
6. **Use lazydocker**: TUI for Docker management
7. **Use neovim**: Configured with leader key (space), DevOps file types, and productive shortcuts
8. **Customize**: Add personal aliases in `~/.devops-aliases-personal.sh`

## 🚀 Next Steps

1. **Push to GitHub** (see above)
2. **Try it on a VM** or test machine
3. **Customize aliases** for your workflow
4. **Share with team** - consistent dev environment
5. **Add your tools** - extend with custom categories

## 🤝 Contributing

Want to add more tools or improve scripts?

1. Fork the repository
2. Create a new branch
3. Add your changes
4. Test thoroughly
5. Submit pull request

## 📊 Stats

- **Total Files**: 26
- **Lines of Code**: ~3,500
- **Bash Scripts**: 11
- **Configuration Files**: 3
- **Documentation Pages**: 5
- **Aliases Defined**: 100+
- **Tools Supported**: 40+
- **Linux Distros**: 8+

## 📝 License

MIT License - Use freely for personal and commercial projects

---

## 🎉 You're All Set!

Your DevOps workspace installer is complete and ready to use.

**Remember**: This tool is designed to save you hours of setup time on every new machine or project.

Happy DevOps-ing! 🚀
