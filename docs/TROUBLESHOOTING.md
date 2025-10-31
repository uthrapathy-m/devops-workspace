# Troubleshooting Guide

Common issues and solutions for DevOps Workspace installation.

## Installation Issues

### Permission Denied

**Problem**: Getting "Permission denied" errors during installation

**Solution**:
```bash
# Ensure you have sudo privileges
sudo -v

# Make install script executable
chmod +x install.sh

# Check sudo configuration
groups $USER
```

### Network/Download Failures

**Problem**: Downloads timing out or failing

**Solutions**:
```bash
# Test internet connectivity
ping -c 3 github.com
ping -c 3 google.com

# Check DNS resolution
nslookup github.com

# Try with proxy if behind firewall
export http_proxy=http://proxy:port
export https_proxy=http://proxy:port

# Retry installation
./install.sh
```

### Disk Space Issues

**Problem**: "No space left on device"

**Solution**:
```bash
# Check disk space
df -h /
df -h /tmp

# Clean up if needed
sudo apt-get clean         # Debian/Ubuntu
sudo dnf clean all         # Fedora/RHEL
docker system prune -a     # If Docker installed

# Check required space (2GB minimum)
```

### Package Manager Errors

**Problem**: Package manager conflicts or errors

**Solutions**:
```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get upgrade
sudo dpkg --configure -a

# Fedora/RHEL
sudo dnf check-update
sudo dnf upgrade

# Arch
sudo pacman -Syu
```

## Tool-Specific Issues

### Docker Permission Denied

**Problem**: `docker: Got permission denied while trying to connect to the Docker daemon socket`

**Solution**:
```bash
# Add user to docker group
sudo usermod -aG docker $USER

# Apply group changes (choose one):
# Option 1: Log out and back in
# Option 2: Use newgrp
newgrp docker

# Option 3: Restart
sudo reboot

# Verify
docker run hello-world
```

### kubectl Cannot Connect

**Problem**: `The connection to the server localhost:8080 was refused`

**Solution**:
```bash
# Set kubeconfig
export KUBECONFIG=/path/to/your/kubeconfig

# Or set default location
mkdir -p ~/.kube
cp /path/to/kubeconfig ~/.kube/config

# Verify
kubectl cluster-info
```

### AWS CLI Configuration

**Problem**: AWS CLI not recognizing credentials

**Solution**:
```bash
# Configure AWS CLI
aws configure

# Or set environment variables
export AWS_ACCESS_KEY_ID=your_key
export AWS_SECRET_ACCESS_KEY=your_secret
export AWS_DEFAULT_REGION=us-east-1

# Verify
aws sts get-caller-identity
```

### Terraform State Lock

**Problem**: `Error: Error acquiring the state lock`

**Solution**:
```bash
# Force unlock (use carefully)
terraform force-unlock LOCK_ID

# Or check who has the lock
# If using S3 backend, check DynamoDB table
aws dynamodb get-item --table-name terraform-locks --key ...
```

### Python pip Issues

**Problem**: `externally-managed-environment` error

**Solution**:
```bash
# Use virtual environment
python3 -m venv ~/venv
source ~/venv/bin/activate
pip install package

# Or use --break-system-packages (not recommended)
pip3 install --break-system-packages package

# Or use pipx for tools
pipx install ansible
```

## Alias and Configuration Issues

### Aliases Not Working

**Problem**: Installed aliases don't work

**Solution**:
```bash
# Reload shell configuration
source ~/.bashrc  # for bash
source ~/.zshrc   # for zsh

# Or restart terminal
exec $SHELL

# Verify aliases loaded
alias | grep kubectl

# Check if aliases file exists
cat ~/devops-workspace/config/aliases.sh

# Manually source if needed
source ~/devops-workspace/config/aliases.sh
```

### tmux Configuration Not Applied

**Problem**: tmux not using custom configuration

**Solution**:
```bash
# Check config file exists
ls -la ~/.tmux.conf

# Reload tmux config (inside tmux)
tmux source-file ~/.tmux.conf

# Or restart tmux
tmux kill-server
tmux
```

### vim Configuration Not Working

**Problem**: vim not using custom settings

**Solution**:
```bash
# Check config exists
cat ~/.vimrc

# Test vim configuration
vim -c ':scriptnames'

# Use neovim instead
nvim file.txt
```

## Cross-Distribution Issues

### Tool Not Available in Package Manager

**Problem**: Tool not found in distribution's package manager

**Solution**:
```bash
# Most tools are installed from source/GitHub
# Installer handles this automatically

# For manual installation, check:
# - GitHub releases
# - Official tool documentation
# - Alternative package managers (snap, flatpak)
```

### Different Package Names

**Problem**: Package has different name on your distro

**Solution**:
The installer handles most variations, but if issues occur:

```bash
# Search for package
apt-cache search package-name  # Debian/Ubuntu
dnf search package-name        # Fedora/RHEL
pacman -Ss package-name        # Arch

# Check package manager logs
cat /var/log/apt/history.log   # Debian/Ubuntu
dnf history                    # Fedora/RHEL
```

## GitHub Rate Limiting

**Problem**: `API rate limit exceeded` when downloading from GitHub

**Solution**:
```bash
# Wait an hour, or authenticate with GitHub
# Create GitHub token at: https://github.com/settings/tokens

# Use token for downloads
export GITHUB_TOKEN=your_token_here

# Or wait 60 minutes for rate limit reset
```

## Shell-Specific Issues

### zsh Compatibility

**Problem**: Aliases/functions not working in zsh

**Solution**:
```bash
# Ensure zsh config sources aliases
cat ~/.zshrc | grep aliases.sh

# Add manually if missing
echo 'source ~/devops-workspace/config/aliases.sh' >> ~/.zshrc
source ~/.zshrc
```

### bash vs zsh Differences

**Problem**: Different behavior between bash and zsh

**Solution**:
```bash
# Check current shell
echo $SHELL

# Switch shells
chsh -s /bin/bash  # Switch to bash
chsh -s /bin/zsh   # Switch to zsh

# Log out and back in for changes to take effect
```

## Verification Commands

Use these to verify installations:

```bash
# Check all tools
command -v docker kubectl helm terraform ansible

# Check versions
docker --version
kubectl version --client
terraform version
aws --version

# Check logs
cat ~/.devops-workspace-install.log

# Check paths
echo $PATH | tr ':' '\n'

# Check aliases
alias | wc -l
```

## Getting More Help

If issues persist:

1. **Check installation log**: `~/.devops-workspace-install.log`
2. **Enable debug mode**: `bash -x ./install.sh`
3. **Check tool-specific docs**: See `docs/TOOLS.md`
4. **Review system logs**: `journalctl -xe` or `/var/log/syslog`
5. **Test minimal install**: Try installing just one category first

## Clean Reinstall

If all else fails, start fresh:

```bash
# Uninstall
./uninstall.sh

# Clean up
rm -rf ~/devops-workspace

# Re-clone
git clone https://github.com/yourusername/devops-workspace.git
cd devops-workspace

# Install again
./install.sh --category productivity  # Start with one category
```

## Common Error Messages

### "command not found"
- Tool not installed or not in PATH
- Run `which tool-name` to find it
- Add to PATH if necessary

### "connection refused"
- Service not running (e.g., Docker daemon)
- Start service: `sudo systemctl start docker`

### "certificate verify failed"
- SSL/TLS certificate issues
- Check system time: `date`
- Update ca-certificates: `sudo update-ca-certificates`

### "operation not permitted"
- Insufficient permissions
- Use sudo where appropriate
- Check file permissions: `ls -l`

Still having issues? Check the tool's official documentation linked in `docs/TOOLS.md`.
