#!/usr/bin/env bash

###############################################################################
# Generator Manager - Centralized management for all code generators
# Manages Dockerfile, Docker Compose, and other code generators
###############################################################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GENERATORS_DIR="$SCRIPT_DIR"
DOCKER_GENERATORS="$GENERATORS_DIR/docker"
TERRAFORM_GENERATORS="$GENERATORS_DIR/terraform"

# Colors for output
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Display header
display_header() {
    clear
    echo -e "${MAGENTA}"
    cat << "EOF"
╔════════════════════════════════════════════════════════════════════════╗
║                                                                        ║
║              DevOps Workspace - Generator Manager                      ║
║              Centralized Code & Configuration Generator               ║
║                                                                        ║
╚════════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

# Show usage
show_usage() {
    cat << EOF
Usage: generator-manager [COMMAND] [GENERATOR]

Commands:
    list                List all available generators
    docker              Run Dockerfile generator (interactive)
    docker-help         Show Dockerfile generator help
    terraform           Run Terraform generator (interactive)
    terraform-help      Show Terraform generator help
    check               Check installed generators
    info GENERATOR      Show generator information
    help                Show this help message

Generators Available:
    docker              Advanced Dockerfile generator (13+ frameworks)
    terraform           Infrastructure as Code generator (AWS EKS, GCP GKE, Azure AKS)

Examples:
    generator-manager list
    generator-manager docker
    generator-manager terraform
    generator-manager docker-help
    generator-manager terraform-help
    generator-manager check
    generator-manager info docker
    generator-manager info terraform

EOF
}

# List all available generators
list_generators() {
    echo -e "${MAGENTA}Available Generators:${NC}\n"

    echo -e "${CYAN}📦 Docker Generators:${NC}"
    echo "  • dockerfile-generator   - Generate optimized Dockerfiles"
    echo "                             Supports 13+ frameworks (Node, Python, PHP, Go, Java, Ruby, .NET)"
    echo "                             Multi-stage builds, healthchecks, non-root users"
    echo ""

    echo -e "${CYAN}☁️  Infrastructure Generators:${NC}"
    echo "  • terraform-generator    - Generate Terraform Infrastructure as Code"
    echo "                             Supports AWS EKS, GCP GKE, Azure AKS"
    echo "                             Modular architecture, networking, databases, monitoring"
    echo ""

    echo -e "${YELLOW}Coming Soon:${NC}"
    echo "  • kubernetes-generator   - Generate Kubernetes manifests"
    echo "  • helm-generator         - Generate Helm charts"
    echo "  • compose-generator      - Advanced Docker Compose configs"
    echo "  • config-generator       - Generate config templates"
    echo ""

    log_info "Place new generators in: $GENERATORS_DIR/<category>"
    log_info "Follow naming convention: <name>-generator.sh"
}

# Check installed generators
check_generators() {
    echo -e "${MAGENTA}Generator Status:${NC}\n"

    local found=0

    # Check Docker generators
    if [[ -d "$DOCKER_GENERATORS" ]]; then
        echo -e "${GREEN}✓ Docker Generators Directory:${NC} $DOCKER_GENERATORS"

        for generator in "$DOCKER_GENERATORS"/*-generator.sh; do
            if [[ -f "$generator" ]]; then
                if [[ -x "$generator" ]]; then
                    echo -e "  ${GREEN}✓${NC} $(basename "$generator") (executable)"
                else
                    echo -e "  ${YELLOW}!${NC} $(basename "$generator") (not executable)"
                    echo -e "      Run: chmod +x \"$generator\""
                fi
                ((found++))
            fi
        done
    else
        echo -e "${RED}✗ Docker Generators Directory not found${NC}"
    fi

    # Check Terraform generators
    if [[ -d "$TERRAFORM_GENERATORS" ]]; then
        echo -e "${GREEN}✓ Terraform Generators Directory:${NC} $TERRAFORM_GENERATORS"

        for generator in "$TERRAFORM_GENERATORS"/*-generator.sh; do
            if [[ -f "$generator" ]]; then
                if [[ -x "$generator" ]]; then
                    echo -e "  ${GREEN}✓${NC} $(basename "$generator") (executable)"
                else
                    echo -e "  ${YELLOW}!${NC} $(basename "$generator") (not executable)"
                    echo -e "      Run: chmod +x \"$generator\""
                fi
                ((found++))
            fi
        done
    else
        echo -e "${YELLOW}! Terraform Generators Directory not found${NC}"
    fi

    if [[ $found -eq 0 ]]; then
        log_warning "No generators found"
    else
        echo ""
        log_success "Found $found generator(s)"
    fi

    echo ""
    log_info "To add generators:"
    echo "  1. Create scripts in: $GENERATORS_DIR/<category>/"
    echo "  2. Name them: <name>-generator.sh"
    echo "  3. Make executable: chmod +x <name>-generator.sh"
    echo "  4. Re-run: generator-manager check"
}

# Show generator info
show_generator_info() {
    local generator=$1

    case "$generator" in
        terraform|tf|iac)
            cat << EOF
${MAGENTA}Terraform Infrastructure as Code Generator${NC}

${GREEN}Description:${NC}
  Advanced Terraform generator for production-ready cloud infrastructure
  supporting AWS EKS, GCP GKE, and Azure AKS with modular architecture.

${GREEN}Supported Cloud Providers:${NC}

  AWS (Amazon Web Services):
    • EKS (Elastic Kubernetes Service) clusters
    • VPC with public/private subnets
    • NAT Gateways for outbound connectivity
    • RDS (MySQL/PostgreSQL) databases
    • ElastiCache Redis clusters
    • Bastion hosts for secure access
    • Security groups and IAM roles

  GCP (Google Cloud Platform):
    • GKE (Google Kubernetes Engine) clusters
    • Virtual networks and subnets
    • Cloud SQL databases
    • Cloud Memorystore Redis
    • Custom machine types

  Azure (Microsoft Azure):
    • AKS (Azure Kubernetes Service) clusters
    • Virtual networks and subnets
    • Azure Database for MySQL/PostgreSQL
    • Azure Cache for Redis
    • Resource groups and network policies

${GREEN}Features:${NC}
  ✓ Modular Terraform architecture
  ✓ Infrastructure as Code (IaC) best practices
  ✓ Multi-cloud support (AWS, GCP, Azure)
  ✓ Automated networking setup
  ✓ Database provisioning options
  ✓ Redis/cache cluster support
  ✓ Bastion host configuration
  ✓ Security groups and policies
  ✓ IAM roles and permissions
  ✓ OIDC provider setup (IRSA)
  ✓ Auto-scaling configuration
  ✓ Comprehensive README generation
  ✓ Helper scripts for deployment
  ✓ Terraform backend configuration
  ✓ State management with locking

${GREEN}Usage:${NC}
  generator-manager terraform

${GREEN}Output Files:${NC}
  • terraform/<provider>/main.tf
  • terraform/<provider>/variables.tf
  • terraform/<provider>/outputs.tf
  • terraform/<provider>/terraform.tfvars
  • terraform/<provider>/backend.hcl
  • terraform/<provider>/README.md
  • terraform/<provider>/scripts/deploy.sh
  • terraform/<provider>/scripts/destroy.sh
  • terraform/<provider>/scripts/setup-kubectl.sh
  • terraform/<provider>/modules/vpc/
  • terraform/<provider>/modules/eks/ (AWS)
  • terraform/<provider>/modules/rds/
  • terraform/<provider>/modules/elasticache/
  • terraform/<provider>/modules/bastion/

${GREEN}Interactive Setup:${NC}
  1. Select cloud provider (AWS, GCP, Azure)
  2. Configure basic settings:
     - Project name
     - Environment (production, staging, dev)
     - Region/location
     - Node count
     - Kubernetes version
  3. Configure optional resources:
     - Managed database (MySQL/PostgreSQL)
     - Redis cache cluster
     - Monitoring (Prometheus/Grafana)
     - Bastion host for secure access

${YELLOW}Notes:${NC}
  • Generates production-ready IaC
  • Includes modular architecture
  • Supports multi-region deployments
  • Automatically configures networking
  • Creates comprehensive documentation
  • Helper scripts for easy deployment
  • Terraform state management included

EOF
            ;;
        docker|dockerfile)
            cat << EOF
${MAGENTA}Dockerfile Generator${NC}

${GREEN}Description:${NC}
  Advanced Dockerfile generator supporting 13+ frameworks with
  production-ready configurations and best practices.

${GREEN}Supported Frameworks:${NC}

  JavaScript/TypeScript:
    • React (Create React App / Vite)
    • Next.js (SSR/SSG)
    • Vue.js (Vue CLI / Vite)
    • Nuxt.js (SSR/SSG Vue)
    • Angular
    • Express.js
    • Nest.js
    • Node.js (Generic)

  Python:
    • Django
    • Flask
    • FastAPI
    • Streamlit
    • Tornado
    • Python (Generic)

  PHP:
    • Laravel
    • Symfony
    • CodeIgniter
    • WordPress
    • PHP (Generic)

  Go:
    • Gin
    • Echo
    • Fiber
    • Go (Generic)

  Java:
    • Spring Boot
    • Quarkus
    • Micronaut
    • Java (Generic)

  Ruby:
    • Ruby on Rails
    • Sinatra
    • Ruby (Generic)

  .NET Core:
    • ASP.NET Core (Web API)
    • ASP.NET Core MVC
    • Blazor
    • .NET (Generic)

${GREEN}Features:${NC}
  ✓ Multi-stage builds for optimized images
  ✓ Healthcheck configuration
  ✓ Non-root user support (security)
  ✓ Framework-specific optimizations
  ✓ Nginx reverse proxy support
  ✓ Docker Compose generation
  ✓ Environment configuration
  ✓ Security best practices
  ✓ Production-ready Dockerfiles
  ✓ Framework-specific nginx configs
  ✓ Comprehensive README generation
  ✓ .dockerignore templates

${GREEN}Usage:${NC}
  generator-manager docker

${GREEN}Output Files:${NC}
  • Dockerfile (optimized for selected framework)
  • docker-compose.yml (with database support)
  • .dockerignore (common patterns)
  • DOCKER_README.md (detailed instructions)
  • nginx/nginx.conf (if applicable)
  • requirements.txt.example (Python frameworks)
  • docker/nginx/*.conf (Laravel)
  • docker/supervisor/*.conf (Laravel)

${GREEN}Interactive Setup:${NC}
  1. Select programming language
  2. Choose framework
  3. Configure options:
     - Nginx reverse proxy
     - Multi-stage build
     - Healthcheck
     - Non-root user
     - Application port

${YELLOW}Notes:${NC}
  • Supports 13+ frameworks with framework-specific optimizations
  • Automatically configures ports, build directories, and commands
  • Generates production-ready configurations
  • Includes Docker Compose with database support
  • Creates comprehensive documentation

EOF
            ;;
        *)
            log_error "Unknown generator: $generator"
            echo "Available generators: docker, terraform"
            return 1
            ;;
    esac
}

# Run Docker generator
run_docker_generator() {
    if [[ ! -f "$DOCKER_GENERATORS/dockerfile-generator.sh" ]]; then
        log_error "Dockerfile generator not found"
        echo "Expected: $DOCKER_GENERATORS/dockerfile-generator.sh"
        return 1
    fi

    if [[ ! -x "$DOCKER_GENERATORS/dockerfile-generator.sh" ]]; then
        chmod +x "$DOCKER_GENERATORS/dockerfile-generator.sh"
    fi

    log_info "Starting Dockerfile Generator..."
    echo ""
    "$DOCKER_GENERATORS/dockerfile-generator.sh"
}

# Run Terraform generator
run_terraform_generator() {
    if [[ ! -f "$TERRAFORM_GENERATORS/terraform-generator.sh" ]]; then
        log_error "Terraform generator not found"
        echo "Expected: $TERRAFORM_GENERATORS/terraform-generator.sh"
        return 1
    fi

    if [[ ! -x "$TERRAFORM_GENERATORS/terraform-generator.sh" ]]; then
        chmod +x "$TERRAFORM_GENERATORS/terraform-generator.sh"
    fi

    log_info "Starting Terraform Generator..."
    echo ""
    "$TERRAFORM_GENERATORS/terraform-generator.sh"
}

# Show terraform generator help
terraform_generator_help() {
    cat << EOF
${MAGENTA}Advanced Terraform Infrastructure as Code Generator${NC}

${GREEN}Description:${NC}
Generate production-ready Terraform configurations for AWS EKS, GCP GKE,
and Azure AKS clusters with modular architecture and best practices.

${GREEN}Supported Cloud Providers:${NC}
  1. AWS - EKS with VPC, RDS, ElastiCache, Bastion
  2. GCP - GKE with custom VPCs and databases
  3. Azure - AKS with resource groups and networks

${GREEN}Features:${NC}
  • Multi-cloud infrastructure support
  • Modular Terraform configuration
  • Automated networking setup
  • Database and cache provisioning
  • Security groups and IAM roles
  • Bastion host configuration
  • Auto-scaling settings
  • Comprehensive documentation
  • Helper deployment scripts
  • Terraform backend configuration

${GREEN}Generated Files:${NC}
  1. main.tf - Cloud provider configuration
  2. variables.tf - Input variables
  3. outputs.tf - Output values
  4. terraform.tfvars - Variable values
  5. backend.hcl - State backend config
  6. README.md - Detailed instructions
  7. scripts/deploy.sh - Deployment script
  8. scripts/destroy.sh - Cleanup script
  9. scripts/setup-kubectl.sh - kubectl setup
  10. modules/* - Modular components (VPC, EKS, RDS, etc.)

${GREEN}Usage:${NC}
  generator-manager terraform

${GREEN}Quick Start:${NC}
  1. Run: generator-manager terraform
  2. Select your cloud provider
  3. Configure cluster settings:
     - Project name
     - Environment (dev/staging/production)
     - Region
     - Node count
     - Kubernetes version
  4. Choose optional components:
     - Database (MySQL/PostgreSQL)
     - Redis cache
     - Monitoring
     - Bastion host
  5. Review generated files
  6. Run: cd terraform/<provider> && terraform init && terraform apply

${GREEN}Best Practices:${NC}
  ✓ Configure cloud CLI before running (aws configure, gcloud auth, az login)
  ✓ Create S3 bucket for Terraform state (AWS)
  ✓ Review security groups before deployment
  ✓ Test with dev environment first
  ✓ Use terraform.tfvars for environment-specific values
  ✓ Enable state locking with DynamoDB/backend
  ✓ Set up monitoring and logging
  ✓ Plan before applying changes

${YELLOW}Tips:${NC}
  • Generated configs are production-ready
  • Customize to match your specific needs
  • All configurations are well-documented
  • Use helper scripts for automated deployment
  • Review README.md for detailed instructions

EOF
}

# Show docker generator help
docker_generator_help() {
    cat << EOF
${MAGENTA}Advanced Dockerfile Generator${NC}

${GREEN}Description:${NC}
Generate optimized Dockerfiles for 13+ frameworks with production-ready
configurations including multi-stage builds, healthchecks, and security best practices.

${GREEN}Supported Languages:${NC}
  1. JavaScript/TypeScript (Node.js)
     - React, Next.js, Vue, Nuxt, Angular
     - Express, Nest, Node.js

  2. Python
     - Django, Flask, FastAPI, Streamlit, Tornado

  3. PHP
     - Laravel, Symfony, CodeIgniter, WordPress

  4. Go
     - Gin, Echo, Fiber

  5. Java
     - Spring Boot, Quarkus, Micronaut

  6. Ruby
     - Rails, Sinatra

  7. .NET Core
     - ASP.NET Core, Blazor

${GREEN}Features:${NC}
  • Multi-stage builds (smaller images)
  • Framework-specific optimizations
  • Health checks configuration
  • Non-root user for security
  • Nginx reverse proxy support
  • Docker Compose templates
  • Environment variable management
  • Comprehensive documentation

${GREEN}Generated Files:${NC}
  1. Dockerfile - Optimized for your framework
  2. docker-compose.yml - Complete stack setup
  3. .dockerignore - Build optimization
  4. DOCKER_README.md - Detailed instructions
  5. nginx/nginx.conf - Reverse proxy config
  6. requirements.txt.example - Dependency template
  7. config files - Framework-specific configs

${GREEN}Usage:${NC}
  generator-manager docker

${GREEN}Quick Start:${NC}
  1. Run: generator-manager docker
  2. Select your language and framework
  3. Configure options (Nginx, multi-stage, healthcheck)
  4. Review generated files
  5. Run: docker-compose up --build

${GREEN}Best Practices:${NC}
  ✓ Always enable multi-stage builds
  ✓ Add healthchecks for monitoring
  ✓ Run as non-root user (security)
  ✓ Use .dockerignore for optimized builds
  ✓ Review DOCKER_README.md before deploying
  ✓ Test locally with docker-compose
  ✓ Scan images for vulnerabilities

${YELLOW}Tips:${NC}
  • Generated configs are production-ready
  • Customize to match your project needs
  • All templates are well-documented
  • Review security settings before deployment

EOF
}

# Main function
main() {
    case "${1:-}" in
        list)
            display_header
            list_generators
            ;;
        docker)
            run_docker_generator
            ;;
        docker-help)
            display_header
            docker_generator_help
            ;;
        terraform|tf)
            run_terraform_generator
            ;;
        terraform-help|tf-help)
            display_header
            terraform_generator_help
            ;;
        check)
            display_header
            check_generators
            ;;
        info)
            display_header
            show_generator_info "${2:-docker}"
            ;;
        help|""|--help|-h)
            display_header
            show_usage
            ;;
        *)
            display_header
            log_error "Unknown command: $1"
            echo ""
            show_usage
            return 1
            ;;
    esac
}

# Run main
main "$@"
