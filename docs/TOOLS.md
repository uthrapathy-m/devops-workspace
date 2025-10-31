# DevOps Tools List

Complete list of tools available in DevOps Workspace Installer.

## 1. Containers & Orchestration

### Docker
- **Description**: Container platform for building, shipping, and running applications
- **Usage**: `docker ps`, `docker build`, `docker run`
- **Docs**: https://docs.docker.com

### Docker Compose
- **Description**: Tool for defining multi-container Docker applications
- **Usage**: `docker-compose up`, `docker-compose down`
- **Docs**: https://docs.docker.com/compose

### Podman
- **Description**: Daemonless container engine (Docker alternative)
- **Usage**: `podman ps`, `podman run`
- **Docs**: https://podman.io

### kubectl
- **Description**: Kubernetes command-line tool
- **Usage**: `kubectl get pods`, `kubectl apply -f`
- **Docs**: https://kubernetes.io/docs/reference/kubectl

### k9s
- **Description**: Terminal UI for Kubernetes clusters
- **Usage**: `k9s`
- **Docs**: https://k9scli.io

### Helm
- **Description**: Package manager for Kubernetes
- **Usage**: `helm install`, `helm upgrade`
- **Docs**: https://helm.sh/docs

### kind
- **Description**: Kubernetes IN Docker - local Kubernetes clusters
- **Usage**: `kind create cluster`
- **Docs**: https://kind.sigs.k8s.io

---

## 2. Cloud CLI Tools

### AWS CLI
- **Description**: Official Amazon Web Services command-line interface
- **Usage**: `aws s3 ls`, `aws ec2 describe-instances`
- **Docs**: https://aws.amazon.com/cli

### Azure CLI
- **Description**: Microsoft Azure command-line interface
- **Usage**: `az vm list`, `az account show`
- **Docs**: https://docs.microsoft.com/cli/azure

### Google Cloud SDK
- **Description**: Google Cloud Platform command-line tools
- **Usage**: `gcloud compute instances list`, `gsutil ls`
- **Docs**: https://cloud.google.com/sdk/docs

### Terraform
- **Description**: Infrastructure as Code tool by HashiCorp
- **Usage**: `terraform plan`, `terraform apply`
- **Docs**: https://www.terraform.io/docs

### Pulumi
- **Description**: Modern Infrastructure as Code using programming languages
- **Usage**: `pulumi up`, `pulumi stack`
- **Docs**: https://www.pulumi.com/docs

### OpenTofu
- **Description**: Open-source Terraform alternative
- **Usage**: `tofu plan`, `tofu apply`
- **Docs**: https://opentofu.org/docs

---

## 3. Infrastructure as Code

### Ansible
- **Description**: Automation platform for configuration management
- **Usage**: `ansible-playbook site.yml`
- **Docs**: https://docs.ansible.com

### Packer
- **Description**: Tool for creating machine images
- **Usage**: `packer build template.json`
- **Docs**: https://www.packer.io/docs

### Vagrant
- **Description**: Development environment management tool
- **Usage**: `vagrant up`, `vagrant ssh`
- **Docs**: https://www.vagrantup.com/docs

---

## 4. CI/CD Tools

### GitHub CLI
- **Description**: GitHub's official command-line tool
- **Usage**: `gh pr create`, `gh issue list`
- **Docs**: https://cli.github.com/manual

### GitLab CLI
- **Description**: GitLab's command-line tool
- **Usage**: `glab mr create`, `glab issue list`
- **Docs**: https://gitlab.com/gitlab-org/cli

### ArgoCD CLI
- **Description**: GitOps continuous delivery tool for Kubernetes
- **Usage**: `argocd app sync`, `argocd app get`
- **Docs**: https://argo-cd.readthedocs.io

---

## 5. Monitoring & Observability

### stern
- **Description**: Multi-pod log tailing for Kubernetes
- **Usage**: `stern pod-name`, `stern -l app=myapp`
- **Docs**: https://github.com/stern/stern

### ctop
- **Description**: Top-like interface for container metrics
- **Usage**: `ctop`
- **Docs**: https://github.com/bcicen/ctop

### htop
- **Description**: Interactive process viewer
- **Usage**: `htop`
- **Docs**: https://htop.dev

### btop
- **Description**: Resource monitor with better interface
- **Usage**: `btop`
- **Docs**: https://github.com/aristocratos/btop

---

## 6. Productivity CLI Tools

### tmux
- **Description**: Terminal multiplexer
- **Usage**: `tmux`, `tmux attach`
- **Docs**: https://github.com/tmux/tmux/wiki

### zsh
- **Description**: Extended Bourne shell with improvements
- **Usage**: `zsh`
- **Docs**: https://www.zsh.org

### fzf
- **Description**: Fuzzy finder for the command line
- **Usage**: `fzf`, `Ctrl+R` (history search)
- **Docs**: https://github.com/junegunn/fzf

### ripgrep (rg)
- **Description**: Fast grep alternative
- **Usage**: `rg pattern`, `rg -i case-insensitive`
- **Docs**: https://github.com/BurntSushi/ripgrep

### bat
- **Description**: Cat clone with syntax highlighting
- **Usage**: `bat file.yaml`
- **Docs**: https://github.com/sharkdp/bat

### eza
- **Description**: Modern ls replacement
- **Usage**: `eza -la`, `eza --tree`
- **Docs**: https://github.com/eza-community/eza

### fd
- **Description**: Fast find alternative
- **Usage**: `fd pattern`, `fd -e yaml`
- **Docs**: https://github.com/sharkdp/fd

### jq
- **Description**: JSON processor
- **Usage**: `cat file.json | jq '.key'`
- **Docs**: https://stedolan.github.io/jq

### yq
- **Description**: YAML processor (like jq for YAML)
- **Usage**: `cat file.yaml | yq '.key'`
- **Docs**: https://github.com/mikefarah/yq

### neovim
- **Description**: Modern vim-based text editor
- **Usage**: `nvim file.txt`
- **Docs**: https://neovim.io/doc

### ncdu
- **Description**: Disk usage analyzer
- **Usage**: `ncdu /path`
- **Docs**: https://dev.yorhel.nl/ncdu

### tldr
- **Description**: Simplified man pages
- **Usage**: `tldr kubectl`
- **Docs**: https://tldr.sh

---

## 7. Network & Security

### nmap
- **Description**: Network scanning and security auditing tool
- **Usage**: `nmap -sV localhost`
- **Docs**: https://nmap.org/book

### trivy
- **Description**: Container vulnerability scanner
- **Usage**: `trivy image nginx:latest`
- **Docs**: https://aquasecurity.github.io/trivy

### cosign
- **Description**: Container signing and verification tool
- **Usage**: `cosign sign`, `cosign verify`
- **Docs**: https://docs.sigstore.dev/cosign

### openssl
- **Description**: Cryptography toolkit
- **Usage**: `openssl req -new`, `openssl s_client`
- **Docs**: https://www.openssl.org/docs

---

## 8. Languages & Runtimes

### Python 3
- **Description**: High-level programming language
- **Usage**: `python3 script.py`, `pip3 install package`
- **Docs**: https://docs.python.org/3

### Node.js
- **Description**: JavaScript runtime
- **Usage**: `node app.js`, `npm install`
- **Docs**: https://nodejs.org/docs

### Go
- **Description**: Programming language by Google
- **Usage**: `go run main.go`, `go build`
- **Docs**: https://go.dev/doc

---

## Aliases

After installation, 100+ DevOps aliases are available. View them:

```bash
source ~/.bashrc  # or ~/.zshrc
alias | grep -E "kubectl|docker|terraform"
```

See `config/aliases.sh` for complete list.
