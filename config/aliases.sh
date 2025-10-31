#!/usr/bin/env bash

###############################################################################
# DevOps Workspace Aliases
# Practical aliases for DevOps engineers
###############################################################################

# ============================================================================
# Kubernetes Aliases
# ============================================================================

alias k='kubectl'
alias kgp='kubectl get pods'
alias kgpa='kubectl get pods --all-namespaces'
alias kgd='kubectl get deployments'
alias kgs='kubectl get services'
alias kgn='kubectl get nodes'
alias kgns='kubectl get namespaces'
alias kgpvc='kubectl get pvc'
alias kgpv='kubectl get pv'

# Describe resources
alias kdp='kubectl describe pod'
alias kdd='kubectl describe deployment'
alias kds='kubectl describe service'
alias kdn='kubectl describe node'

# Logs
alias kl='kubectl logs'
alias klf='kubectl logs -f'
alias klp='kubectl logs -p'  # Previous container logs

# Execute
alias kex='kubectl exec -it'
alias keti='kubectl exec -it'

# Edit resources
alias ked='kubectl edit deployment'
alias kes='kubectl edit service'
alias kecm='kubectl edit configmap'

# Apply and Delete
alias ka='kubectl apply -f'
alias kdel='kubectl delete'
alias kdelp='kubectl delete pod'

# Context and Config
alias kctx='kubectl config get-contexts'
alias kcon='kubectl config use-context'
alias kcn='kubectl config set-context --current --namespace'

# Port forwarding
alias kpf='kubectl port-forward'

# Top resources
alias ktop='kubectl top nodes'
alias ktopp='kubectl top pods'

# Rollout
alias kroll='kubectl rollout'
alias krollr='kubectl rollout restart'
alias krolls='kubectl rollout status'
alias krollu='kubectl rollout undo'

# Scale
alias kscale='kubectl scale deployment'

# Events
alias kge='kubectl get events --sort-by=.metadata.creationTimestamp'

# Watch
alias kw='kubectl get pods -w'

# ============================================================================
# Docker Aliases
# ============================================================================

alias d='docker'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias di='docker images'
alias dstop='docker stop'
alias drm='docker rm'
alias drmi='docker rmi'
alias dex='docker exec -it'
alias dl='docker logs'
alias dlf='docker logs -f'
alias dinspect='docker inspect'
alias dstats='docker stats'

# Docker compose
alias dc='docker-compose'
alias dcu='docker-compose up'
alias dcud='docker-compose up -d'
alias dcd='docker-compose down'
alias dcl='docker-compose logs'
alias dclf='docker-compose logs -f'
alias dcps='docker-compose ps'
alias dcr='docker-compose restart'
alias dcb='docker-compose build'
alias dce='docker-compose exec'

# Docker system
alias dprune='docker system prune -a'
alias dprunev='docker volume prune'
alias dprunen='docker network prune'
alias ddf='docker system df'

# Build and tag
alias db='docker build'
alias dbt='docker build -t'
alias dtag='docker tag'
alias dpush='docker push'
alias dpull='docker pull'

# ============================================================================
# Terraform Aliases
# ============================================================================

alias tf='terraform'
alias tfi='terraform init'
alias tfp='terraform plan'
alias tfa='terraform apply'
alias tfaa='terraform apply -auto-approve'
alias tfd='terraform destroy'
alias tfda='terraform destroy -auto-approve'
alias tfs='terraform show'
alias tfv='terraform validate'
alias tff='terraform fmt'
alias tfr='terraform refresh'
alias tfo='terraform output'
alias tfsl='terraform state list'
alias tfss='terraform state show'
alias tfws='terraform workspace'
alias tfwsl='terraform workspace list'
alias tfwss='terraform workspace select'

# ============================================================================
# Ansible Aliases
# ============================================================================

alias ans='ansible'
alias ansp='ansible-playbook'
alias ansv='ansible-vault'
alias ansi='ansible-inventory'
alias ansg='ansible-galaxy'
alias ansc='ansible-config'
alias ansd='ansible-doc'

# Ansible playbook with common options
alias anspv='ansible-playbook --check --diff'  # Dry run
alias anspl='ansible-playbook --list-tasks'
alias ansph='ansible-playbook --list-hosts'

# ============================================================================
# Git Aliases
# ============================================================================

alias g='git'
alias gs='git status'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gp='git push'
alias gpl='git pull'
alias gf='git fetch'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gb='git branch'
alias gbd='git branch -d'
alias gbD='git branch -D'
alias gm='git merge'
alias gr='git rebase'
alias gri='git rebase -i'
alias gl='git log --oneline --graph --decorate'
alias gla='git log --oneline --graph --decorate --all'
alias gd='git diff'
alias gdc='git diff --cached'
alias gst='git stash'
alias gstp='git stash pop'
alias gstl='git stash list'
alias grs='git reset'
alias grh='git reset --hard'
alias gcp='git cherry-pick'
alias gclean='git clean -fd'
alias gtag='git tag'

# ============================================================================
# AWS CLI Aliases
# ============================================================================

alias aws='aws'
alias awsp='aws --profile'
alias awsr='aws --region'

# EC2
alias ec2-ls='aws ec2 describe-instances --query "Reservations[*].Instances[*].[InstanceId,State.Name,InstanceType,PublicIpAddress,Tags[?Key=='"'Name'"'].Value|[0]]" --output table'
alias ec2-start='aws ec2 start-instances --instance-ids'
alias ec2-stop='aws ec2 stop-instances --instance-ids'

# S3
alias s3-ls='aws s3 ls'
alias s3-cp='aws s3 cp'
alias s3-sync='aws s3 sync'
alias s3-rb='aws s3 rb'
alias s3-mb='aws s3 mb'

# ECS
alias ecs-ls='aws ecs list-clusters'
alias ecs-tasks='aws ecs list-tasks --cluster'
alias ecs-services='aws ecs list-services --cluster'

# ECR
alias ecr-login='aws ecr get-login-password | docker login --username AWS --password-stdin'
alias ecr-ls='aws ecr describe-repositories'

# Lambda
alias lambda-ls='aws lambda list-functions'
alias lambda-invoke='aws lambda invoke'

# CloudWatch Logs
alias cw-groups='aws logs describe-log-groups'
alias cw-streams='aws logs describe-log-streams --log-group-name'
alias cw-tail='aws logs tail'

# ============================================================================
# Helm Aliases
# ============================================================================

alias h='helm'
alias hl='helm list'
alias hla='helm list --all-namespaces'
alias hi='helm install'
alias hup='helm upgrade'
alias hupi='helm upgrade --install'
alias hdel='helm delete'
alias hs='helm status'
alias hh='helm history'
alias hr='helm rollback'
alias hrepo='helm repo'
alias hrepol='helm repo list'
alias hrepou='helm repo update'
alias hsearch='helm search'
alias hshow='helm show'

# ============================================================================
# System & Monitoring Aliases
# ============================================================================

# Process management
alias psg='ps aux | grep -v grep | grep -i -e VSZ -e'
alias topcpu='ps aux --sort=-%cpu | head -n 10'
alias topmem='ps aux --sort=-%mem | head -n 10'

# Disk usage
alias duf='du -sh * | sort -hr'
alias duh='du -h --max-depth=1 | sort -hr'

# Network
alias ports='netstat -tulanp'
alias listening='netstat -tlnp'
alias myip='curl -s ifconfig.me'
alias openports='sudo lsof -i -P -n | grep LISTEN'

# System info
alias sysinfo='uname -a && cat /etc/os-release'
alias cpuinfo='lscpu'
alias meminfo='free -h'

# ============================================================================
# tmux Aliases
# ============================================================================

alias t='tmux'
alias ta='tmux attach -t'
alias tls='tmux ls'
alias tn='tmux new -s'
alias tk='tmux kill-session -t'
alias tka='tmux kill-server'

# ============================================================================
# Productivity Aliases
# ============================================================================

# Better ls with eza
if command -v eza &> /dev/null; then
    alias ls='eza -lh --group-directories-first --icons=auto'
    alias lsa='ls -a'
    alias lt='eza --tree --level=2 --long --icons --git'
    alias lta='lt -a'
else
    alias ll='ls -lah'
    alias la='ls -A'
fi

# Better cat with bat
if command -v bat &> /dev/null; then
    alias cat='bat'
    alias ccat='/usr/bin/cat'  # Original cat
fi

# Better find with fd
if command -v fd &> /dev/null; then
    alias fd='fdfind'
fi

# fzf with bat preview
if command -v fzf &> /dev/null && command -v bat &> /dev/null; then
    alias ff="fzf --preview 'batcat --style=numbers --color=always {}'"
elif command -v fzf &> /dev/null; then
    alias ff="fzf --preview 'cat {}'"
fi

# Better grep with ripgrep
if command -v rg &> /dev/null; then
    alias grep='rg'
fi

# zoxide (modern cd)
if command -v zoxide &> /dev/null; then
    alias cd='z'
fi

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias -- -='cd -'

# File operations
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -i'
alias mkdir='mkdir -pv'

# Quick edits
alias bashrc='${EDITOR:-vim} ~/.bashrc'
alias vimrc='${EDITOR:-vim} ~/.vimrc'

# ============================================================================
# CI/CD & GitHub Aliases
# ============================================================================

alias gh='gh'
alias ghpr='gh pr'
alias ghprc='gh pr create'
alias ghprv='gh pr view'
alias ghprl='gh pr list'
alias ghrepo='gh repo'
alias ghrepov='gh repo view'

# GitLab
alias glab='glab'
alias glmr='glab mr'
alias glmrc='glab mr create'
alias glmrv='glab mr view'

# ============================================================================
# JSON/YAML Processing
# ============================================================================

alias json='jq'
alias yaml='yq'
alias jsonp='jq . '  # Pretty print JSON

# ============================================================================
# Quick Functions (as aliases)
# ============================================================================

# Find process by name and kill
alias killp='pkill -f'

# Quick HTTP server
alias serve='python3 -m http.server'

# Generate random password
alias genpass='openssl rand -base64 32'

# Watch with 2 second interval
alias watch='watch -n 2'

# Colorized diff
if command -v colordiff &> /dev/null; then
    alias diff='colordiff'
fi

# ============================================================================
# Custom DevOps Functions
# ============================================================================

# Get pod logs by label
klog() {
    kubectl logs -l "$1" --tail=100 -f
}

# Quick context switch with namespace
kctxns() {
    kubectl config use-context "$1" && kubectl config set-context --current --namespace="$2"
}

# Docker cleanup all
dcleanall() {
    docker stop $(docker ps -aq) 2>/dev/null
    docker rm $(docker ps -aq) 2>/dev/null
    docker rmi $(docker images -q) 2>/dev/null
    docker volume rm $(docker volume ls -q) 2>/dev/null
}

# Get all pods in namespace with resource usage
kresources() {
    local ns=${1:-default}
    kubectl top pods -n "$ns" --containers
}

# Port forward to pod by label
kpfl() {
    local label=$1
    local port=$2
    kubectl port-forward $(kubectl get pod -l "$label" -o jsonpath='{.items[0].metadata.name}') "$port"
}

# Terraform plan with color and save
tfplan() {
    terraform plan -out=tfplan "$@" && terraform show -no-color tfplan > tfplan.txt
}

# Git commit and push in one command
gcpush() {
    git add -A && git commit -m "$1" && git push
}

# Docker build and push
dbp() {
    local tag=$1
    docker build -t "$tag" . && docker push "$tag"
}

echo "✅ DevOps aliases loaded! Type 'alias' to see all available shortcuts."
