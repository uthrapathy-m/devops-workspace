# Quick Start Guide

Get up and running with DevOps Workspace in 5 minutes!

## 🚀 Installation

### 1. Clone and Run

```bash
git clone https://github.com/yourusername/devops-workspace.git
cd devops-workspace
./install.sh
```

### 2. Select Tools

Use the interactive menu:
- **↑↓ arrows**: Navigate
- **Space**: Select/Deselect
- **Enter**: Install selected

Or install everything:
```bash
./install.sh --all
```

### 3. Reload Shell

```bash
source ~/.bashrc  # or ~/.zshrc
```

## ✅ Verify Installation

```bash
# Check installed tools
kubectl version --client
docker --version
terraform version

# Test aliases
k get pods  # Same as kubectl get pods
d ps        # Same as docker ps
tf plan     # Same as terraform plan
```

## 📚 Essential Aliases

### Kubernetes
```bash
k           # kubectl
kgp         # kubectl get pods
kgd         # kubectl get deployments
kl          # kubectl logs
kex         # kubectl exec -it
```

### Docker
```bash
d           # docker
dps         # docker ps
di          # docker images
dex         # docker exec -it
dc          # docker-compose
dcu         # docker-compose up
```

### Terraform
```bash
tf          # terraform
tfi         # terraform init
tfp         # terraform plan
tfa         # terraform apply
tfaa        # terraform apply -auto-approve
```

### Git
```bash
g           # git
gs          # git status
ga          # git add
gc          # git commit
gp          # git push
gco         # git checkout
```

## 🔧 Quick Configuration

### Set Default kubectl Context
```bash
kubectl config use-context my-cluster
kubectl config set-context --current --namespace=default
```

### Configure AWS CLI
```bash
aws configure
```

### Configure Google Cloud
```bash
gcloud init
```

### Configure GitHub CLI
```bash
gh auth login
```

## 💡 Productivity Tips

### Use fzf for History Search
- Press `Ctrl+R` to search command history
- Type to filter, Enter to select

### Use tmux for Terminal Management
```bash
tmux              # Start tmux
Ctrl+a |          # Split vertically
Ctrl+a -          # Split horizontally
Ctrl+a arrows     # Navigate panes
```

### Use bat for Better File Viewing
```bash
bat file.yaml     # Syntax-highlighted output
```

### Use ripgrep for Fast Search
```bash
rg "search term"  # Search in all files
rg -i "term"      # Case insensitive
```

## 🎯 Common Workflows

### Deploy to Kubernetes
```bash
k apply -f deployment.yaml
k get pods -w
kl pod-name -f
```

### Docker Development
```bash
d build -t myapp:latest .
d run -p 8080:8080 myapp:latest
dlf container-name
```

### Terraform Workflow
```bash
tfi
tfp
tfa
```

### View Logs Across Pods
```bash
stern app-name
# or
klog app=myapp
```

## 📖 More Information

- **Full Tool List**: [docs/TOOLS.md](docs/TOOLS.md)
- **Installation Guide**: [docs/INSTALLATION.md](docs/INSTALLATION.md)
- **Customization**: [docs/CUSTOMIZATION.md](docs/CUSTOMIZATION.md)
- **Troubleshooting**: [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)

## 🆘 Need Help?

```bash
# View all aliases
alias | less

# View specific category
alias | grep kubectl

# Check installation log
cat ~/.devops-workspace-install.log

# List installed tools
./install.sh --list
```

## 🎉 Next Steps

1. Configure your cloud CLIs (AWS, Azure, GCloud)
2. Set up kubectl contexts
3. Try tmux for terminal management
4. Customize aliases in `~/.devops-aliases-personal.sh`
5. Explore productivity tools (fzf, bat, eza, ripgrep)

Happy DevOps-ing! 🚀
