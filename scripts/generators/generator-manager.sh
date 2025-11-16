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
KUBERNETES_GENERATORS="$GENERATORS_DIR/kubernetes"
CICD_GENERATORS="$GENERATORS_DIR/cicd"
HELM_GENERATORS="$GENERATORS_DIR/helm"
OBSERVABILITY_GENERATORS="$GENERATORS_DIR/observability"

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
    kubernetes          Run Kubernetes manifest generator (interactive)
    kubernetes-help     Show Kubernetes generator help
    cicd                Run CI/CD pipeline generator (interactive)
    cicd-help           Show CI/CD generator help
    helm                Run Helm chart generator (interactive)
    helm-help           Show Helm generator help
    observability       Run observability stack generator (interactive)
    observability-help  Show observability generator help
    check               Check installed generators
    info GENERATOR      Show generator information
    help                Show this help message

Generators Available:
    docker              Advanced Dockerfile generator (13+ frameworks)
    terraform           Infrastructure as Code generator (AWS EKS, GCP GKE, Azure AKS)
    kubernetes          Kubernetes manifest generator (production-ready configs)
    cicd                CI/CD pipeline generator (GitHub, GitLab, Jenkins, Azure, CircleCI)
    helm                Helm chart generator (multi-environment Kubernetes packages)
    observability       Monitoring & observability stack generator (Prometheus, Grafana, ELK, Jaeger)

Examples:
    generator-manager list
    generator-manager docker
    generator-manager terraform
    generator-manager kubernetes
    generator-manager cicd
    generator-manager helm
    generator-manager observability
    generator-manager docker-help
    generator-manager terraform-help
    generator-manager kubernetes-help
    generator-manager cicd-help
    generator-manager helm-help
    generator-manager observability-help
    generator-manager check
    generator-manager info docker
    generator-manager info terraform
    generator-manager info kubernetes
    generator-manager info cicd
    generator-manager info helm
    generator-manager info observability

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

    echo -e "${CYAN}🚀 Kubernetes Generators:${NC}"
    echo "  • k8s-manifest-generator - Generate Kubernetes manifests"
    echo "                             Deployments, services, ingress, ConfigMaps, Secrets"
    echo "                             HPA, RBAC, resource limits, health checks"
    echo ""

    echo -e "${CYAN}⚙️  CI/CD Generators:${NC}"
    echo "  • cicd-generator         - Generate CI/CD pipelines"
    echo "                             GitHub Actions, GitLab CI/CD, Jenkins, Azure DevOps, CircleCI"
    echo "                             Testing, security scanning, Docker builds, K8s deployment"
    echo ""

    echo -e "${CYAN}📦 Package Management:${NC}"
    echo "  • helm-generator         - Generate Helm charts"
    echo "                             Multi-environment support, values templates, dependencies"
    echo "                             Ingress, HPA, RBAC, ServiceMonitor, PDB"
    echo ""

    echo -e "${CYAN}📊 Observability:${NC}"
    echo "  • observability-generator - Generate monitoring & observability stack"
    echo "                             Prometheus, Grafana, ELK, Loki, Jaeger, AlertManager"
    echo "                             Complete monitoring infrastructure, dashboards, alerts"
    echo ""

    echo -e "${YELLOW}Coming Soon:${NC}"
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

    # Check Kubernetes generators
    if [[ -d "$KUBERNETES_GENERATORS" ]]; then
        echo -e "${GREEN}✓ Kubernetes Generators Directory:${NC} $KUBERNETES_GENERATORS"

        for generator in "$KUBERNETES_GENERATORS"/*-generator.sh; do
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
        echo -e "${YELLOW}! Kubernetes Generators Directory not found${NC}"
    fi

    # Check CI/CD generators
    if [[ -d "$CICD_GENERATORS" ]]; then
        echo -e "${GREEN}✓ CI/CD Generators Directory:${NC} $CICD_GENERATORS"

        for generator in "$CICD_GENERATORS"/*-generator.sh; do
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
        echo -e "${YELLOW}! CI/CD Generators Directory not found${NC}"
    fi

    # Check Helm generators
    if [[ -d "$HELM_GENERATORS" ]]; then
        echo -e "${GREEN}✓ Helm Generators Directory:${NC} $HELM_GENERATORS"

        for generator in "$HELM_GENERATORS"/*-generator.sh; do
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
        echo -e "${YELLOW}! Helm Generators Directory not found${NC}"
    fi

    # Check Observability generators
    if [[ -d "$OBSERVABILITY_GENERATORS" ]]; then
        echo -e "${GREEN}✓ Observability Generators Directory:${NC} $OBSERVABILITY_GENERATORS"

        for generator in "$OBSERVABILITY_GENERATORS"/*-generator.sh; do
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
        echo -e "${YELLOW}! Observability Generators Directory not found${NC}"
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
        observability|monitoring|obs)
            cat << EOF
${MAGENTA}Observability & Monitoring Stack Generator${NC}

${GREEN}Description:${NC}
  Advanced observability stack generator for complete monitoring infrastructure
  with metrics, logs, traces, and alerting capabilities.

${GREEN}Supported Stack Components:${NC}

  Metrics & Visualization:
    • Prometheus (metrics collection)
    • Grafana (visualization and dashboards)
    • AlertManager (alert routing and management)
    • Custom dashboards for Kubernetes

  Logging Solutions:
    • ELK Stack (Elasticsearch, Logstash, Kibana)
    • EFK Stack (Elasticsearch, Fluent Bit, Kibana)
    • Loki (log aggregation for Kubernetes)

  Distributed Tracing:
    • Jaeger (end-to-end tracing)
    • Tempo (scalable tracing backend)
    • OpenTelemetry instrumentation

${GREEN}Features:${NC}
  ✓ Complete observability stack generation
  ✓ Multi-component configurations
  ✓ Kubernetes-native deployments
  ✓ Pre-configured dashboards
  ✓ Alert rules and notification setup
  ✓ Log aggregation and analysis
  ✓ Distributed tracing support
  ✓ Storage configuration
  ✓ Retention policies
  ✓ High-availability setup
  ✓ Integration with existing systems
  ✓ Comprehensive documentation

${GREEN}Usage:${NC}
  generator-manager observability

${GREEN}Output Structure:${NC}
  • prometheus/ - Prometheus configuration
  • grafana/ - Grafana dashboards and datasources
  • alertmanager/ - Alert rules and routing
  • logging/ - ELK/EFK or Loki configuration
  • tracing/ - Jaeger/Tempo configuration
  • kubernetes/ - K8s manifests for full stack
  • helm-charts/ - Helm charts for components
  • docker-compose.yml - Local deployment
  • README.md - Complete documentation

${GREEN}Interactive Setup:${NC}
  1. Choose stack type (complete, metrics, logging, tracing)
  2. Select deployment method (Kubernetes, Docker Compose)
  3. Choose logging backend (ELK, EFK, Loki)
  4. Choose tracing backend (Jaeger, Tempo)
  5. Configure storage and retention
  6. Set up alerting rules
  7. Configure dashboards

${YELLOW}Notes:${NC}
  • Generates production-ready configurations
  • Multi-component support
  • Fully integrated observability
  • Comprehensive documentation
  • Ready for production deployment

EOF
            ;;
        helm|chart)
            cat << EOF
${MAGENTA}Helm Chart Generator${NC}

${GREEN}Description:${NC}
  Advanced Helm chart generator for production-ready Kubernetes package management
  with multi-environment support and comprehensive templating.

${GREEN}Supported Application Types:${NC}

  Web Applications:
    • Frontend applications (React, Vue, Angular)
    • Full-stack applications
    • Static site hosting

  Microservices:
    • API services
    • RESTful services
    • gRPC services

  Backend Services:
    • Worker services
    • Job processors
    • Background tasks

  Stateful Applications:
    • Databases (PostgreSQL, MySQL, MongoDB)
    • Cache systems (Redis)
    • Message brokers

  Scheduled Tasks:
    • CronJobs
    • Periodic tasks
    • Batch processing

${GREEN}Features:${NC}
  ✓ Multi-environment values (dev, staging, prod)
  ✓ Production-ready chart structure
  ✓ Helm dependency management
  ✓ ConfigMap and Secret templating
  ✓ Service and Ingress configuration
  ✓ Horizontal Pod Autoscaler (HPA)
  ✓ Pod Disruption Budgets (PDB)
  ✓ RBAC and ServiceAccount support
  ✓ ServiceMonitor for Prometheus
  ✓ Health checks and probes
  ✓ Resource requests and limits
  ✓ Container image management
  ✓ Chart versioning
  ✓ Comprehensive documentation

${GREEN}Usage:${NC}
  generator-manager helm

${GREEN}Output Structure:${NC}
  • Chart.yaml - Chart metadata
  • values.yaml - Default values
  • values-dev.yaml - Development values
  • values-staging.yaml - Staging values
  • values-prod.yaml - Production values
  • templates/deployment.yaml
  • templates/service.yaml
  • templates/ingress.yaml
  • templates/hpa.yaml
  • templates/pdb.yaml
  • templates/configmap.yaml
  • templates/secret.yaml
  • templates/rbac.yaml
  • templates/_helpers.tpl
  • README.md - Chart documentation

${GREEN}Interactive Setup:${NC}
  1. Enter chart name and versions
  2. Select application type
  3. Configure image details
  4. Set service configuration
  5. Choose optional features:
     - Ingress with TLS
     - HPA for auto-scaling
     - PDB for disruption handling
     - ServiceMonitor for monitoring
     - Database support
     - Redis support
  6. Configure multiple environments

${YELLOW}Notes:${NC}
  • Generates production-ready charts
  • Multi-environment support
  • Follows Helm best practices
  • Full dependency support
  • Complete documentation
  • Ready for Helm registry

EOF
            ;;
        cicd|ci-cd|pipeline)
            cat << EOF
${MAGENTA}CI/CD Pipeline Generator${NC}

${GREEN}Description:${NC}
  Advanced CI/CD pipeline generator supporting 5 major platforms
  with production-ready configurations and best practices.

${GREEN}Supported CI/CD Platforms:${NC}

  GitHub Actions:
    • Workflow automation
    • Multi-environment deployments
    • Docker image building and pushing
    • Kubernetes deployment
    • PR/issue automation

  GitLab CI/CD:
    • Complete pipeline stages
    • Docker container registry
    • Kubernetes integration
    • Artifact management
    • Environment-based deployment

  Jenkins:
    • Declarative pipelines
    • Multi-stage builds
    • Docker integration
    • Kubernetes deployment
    • Post-build actions

  Azure DevOps:
    • Multi-stage YAML pipelines
    • Azure Container Registry
    • Azure Kubernetes Service integration
    • Release management
    • Environment approvals

  CircleCI:
    • Job-based workflows
    • Docker executors
    • Kubernetes deployment
    • Artifact storage
    • Approval workflows

${GREEN}Features:${NC}
  ✓ Multi-platform pipeline generation
  ✓ Automated testing (unit, integration)
  ✓ Linting and code quality checks
  ✓ Security scanning (SAST)
  ✓ Dependency scanning
  ✓ Docker image building
  ✓ Image registry pushing
  ✓ Kubernetes deployment
  ✓ Environment management (dev/staging/prod)
  ✓ Health checks and smoke tests
  ✓ Rollback capabilities
  ✓ Notifications and reporting
  ✓ SonarQube integration
  ✓ Container scanning
  ✓ Comprehensive documentation

${GREEN}Usage:${NC}
  generator-manager cicd

${GREEN}Output Files:${NC}
  • .github/workflows/*.yml (GitHub Actions)
  • .gitlab-ci.yml (GitLab CI/CD)
  • Jenkinsfile (Jenkins)
  • azure-pipelines.yml (Azure DevOps)
  • .circleci/config.yml (CircleCI)
  • README.md - Pipeline documentation
  • scripts/deploy.sh - Deployment helper
  • scripts/rollback.sh - Rollback helper

${GREEN}Interactive Setup:${NC}
  1. Select CI/CD platform(s)
  2. Configure project details
  3. Select programming language
  4. Choose deployment method
  5. Configure environment variables
  6. Enable optional features:
     - Testing frameworks
     - Code quality checks
     - Security scanning
     - SonarQube integration

${YELLOW}Notes:${NC}
  • Generates production-ready pipelines
  ✓ Supports multiple platforms
  • Includes security scanning
  • Automatic Docker builds
  • Kubernetes deployment ready
  • Complete documentation

EOF
            ;;
        kubernetes|k8s|k8s-manifest)
            cat << EOF
${MAGENTA}Kubernetes Manifest Generator${NC}

${GREEN}Description:${NC}
  Advanced Kubernetes manifest generator for production-ready deployments
  with comprehensive configuration options and best practices.

${GREEN}Supported Resources:${NC}

  Core Resources:
    • Deployments (with replicas and update strategies)
    • StatefulSets (for stateful applications)
    • Services (ClusterIP, NodePort, LoadBalancer)
    • ConfigMaps (application configuration)
    • Secrets (sensitive data management)

  Advanced Resources:
    • Ingress (HTTP/HTTPS routing with TLS)
    • Horizontal Pod Autoscaler (HPA)
    • PersistentVolumeClaims (data persistence)
    • RBAC (Role-Based Access Control)
    • NetworkPolicies (network security)

${GREEN}Features:${NC}
  ✓ Production-ready manifest generation
  ✓ Multi-application deployments
  ✓ Resource limits and requests
  ✓ Health checks (liveness & readiness probes)
  ✓ Horizontal auto-scaling (HPA)
  ✓ RBAC and service accounts
  ✓ Ingress with TLS support
  ✓ ConfigMaps and Secrets
  ✓ PersistentVolume support
  ✓ Environment variable management
  ✓ Image pull policies
  ✓ Namespace management

${GREEN}Usage:${NC}
  generator-manager kubernetes

${GREEN}Output Files:${NC}
  • namespace.yaml - Namespace definition
  • deployment.yaml - Application deployment
  • service.yaml - Service configuration
  • configmap.yaml - Configuration data
  • secret.yaml - Sensitive data
  • ingress.yaml - Ingress routing (if enabled)
  • hpa.yaml - Horizontal Pod Autoscaler (if enabled)
  • pvc.yaml - PersistentVolumeClaim (if enabled)
  • rbac.yaml - RBAC configuration (if enabled)
  • README.md - Deployment instructions

${GREEN}Interactive Setup:${NC}
  1. Enter application name and namespace
  2. Configure Docker image details
  3. Set container port and replica count
  4. Choose optional components:
     - Ingress with TLS
     - Horizontal Pod Autoscaler
     - PersistentVolume Claims
     - RBAC configuration
  5. Configure resource limits
  6. Enable/disable health checks

${YELLOW}Notes:${NC}
  • Generates production-ready manifests
  • Follows Kubernetes best practices
  • Includes health checks by default
  • Configurable resource limits
  • RBAC support for security
  • Complete documentation included

EOF
            ;;
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
            echo "Available generators: docker, terraform, kubernetes, cicd, helm, observability"
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

# Run Kubernetes generator
run_kubernetes_generator() {
    if [[ ! -f "$KUBERNETES_GENERATORS/k8s-manifest-generator.sh" ]]; then
        log_error "Kubernetes manifest generator not found"
        echo "Expected: $KUBERNETES_GENERATORS/k8s-manifest-generator.sh"
        return 1
    fi

    if [[ ! -x "$KUBERNETES_GENERATORS/k8s-manifest-generator.sh" ]]; then
        chmod +x "$KUBERNETES_GENERATORS/k8s-manifest-generator.sh"
    fi

    log_info "Starting Kubernetes Manifest Generator..."
    echo ""
    "$KUBERNETES_GENERATORS/k8s-manifest-generator.sh"
}

# Show kubernetes generator help
kubernetes_generator_help() {
    cat << EOF
${MAGENTA}Advanced Kubernetes Manifest Generator${NC}

${GREEN}Description:${NC}
Generate production-ready Kubernetes manifests with comprehensive
configuration options including deployments, services, ingress, HPA, and RBAC.

${GREEN}Supported Resources:${NC}
  • Deployments with replicas and update strategies
  • StatefulSets for stateful applications
  • Services (ClusterIP, NodePort, LoadBalancer)
  • ConfigMaps and Secrets
  • Ingress with TLS support
  • Horizontal Pod Autoscaler (HPA)
  • PersistentVolumeClaims (PVC)
  • RBAC (Roles, RoleBindings, ServiceAccounts)
  • NetworkPolicies

${GREEN}Features:${NC}
  • Production-ready manifests
  • Resource requests and limits
  • Health checks (liveness & readiness probes)
  • Auto-scaling configuration
  • RBAC and security policies
  • Ingress with TLS certificates
  • ConfigMaps for application config
  • Secrets for sensitive data
  • Data persistence options
  • Comprehensive documentation

${GREEN}Generated Files:${NC}
  1. namespace.yaml - Namespace definition
  2. deployment.yaml - Application deployment
  3. service.yaml - Service configuration
  4. configmap.yaml - Configuration data
  5. secret.yaml - Sensitive credentials
  6. ingress.yaml - Ingress routing (optional)
  7. hpa.yaml - Horizontal Pod Autoscaler (optional)
  8. pvc.yaml - Data persistence (optional)
  9. rbac.yaml - RBAC configuration (optional)
  10. README.md - Deployment guide

${GREEN}Usage:${NC}
  generator-manager kubernetes

${GREEN}Quick Start:${NC}
  1. Run: generator-manager kubernetes
  2. Provide application details:
     - App name, namespace
     - Docker image and tag
     - Container port and replicas
  3. Choose optional features:
     - Ingress (for external access)
     - HPA (for auto-scaling)
     - PVC (for data persistence)
     - RBAC (for access control)
  4. Configure resource limits
  5. Review generated manifests
  6. Deploy: kubectl apply -f k8s/

${GREEN}Best Practices:${NC}
  ✓ Always set resource limits
  ✓ Enable health checks
  ✓ Use ConfigMaps for config
  ✓ Use Secrets for credentials
  ✓ Enable RBAC in production
  ✓ Use network policies
  ✓ Enable HPA for scaling
  ✓ Test in dev before production

${YELLOW}Tips:${NC}
  • Generated manifests are production-ready
  • All configurations are well-documented
  • Customize to match your app needs
  • Review README for deployment steps
  • Use namespace for multi-tenancy

EOF
}

# Run CI/CD generator
run_cicd_generator() {
    if [[ ! -f "$CICD_GENERATORS/cicd-generator.sh" ]]; then
        log_error "CI/CD generator not found"
        echo "Expected: $CICD_GENERATORS/cicd-generator.sh"
        return 1
    fi

    if [[ ! -x "$CICD_GENERATORS/cicd-generator.sh" ]]; then
        chmod +x "$CICD_GENERATORS/cicd-generator.sh"
    fi

    log_info "Starting CI/CD Pipeline Generator..."
    echo ""
    "$CICD_GENERATORS/cicd-generator.sh"
}

# Show CI/CD generator help
cicd_generator_help() {
    cat << EOF
${MAGENTA}Advanced CI/CD Pipeline Generator${NC}

${GREEN}Description:${NC}
Generate production-ready CI/CD pipelines for GitHub Actions, GitLab CI/CD,
Jenkins, Azure DevOps, and CircleCI with automated testing and deployment.

${GREEN}Supported CI/CD Platforms:${NC}
  1. GitHub Actions - Workflow-based automation
  2. GitLab CI/CD - Stage-based pipelines
  3. Jenkins - Declarative pipelines
  4. Azure DevOps - Multi-stage YAML pipelines
  5. CircleCI - Job-based workflows

${GREEN}Features:${NC}
  • Multi-platform pipeline generation
  • Automated testing (unit, integration, e2e)
  • Code quality checks (linting, formatting)
  • Security scanning (SAST, dependency scanning)
  • Docker image building and registry push
  • Kubernetes deployment automation
  • Environment management (dev/staging/production)
  • Health checks and smoke tests
  • Rollback capabilities
  • Approval workflows
  • SonarQube integration
  • Container scanning
  • Comprehensive documentation

${GREEN}Generated Files:${NC}
  1. .github/workflows/ci-cd.yml - GitHub Actions
  2. .gitlab-ci.yml - GitLab CI/CD
  3. Jenkinsfile - Jenkins pipeline
  4. azure-pipelines.yml - Azure DevOps
  5. .circleci/config.yml - CircleCI
  6. scripts/deploy.sh - Deployment helper
  7. scripts/rollback.sh - Rollback helper
  8. README.md - Pipeline documentation

${GREEN}Usage:${NC}
  generator-manager cicd

${GREEN}Quick Start:${NC}
  1. Run: generator-manager cicd
  2. Select CI/CD platform (or all)
  3. Configure project details:
     - Project name
     - Repository URL
     - Programming language
  4. Choose deployment method:
     - Docker + Kubernetes
     - Cloud-native
     - Traditional VM
  5. Enable optional features:
     - Testing frameworks
     - Code quality checks
     - Security scanning
     - SonarQube
  6. Review generated pipeline files
  7. Push to repository and verify

${GREEN}Best Practices:${NC}
  ✓ Test pipelines in dev environment first
  ✓ Enable security scanning for all stages
  ✓ Use environment approvals for production
  ✓ Implement rollback capabilities
  ✓ Monitor pipeline execution
  ✓ Keep secrets in CI/CD vault
  ✓ Use semantic versioning
  ✓ Document pipeline stages

${YELLOW}Tips:${NC}
  • Generated pipelines are production-ready
  • All platforms fully integrated
  • Security scanning enabled by default
  • Container registry compatible
  • Kubernetes deployment ready
  • Complete documentation included

EOF
}

# Run Helm generator
run_helm_generator() {
    if [[ ! -f "$HELM_GENERATORS/helm-generator.sh" ]]; then
        log_error "Helm chart generator not found"
        echo "Expected: $HELM_GENERATORS/helm-generator.sh"
        return 1
    fi

    if [[ ! -x "$HELM_GENERATORS/helm-generator.sh" ]]; then
        chmod +x "$HELM_GENERATORS/helm-generator.sh"
    fi

    log_info "Starting Helm Chart Generator..."
    echo ""
    "$HELM_GENERATORS/helm-generator.sh"
}

# Show Helm generator help
helm_generator_help() {
    cat << EOF
${MAGENTA}Advanced Helm Chart Generator${NC}

${GREEN}Description:${NC}
Generate production-ready Helm charts with multi-environment support,
comprehensive templating, and Kubernetes package management best practices.

${GREEN}Supported Application Types:${NC}
  1. Web Applications (Frontend/Backend)
  2. Microservice APIs
  3. Worker/Job Processors
  4. Stateful Applications (Databases)
  5. Scheduled Tasks (CronJobs)

${GREEN}Features:${NC}
  • Multi-environment values (dev/staging/production)
  • Production-ready chart structure
  • Helm dependency management
  • ConfigMap and Secret templating
  • Service and Ingress configuration
  • Horizontal Pod Autoscaler (HPA)
  • Pod Disruption Budgets (PDB)
  • RBAC and ServiceAccount support
  • ServiceMonitor for Prometheus
  • Health checks and probes
  • Container image management
  • Chart versioning
  • Comprehensive documentation

${GREEN}Generated Files:${NC}
  1. Chart.yaml - Chart metadata
  2. values.yaml - Default values
  3. values-dev.yaml - Development environment
  4. values-staging.yaml - Staging environment
  5. values-prod.yaml - Production environment
  6. templates/deployment.yaml
  7. templates/service.yaml
  8. templates/ingress.yaml
  9. templates/hpa.yaml
  10. templates/pdb.yaml
  11. templates/configmap.yaml
  12. templates/secret.yaml
  13. templates/rbac.yaml
  14. README.md - Chart documentation

${GREEN}Usage:${NC}
  generator-manager helm

${GREEN}Quick Start:${NC}
  1. Run: generator-manager helm
  2. Enter chart name and versions
  3. Select application type
  4. Configure Docker image
  5. Set service details
  6. Choose optional features:
     - Ingress with TLS
     - Horizontal Pod Autoscaler
     - Pod Disruption Budgets
     - ServiceMonitor for monitoring
     - Database support
     - Redis support
  7. Configure multiple environment values
  8. Review generated chart
  9. Test with: helm install my-release ./my-chart
  10. Package with: helm package ./my-chart

${GREEN}Best Practices:${NC}
  ✓ Follow semantic versioning for charts
  ✓ Use appropriate resource limits
  ✓ Configure health checks
  ✓ Use ConfigMaps for configuration
  ✓ Use Secrets for sensitive data
  ✓ Enable RBAC for security
  ✓ Implement HPA for scaling
  ✓ Test charts thoroughly
  ✓ Document all values
  ✓ Use ServiceMonitor for observability

${YELLOW}Tips:${NC}
  • Generated charts are production-ready
  • Supports multiple environments
  • Complete Helm best practices included
  • Ready for Helm registries
  • Comprehensive documentation

EOF
}

# Run Observability generator
run_observability_generator() {
    if [[ ! -f "$OBSERVABILITY_GENERATORS/observability-generator.sh" ]]; then
        log_error "Observability generator not found"
        echo "Expected: $OBSERVABILITY_GENERATORS/observability-generator.sh"
        return 1
    fi

    if [[ ! -x "$OBSERVABILITY_GENERATORS/observability-generator.sh" ]]; then
        chmod +x "$OBSERVABILITY_GENERATORS/observability-generator.sh"
    fi

    log_info "Starting Observability Stack Generator..."
    echo ""
    "$OBSERVABILITY_GENERATORS/observability-generator.sh"
}

# Show observability generator help
observability_generator_help() {
    cat << EOF
${MAGENTA}Advanced Observability & Monitoring Stack Generator${NC}

${GREEN}Description:${NC}
Generate complete observability infrastructure with metrics, logs, traces,
and alerting for production Kubernetes environments.

${GREEN}Stack Options:${NC}
  1. Complete Stack - All components (Prometheus, Grafana, ELK, Jaeger, AlertManager)
  2. Metrics Only - Prometheus + Grafana + AlertManager
  3. Logging Only - ELK/EFK or Loki
  4. Tracing Only - Jaeger or Tempo
  5. Custom - Choose individual components

${GREEN}Supported Components:${NC}
  • Prometheus - Time-series metrics database
  • Grafana - Visualization and dashboards
  • AlertManager - Alert routing and grouping
  • Elasticsearch - Log storage and indexing
  • Kibana - Log visualization
  • Logstash/Fluent Bit - Log collection
  • Loki - Kubernetes-native log aggregation
  • Jaeger - Distributed tracing
  • Tempo - Scalable tracing backend

${GREEN}Features:${NC}
  • Production-ready configurations
  • Kubernetes manifests included
  • Helm charts for easy deployment
  • Pre-configured dashboards
  • Alert rules templates
  • Storage configuration
  • Retention policy setup
  • High-availability support
  • Multi-environment support
  • Docker Compose for local testing
  • Comprehensive documentation

${GREEN}Generated Files:${NC}
  1. prometheus/ - Prometheus config and rules
  2. grafana/ - Grafana dashboards
  3. alertmanager/ - Alert configuration
  4. logging/ - ELK/EFK or Loki setup
  5. tracing/ - Jaeger/Tempo configuration
  6. kubernetes/ - K8s manifests
  7. helm-charts/ - Helm charts
  8. docker-compose.yml - Local stack
  9. README.md - Documentation

${GREEN}Usage:${NC}
  generator-manager observability

${GREEN}Quick Start:${NC}
  1. Run: generator-manager observability
  2. Choose stack type (complete, metrics, logging, tracing, custom)
  3. Select deployment method (Kubernetes or Docker Compose)
  4. Choose logging backend (ELK, EFK, or Loki)
  5. Select tracing backend (Jaeger or Tempo)
  6. Configure storage and retention
  7. Set up alerting rules
  8. Review generated configurations
  9. Deploy to your environment

${GREEN}Best Practices:${NC}
  ✓ Start with complete stack in dev environment
  ✓ Separate metrics, logs, and traces storage
  ✓ Configure appropriate retention policies
  ✓ Set up meaningful alert rules
  ✓ Create custom dashboards for your apps
  ✓ Enable authentication in production
  ✓ Use persistent volumes for storage
  ✓ Monitor the monitoring stack itself
  ✓ Document all customizations
  ✓ Test alert routing and notifications

${YELLOW}Tips:${NC}
  • Generated configs are production-ready
  • Fully integrated observability stack
  • Supports Kubernetes and Docker Compose
  • Includes example dashboards
  • Pre-configured alert rules
  • Complete documentation

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
        kubernetes|k8s)
            run_kubernetes_generator
            ;;
        kubernetes-help|k8s-help)
            display_header
            kubernetes_generator_help
            ;;
        cicd|ci-cd)
            run_cicd_generator
            ;;
        cicd-help|ci-cd-help)
            display_header
            cicd_generator_help
            ;;
        helm)
            run_helm_generator
            ;;
        helm-help)
            display_header
            helm_generator_help
            ;;
        observability)
            run_observability_generator
            ;;
        observability-help)
            display_header
            observability_generator_help
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
