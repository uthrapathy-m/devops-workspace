# DevOps Workspace - Alias Cheatsheet

Quick reference guide for all 100+ DevOps aliases configured in your shell.

**View this anytime by typing**: `cheat`

---

## 🐳 Docker Aliases

### Basic Docker Commands
| Alias | Full Command | Description |
|-------|-------------|-------------|
| `d` | `docker` | Docker command shortcut |
| `dps` | `docker ps` | List running containers |
| `dpsa` | `docker ps -a` | List all containers (including stopped) |
| `di` | `docker images` | List all images |
| `dstop` | `docker stop` | Stop a container |
| `drm` | `docker rm` | Remove a container |
| `drmi` | `docker rmi` | Remove an image |
| `dex` | `docker exec -it` | Execute command in container (interactive) |
| `dl` | `docker logs` | View container logs |
| `dlf` | `docker logs -f` | Follow container logs (live) |
| `dinspect` | `docker inspect` | Inspect container/image details |
| `dstats` | `docker stats` | View container resource usage |

### Docker Compose
| Alias | Full Command | Description |
|-------|-------------|-------------|
| `dc` | `docker-compose` | Docker compose shortcut |
| `dcu` | `docker-compose up` | Start services |
| `dcud` | `docker-compose up -d` | Start services in background |
| `dcd` | `docker-compose down` | Stop and remove services |
| `dcl` | `docker-compose logs` | View service logs |
| `dclf` | `docker-compose logs -f` | Follow service logs |
| `dcps` | `docker-compose ps` | List services |
| `dcr` | `docker-compose restart` | Restart services |
| `dcb` | `docker-compose build` | Build services |
| `dce` | `docker-compose exec` | Execute command in service |

### Docker Cleanup
| Alias | Full Command | Description |
|-------|-------------|-------------|
| `dprune` | `docker system prune -a` | Remove unused data (all) |
| `dprunev` | `docker volume prune` | Remove unused volumes |
| `dprunen` | `docker network prune` | Remove unused networks |
| `ddf` | `docker system df` | Show docker disk usage |

### Docker Build & Push
| Alias | Full Command | Description |
|-------|-------------|-------------|
| `db` | `docker build` | Build image |
| `dbt` | `docker build -t` | Build image with tag |
| `dtag` | `docker tag` | Tag an image |
| `dpush` | `docker push` | Push image to registry |
| `dpull` | `docker pull` | Pull image from registry |

---

## ☸️ Kubernetes Aliases

### Basic kubectl Commands
| Alias | Full Command | Description |
|-------|-------------|-------------|
| `k` | `kubectl` | kubectl shortcut |
| `kgp` | `kubectl get pods` | List pods |
| `kgpa` | `kubectl get pods --all-namespaces` | List pods in all namespaces |
| `kgd` | `kubectl get deployments` | List deployments |
| `kgs` | `kubectl get services` | List services |
| `kgn` | `kubectl get nodes` | List nodes |
| `kgns` | `kubectl get namespaces` | List namespaces |
| `kgpvc` | `kubectl get pvc` | List persistent volume claims |
| `kgpv` | `kubectl get pv` | List persistent volumes |

### Describe Resources
| Alias | Full Command | Description |
|-------|-------------|-------------|
| `kdp` | `kubectl describe pod` | Describe a pod |
| `kdd` | `kubectl describe deployment` | Describe a deployment |
| `kds` | `kubectl describe service` | Describe a service |
| `kdn` | `kubectl describe node` | Describe a node |

### Logs & Debugging
| Alias | Full Command | Description |
|-------|-------------|-------------|
| `kl` | `kubectl logs` | View pod logs |
| `klf` | `kubectl logs -f` | Follow pod logs (live) |
| `klp` | `kubectl logs -p` | View previous container logs |

### Execute & Shell Access
| Alias | Full Command | Description |
|-------|-------------|-------------|
| `kex` | `kubectl exec -it` | Execute command in pod |
| `keti` | `kubectl exec -it` | Execute command in pod (interactive) |

### Edit Resources
| Alias | Full Command | Description |
|-------|-------------|-------------|
| `ked` | `kubectl edit deployment` | Edit deployment |
| `kes` | `kubectl edit service` | Edit service |
| `kecm` | `kubectl edit configmap` | Edit configmap |

### Apply & Delete
| Alias | Full Command | Description |
|-------|-------------|-------------|
| `ka` | `kubectl apply -f` | Apply configuration from file |
| `kdel` | `kubectl delete` | Delete resource |
| `kdelp` | `kubectl delete pod` | Delete pod |

### Context & Config
| Alias | Full Command | Description |
|-------|-------------|-------------|
| `kctx` | `kubectl config get-contexts` | List contexts |
| `kcon` | `kubectl config use-context` | Switch context |
| `kcn` | `kubectl config set-context --current --namespace` | Set namespace for current context |

### Port Forwarding
| Alias | Full Command | Description |
|-------|-------------|-------------|
| `kpf` | `kubectl port-forward` | Forward port from pod |

### Resource Monitoring
| Alias | Full Command | Description |
|-------|-------------|-------------|
| `ktop` | `kubectl top nodes` | Show node resource usage |
| `ktopp` | `kubectl top pods` | Show pod resource usage |

### Rollouts
| Alias | Full Command | Description |
|-------|-------------|-------------|
| `kroll` | `kubectl rollout` | Manage rollouts |
| `krollr` | `kubectl rollout restart` | Restart rollout |
| `krolls` | `kubectl rollout status` | Check rollout status |
| `krollu` | `kubectl rollout undo` | Undo rollout |

### Scaling
| Alias | Full Command | Description |
|-------|-------------|-------------|
| `kscale` | `kubectl scale deployment` | Scale deployment |

### Events & Watch
| Alias | Full Command | Description |
|-------|-------------|-------------|
| `kge` | `kubectl get events --sort-by=.metadata.creationTimestamp` | Get events sorted by time |
| `kw` | `kubectl get pods -w` | Watch pods |

---

## 🏗️ Terraform Aliases

| Alias | Full Command | Description |
|-------|-------------|-------------|
| `tf` | `terraform` | Terraform shortcut |
| `tfi` | `terraform init` | Initialize terraform |
| `tfp` | `terraform plan` | Plan changes |
| `tfa` | `terraform apply` | Apply changes |
| `tfaa` | `terraform apply -auto-approve` | Apply without confirmation |
| `tfd` | `terraform destroy` | Destroy infrastructure |
| `tfda` | `terraform destroy -auto-approve` | Destroy without confirmation |
| `tfs` | `terraform show` | Show current state |
| `tfv` | `terraform validate` | Validate configuration |
| `tff` | `terraform fmt` | Format terraform files |
| `tfr` | `terraform refresh` | Refresh state |
| `tfo` | `terraform output` | Show outputs |
| `tfsl` | `terraform state list` | List resources in state |
| `tfss` | `terraform state show` | Show resource in state |
| `tfws` | `terraform workspace` | Manage workspaces |
| `tfwsl` | `terraform workspace list` | List workspaces |
| `tfwss` | `terraform workspace select` | Select workspace |

---

## 📦 Ansible Aliases

| Alias | Full Command | Description |
|-------|-------------|-------------|
| `ans` | `ansible` | Ansible shortcut |
| `ansp` | `ansible-playbook` | Run playbook |
| `ansv` | `ansible-vault` | Manage encrypted files |
| `ansi` | `ansible-inventory` | Manage inventory |
| `ansg` | `ansible-galaxy` | Manage roles |
| `ansc` | `ansible-config` | Manage configuration |
| `ansd` | `ansible-doc` | View documentation |
| `anspv` | `ansible-playbook --check --diff` | Dry run playbook |
| `anspl` | `ansible-playbook --list-tasks` | List playbook tasks |
| `ansph` | `ansible-playbook --list-hosts` | List playbook hosts |

---

## 🔧 Git Aliases

| Alias | Full Command | Description |
|-------|-------------|-------------|
| `g` | `git` | Git shortcut |
| `gs` | `git status` | Show working tree status |
| `ga` | `git add` | Add files to staging |
| `gaa` | `git add --all` | Add all files to staging |
| `gc` | `git commit` | Commit changes |
| `gcm` | `git commit -m` | Commit with message |
| `gca` | `git commit --amend` | Amend last commit |
| `gp` | `git push` | Push to remote |
| `gpl` | `git pull` | Pull from remote |
| `gf` | `git fetch` | Fetch from remote |
| `gco` | `git checkout` | Checkout branch |
| `gcb` | `git checkout -b` | Create and checkout branch |
| `gb` | `git branch` | List branches |
| `gbd` | `git branch -d` | Delete branch |
| `gbD` | `git branch -D` | Force delete branch |
| `gm` | `git merge` | Merge branch |
| `gr` | `git rebase` | Rebase branch |
| `gri` | `git rebase -i` | Interactive rebase |
| `gl` | `git log --oneline --graph --decorate` | Pretty log |
| `gla` | `git log --oneline --graph --decorate --all` | Pretty log (all branches) |
| `gd` | `git diff` | Show changes |
| `gdc` | `git diff --cached` | Show staged changes |
| `gst` | `git stash` | Stash changes |
| `gstp` | `git stash pop` | Pop stash |
| `gstl` | `git stash list` | List stashes |
| `grs` | `git reset` | Reset changes |
| `grh` | `git reset --hard` | Hard reset |
| `gcp` | `git cherry-pick` | Cherry pick commit |
| `gclean` | `git clean -fd` | Clean untracked files |
| `gtag` | `git tag` | Manage tags |

---

## ☁️ AWS CLI Aliases

### Basic AWS
| Alias | Full Command | Description |
|-------|-------------|-------------|
| `aws` | `aws` | AWS CLI |
| `awsp` | `aws --profile` | Use specific profile |
| `awsr` | `aws --region` | Use specific region |

### EC2
| Alias | Full Command | Description |
|-------|-------------|-------------|
| `ec2-ls` | `aws ec2 describe-instances ...` | List EC2 instances |
| `ec2-start` | `aws ec2 start-instances --instance-ids` | Start instance |
| `ec2-stop` | `aws ec2 stop-instances --instance-ids` | Stop instance |

### S3
| Alias | Full Command | Description |
|-------|-------------|-------------|
| `s3-ls` | `aws s3 ls` | List S3 buckets/objects |
| `s3-cp` | `aws s3 cp` | Copy files to/from S3 |
| `s3-sync` | `aws s3 sync` | Sync files with S3 |
| `s3-rb` | `aws s3 rb` | Remove bucket |
| `s3-mb` | `aws s3 mb` | Make bucket |

### ECS
| Alias | Full Command | Description |
|-------|-------------|-------------|
| `ecs-ls` | `aws ecs list-clusters` | List ECS clusters |
| `ecs-tasks` | `aws ecs list-tasks --cluster` | List tasks in cluster |
| `ecs-services` | `aws ecs list-services --cluster` | List services in cluster |

### ECR
| Alias | Full Command | Description |
|-------|-------------|-------------|
| `ecr-login` | `aws ecr get-login-password \| docker login ...` | Login to ECR |
| `ecr-ls` | `aws ecr describe-repositories` | List ECR repositories |

### Lambda
| Alias | Full Command | Description |
|-------|-------------|-------------|
| `lambda-ls` | `aws lambda list-functions` | List Lambda functions |
| `lambda-invoke` | `aws lambda invoke` | Invoke Lambda function |

### CloudWatch Logs
| Alias | Full Command | Description |
|-------|-------------|-------------|
| `cw-groups` | `aws logs describe-log-groups` | List log groups |
| `cw-streams` | `aws logs describe-log-streams --log-group-name` | List log streams |
| `cw-tail` | `aws logs tail` | Tail logs |

---

## ⎈ Helm Aliases

| Alias | Full Command | Description |
|-------|-------------|-------------|
| `h` | `helm` | Helm shortcut |
| `hl` | `helm list` | List releases |
| `hla` | `helm list --all-namespaces` | List releases (all namespaces) |
| `hi` | `helm install` | Install chart |
| `hup` | `helm upgrade` | Upgrade release |
| `hupi` | `helm upgrade --install` | Upgrade or install |
| `hdel` | `helm delete` | Delete release |
| `hs` | `helm status` | Show release status |
| `hh` | `helm history` | Show release history |
| `hr` | `helm rollback` | Rollback release |
| `hrepo` | `helm repo` | Manage repositories |
| `hrepol` | `helm repo list` | List repositories |
| `hrepou` | `helm repo update` | Update repositories |
| `hsearch` | `helm search` | Search charts |
| `hshow` | `helm show` | Show chart info |

---

## 📊 System & Monitoring Aliases

### Process Management
| Alias | Full Command | Description |
|-------|-------------|-------------|
| `psg` | `ps aux \| grep -v grep \| grep -i -e VSZ -e` | Search processes |
| `topcpu` | `ps aux --sort=-%cpu \| head -n 10` | Top CPU processes |
| `topmem` | `ps aux --sort=-%mem \| head -n 10` | Top memory processes |

### Disk Usage
| Alias | Full Command | Description |
|-------|-------------|-------------|
| `duf` | `du -sh * \| sort -hr` | Disk usage sorted |
| `duh` | `du -h --max-depth=1 \| sort -hr` | Disk usage (1 level) |

### Network
| Alias | Full Command | Description |
|-------|-------------|-------------|
| `ports` | `netstat -tulanp` | Show all ports |
| `listening` | `netstat -tlnp` | Show listening ports |
| `myip` | `curl -s ifconfig.me` | Show public IP |
| `openports` | `sudo lsof -i -P -n \| grep LISTEN` | Show open ports |

### System Info
| Alias | Full Command | Description |
|-------|-------------|-------------|
| `sysinfo` | `uname -a && cat /etc/os-release` | Show system info |
| `cpuinfo` | `lscpu` | Show CPU info |
| `meminfo` | `free -h` | Show memory info |

---

## 🖥️ tmux Aliases

| Alias | Full Command | Description |
|-------|-------------|-------------|
| `t` | `tmux` | tmux shortcut |
| `ta` | `tmux attach -t` | Attach to session |
| `tls` | `tmux ls` | List sessions |
| `tn` | `tmux new -s` | New session |
| `tk` | `tmux kill-session -t` | Kill session |
| `tka` | `tmux kill-server` | Kill all sessions |

---

## ⚡ Modern CLI Tool Aliases

### File Listing (eza)
| Alias | Full Command | Description |
|-------|-------------|-------------|
| `ls` | `eza -lh --group-directories-first --icons=auto` | Better ls with icons |
| `lsa` | `ls -a` | List all including hidden |
| `lt` | `eza --tree --level=2 --long --icons --git` | Tree view with git status |
| `lta` | `lt -a` | Tree view with hidden files |

### Fuzzy Finding (fzf)
| Alias | Full Command | Description |
|-------|-------------|-------------|
| `ff` | `fzf --preview 'batcat --style=numbers --color=always {}'` | File search with preview |

### Find Files (fd)
| Alias | Full Command | Description |
|-------|-------------|-------------|
| `fd` | `fdfind` | Better find command |

### Navigation (zoxide)
| Alias | Full Command | Description |
|-------|-------------|-------------|
| `cd` | `z` | Smart cd (learns from history) |

### Better cat (bat)
| Alias | Command | Description |
|-------|---------|-------------|
| `cat` | `bat` | Cat with syntax highlighting |
| `ccat` | `/usr/bin/cat` | Original cat command |

### Better grep (ripgrep)
| Alias | Command | Description |
|-------|---------|-------------|
| `grep` | `rg` | Fast grep alternative |

---

## 📁 File Operations

| Alias | Full Command | Description |
|-------|-------------|-------------|
| `..` | `cd ..` | Go up one directory |
| `...` | `cd ../..` | Go up two directories |
| `....` | `cd ../../..` | Go up three directories |
| `~` | `cd ~` | Go to home directory |
| `-` | `cd -` | Go to previous directory |
| `cp` | `cp -iv` | Copy (interactive, verbose) |
| `mv` | `mv -iv` | Move (interactive, verbose) |
| `rm` | `rm -i` | Remove (interactive) |
| `mkdir` | `mkdir -pv` | Make directory (parents, verbose) |

---

## 🔧 Quick Edits

| Alias | Full Command | Description |
|-------|-------------|-------------|
| `bashrc` | `${EDITOR:-vim} ~/.bashrc` | Edit bashrc |
| `vimrc` | `${EDITOR:-vim} ~/.vimrc` | Edit vimrc |

---

## 🚀 CI/CD & GitHub Aliases

### GitHub CLI
| Alias | Full Command | Description |
|-------|-------------|-------------|
| `gh` | `gh` | GitHub CLI |
| `ghpr` | `gh pr` | Manage pull requests |
| `ghprc` | `gh pr create` | Create pull request |
| `ghprv` | `gh pr view` | View pull request |
| `ghprl` | `gh pr list` | List pull requests |
| `ghrepo` | `gh repo` | Manage repositories |
| `ghrepov` | `gh repo view` | View repository |

### GitLab CLI
| Alias | Full Command | Description |
|-------|-------------|-------------|
| `glab` | `glab` | GitLab CLI |
| `glmr` | `glab mr` | Manage merge requests |
| `glmrc` | `glab mr create` | Create merge request |
| `glmrv` | `glab mr view` | View merge request |

---

## 🔍 JSON/YAML Processing

| Alias | Full Command | Description |
|-------|-------------|-------------|
| `json` | `jq` | Process JSON |
| `yaml` | `yq` | Process YAML |
| `jsonp` | `jq .` | Pretty print JSON |

---

## 🛠️ Utility Aliases

| Alias | Full Command | Description |
|-------|-------------|-------------|
| `killp` | `pkill -f` | Kill process by name |
| `serve` | `python3 -m http.server` | Start HTTP server |
| `genpass` | `openssl rand -base64 32` | Generate random password |
| `watch` | `watch -n 2` | Watch command (2s interval) |
| `diff` | `colordiff` | Colorized diff (if available) |

---

## 🎯 Custom DevOps Functions

### Kubernetes Functions
```bash
klog <label>                    # Tail logs by label selector
kctxns <context> <namespace>    # Switch context and namespace
kresources <namespace>          # Get pod resources in namespace
kpfl <label> <port>             # Port forward by label
```

### Terraform Functions
```bash
tfplan                          # Plan and save to file
```

### Git Functions
```bash
gcpush "message"                # Add all, commit, and push
```

### Docker Functions
```bash
dcleanall                       # Stop and remove all containers
dbp <tag>                       # Build and push image
```

---

## 💡 Pro Tips

1. **Use Tab Completion**: Most aliases support tab completion
2. **Combine with Pipes**: All aliases work with pipes (|, >, <)
3. **Use with Watch**: `watch kgp` to continuously monitor pods
4. **Fuzzy Search**: Press `Ctrl+R` for command history search
5. **Context Switching**: Use `kctx` and `kcon` for quick k8s context changes
6. **Logs Following**: Use `-f` aliases (klf, dlf, dclf) for live log streaming

---

## 📝 Quick Reference Commands

```bash
# View this cheatsheet anytime
cheat

# List all aliases
alias

# Search for specific alias
alias | grep docker
alias | grep kubectl

# Reload shell configuration
source ~/.bashrc

# View installation log
cat ~/.devops-workspace-install.log
```

---

**Remember**: All these aliases are configured to save you time in your daily DevOps work!

Type `cheat` anytime to view this reference guide.
