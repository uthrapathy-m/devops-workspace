# Code & Configuration Generators

Centralized management system for code and configuration generators in your DevOps workspace.

## Overview

This directory contains command-line generators for creating optimized configurations, Dockerfiles, Kubernetes manifests, and more. All generators follow best practices and production-ready standards.

## Directory Structure

```
generators/
├── generator-manager.sh          # Main generator management CLI
├── README.md                     # This file
├── docker/
│   ├── dockerfile-generator.sh   # Advanced Dockerfile generator
│   └── README.md                 # Docker generator docs
├── terraform/
│   ├── terraform-generator.sh    # Infrastructure-as-Code generator
│   └── README.md                 # Terraform generator docs
├── kubernetes/
│   ├── k8s-manifest-generator.sh # Kubernetes manifests generator
│   └── README.md                 # K8s generator docs
├── cicd/
│   ├── cicd-generator.sh         # CI/CD pipeline generator
│   └── README.md                 # CI/CD generator docs
├── helm/
│   ├── helm-generator.sh         # Helm charts generator
│   └── README.md                 # Helm generator docs
└── observability/
    ├── observability-generator.sh # Monitoring & observability generator
    ├── OBSERVABILITY-GUIDE.md     # Detailed observability guide
    ├── OBSERVABILITY-CHEATSHEET.md # Quick reference
    └── README.md                  # Observability generator docs
```

## Available Generators

### Docker Generators

**Dockerfile Generator** (`docker/dockerfile-generator.sh`)
- Generate production-ready Dockerfiles
- Support for 13+ frameworks
- Multi-stage builds
- Healthcheck configuration
- Non-root user setup
- Docker Compose generation

**Supported Frameworks:**
- JavaScript/TypeScript: React, Next.js, Vue, Nuxt, Angular, Express, Nest
- Python: Django, Flask, FastAPI, Streamlit, Tornado
- PHP: Laravel, Symfony, CodeIgniter, WordPress
- Go: Gin, Echo, Fiber
- Java: Spring Boot, Quarkus, Micronaut
- Ruby: Rails, Sinatra
- .NET Core: ASP.NET Core, Blazor

### Infrastructure-as-Code Generators

**Terraform Generator** (`terraform/terraform-generator.sh`)
- Generate production-ready Terraform configurations
- Support for multiple cloud providers (AWS, Azure, GCP)
- Module structure generation
- Variables and outputs configuration
- State management setup
- Best practices compliance

**Supported Providers:**
- AWS: EC2, RDS, S3, VPC, ALB, Lambda, SQS, SNS
- Azure: VMs, App Service, SQL Database, Storage, AKS
- GCP: Compute Engine, Cloud SQL, Cloud Storage, GKE
- DigitalOcean: Droplets, Databases, Spaces
- Kubernetes: Provider configuration and resources

### Kubernetes Generators

**Kubernetes Manifest Generator** (`kubernetes/k8s-manifest-generator.sh`)
- Generate production-ready Kubernetes manifests
- Support for common application patterns
- Deployment, Service, ConfigMap, Secret templates
- Ingress configuration
- RBAC setup
- Network policies
- Resource limits and requests

**Supported Patterns:**
- Web applications (stateless)
- Databases (stateful sets)
- Message queues
- Cache systems
- Microservices architecture

### CI/CD Pipeline Generators

**CI/CD Pipeline Generator** (`cicd/cicd-generator.sh`)
- Generate complete CI/CD pipeline configurations
- Support for multiple platforms
- Build, test, and deployment stages
- Docker image building and pushing
- Kubernetes deployment automation
- Secrets and credentials management
- Notifications and alerting

**Supported Platforms:**
- GitHub Actions
- GitLab CI/CD
- Jenkins
- CircleCI
- Azure Pipelines

### Helm Chart Generators

**Helm Generator** (`helm/helm-generator.sh`)
- Generate production-ready Helm charts
- Chart scaffolding and structure
- Values files with sensible defaults
- Template generation for common resources
- Testing and validation setup
- Documentation generation
- Versioning and release management

**Chart Types:**
- Application charts
- Library charts
- Dependency management
- Chart hooks and tests

### Observability & Monitoring Generators

**Observability Stack Generator** (`observability/observability-generator.sh`)
- Generate complete observability solutions
- Monitoring stack setup (Prometheus, Grafana)
- Logging infrastructure (ELK, Loki)
- Distributed tracing (Jaeger, Tempo)
- Alerting configuration
- Dashboard templates
- Instrumentation examples

**Supported Stacks:**
- Prometheus + Grafana + Alertmanager
- ELK Stack (Elasticsearch, Logstash, Kibana)
- Loki + Promtail + Grafana
- Jaeger for distributed tracing
- Complete monitoring as code (Terraform/Kubernetes)

## Quick Start

### Run Generator Manager

```bash
# Show help
./generator-manager.sh help

# List generators
./generator-manager.sh list

# Check generator status
./generator-manager.sh check

# Run specific generator
./generator-manager.sh docker       # Docker/Dockerfile
./generator-manager.sh terraform    # Terraform IaC
./generator-manager.sh kubernetes   # Kubernetes manifests
./generator-manager.sh cicd         # CI/CD pipelines
./generator-manager.sh helm         # Helm charts
./generator-manager.sh observability # Observability stack

# Get detailed info
./generator-manager.sh info docker
./generator-manager.sh info terraform
./generator-manager.sh info kubernetes
./generator-manager.sh info cicd
./generator-manager.sh info helm
./generator-manager.sh info observability
```

### Using Aliases

```bash
# Run generators via aliases
gen-docker              # Docker/Dockerfile generator
gen-terraform          # Terraform generator
gen-kubernetes         # Kubernetes generator
gen-cicd               # CI/CD generator
gen-helm               # Helm generator
gen-observability      # Observability generator

# List and manage generators
gen-list               # List all generators
gen-check              # Check generator status
gen-help               # Show help
gen-info <generator>   # Show generator info
gen                    # Run generator manager
```

### Examples

Generate a Dockerfile for your application:
```bash
./generator-manager.sh docker
# Follow interactive prompts to select framework and options
```

Create Terraform infrastructure configuration:
```bash
./generator-manager.sh terraform
# Select cloud provider and resources to generate
```

Generate Kubernetes deployment manifests:
```bash
./generator-manager.sh kubernetes
# Configure application type, replicas, services, etc.
```

Setup CI/CD pipeline:
```bash
./generator-manager.sh cicd
# Select CI/CD platform and configure stages
```

Create Helm chart:
```bash
./generator-manager.sh helm
# Generate chart structure and templates
```

Setup observability stack:
```bash
./generator-manager.sh observability
# Configure monitoring, logging, and tracing components
```

## Generator Manager Commands

### `list` - List all available generators

```bash
./generator-manager.sh list
```

Shows all available generators with descriptions.

### `docker` / `docker-help` - Docker/Dockerfile Generator

```bash
./generator-manager.sh docker          # Run generator
./generator-manager.sh docker-help     # Show help
```

Generate production-ready Dockerfiles with multi-stage builds, healthchecks, and framework-specific optimizations.

### `terraform` / `tf` / `terraform-help` - Terraform Generator

```bash
./generator-manager.sh terraform       # Run generator
./generator-manager.sh tf              # Short alias
./generator-manager.sh terraform-help  # Show help
```

Generate production-ready Terraform configurations for AWS, Azure, GCP, and other cloud providers.

### `kubernetes` / `k8s` / `kubernetes-help` - Kubernetes Generator

```bash
./generator-manager.sh kubernetes      # Run generator
./generator-manager.sh k8s             # Short alias
./generator-manager.sh kubernetes-help # Show help
```

Generate production-ready Kubernetes manifests, deployments, services, and ConfigMaps.

### `cicd` / `ci-cd` / `cicd-help` - CI/CD Pipeline Generator

```bash
./generator-manager.sh cicd            # Run generator
./generator-manager.sh ci-cd           # Alias
./generator-manager.sh cicd-help       # Show help
```

Generate complete CI/CD pipeline configurations for GitHub Actions, GitLab CI, Jenkins, and more.

### `helm` / `helm-help` - Helm Chart Generator

```bash
./generator-manager.sh helm            # Run generator
./generator-manager.sh helm-help       # Show help
```

Generate production-ready Helm charts with templates, values, and documentation.

### `observability` / `obs` / `observability-help` - Observability Generator

```bash
./generator-manager.sh observability   # Run generator
./generator-manager.sh obs             # Short alias
./generator-manager.sh observability-help # Show help
```

Generate complete observability stacks with Prometheus, Grafana, ELK, Jaeger, and more.

### `check` - Check generator status

```bash
./generator-manager.sh check
```

Verifies all generators are properly installed and executable. Shows status of each generator.

### `info` - Get generator information

```bash
./generator-manager.sh info docker
./generator-manager.sh info terraform
./generator-manager.sh info kubernetes
./generator-manager.sh info cicd
./generator-manager.sh info helm
./generator-manager.sh info observability
```

Shows detailed information about a specific generator including features and options.

### `help` - Show help

```bash
./generator-manager.sh help
```

Shows usage information and available commands.

## Dockerfile Generator Features

### Multi-Stage Builds

Automatically enabled for applicable frameworks:

```dockerfile
FROM node:18-alpine AS builder
# Build stage

FROM node:18-alpine
# Runtime stage
COPY --from=builder /app/dist ./dist
```

Benefits:
- 30-40% smaller images
- Faster deployments
- Reduced attack surface

### Security Features

✅ **Non-Root User**
```dockerfile
RUN addgroup -g 1001 nodejs
RUN adduser -S app -u 1001 -G nodejs
USER app
```

✅ **Healthcheck**
```dockerfile
HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD curl http://localhost:3000/health || exit 1
```

✅ **Security Headers**
```nginx
add_header X-Frame-Options "SAMEORIGIN" always;
add_header X-Content-Type-Options "nosniff" always;
add_header X-XSS-Protection "1; mode=block" always;
```

### Framework-Specific Optimizations

**Frontend (React, Vue, Angular)**
- Multi-stage build with Nginx
- Gzip compression
- Asset caching
- Client-side routing support

**SSR (Next.js, Nuxt)**
- Standalone builds
- Node.js runtime
- Server-side optimization

**Backend APIs**
- Minimal base images
- Production WSGI/ASGI servers
- Database support

**Full Stack (Laravel, Rails)**
- Web server included
- Process manager setup
- Asset compilation

## Terraform Generator Features

### Cloud Provider Support

**AWS Infrastructure**
- VPC with public/private subnets
- EC2 instances with auto-scaling groups
- RDS database instances
- S3 buckets with versioning and encryption
- Load balancers and target groups
- Security groups and network ACLs

**Azure Infrastructure**
- Virtual networks and subnets
- Virtual machines with scale sets
- Azure SQL Database
- Storage accounts
- Application Gateway
- Network security groups

**GCP Infrastructure**
- VPC networks and firewall rules
- Compute Engine instances with instance groups
- Cloud SQL instances
- Cloud Storage buckets
- Cloud Load Balancing
- Cloud IAM roles and permissions

### Module Structure

```hcl
terraform/
├── main.tf              # Root module configuration
├── variables.tf         # Input variables
├── outputs.tf           # Output values
├── terraform.tfvars     # Variable values
└── modules/
    ├── networking/      # Network resources
    ├── compute/         # Compute resources
    ├── database/        # Database resources
    └── storage/         # Storage resources
```

### Best Practices Included

✅ **State Management**
- Remote state configuration (S3, Azure Storage, GCS)
- State locking for concurrent operations
- State backup and recovery

✅ **Security**
- Encrypted variables for sensitive data
- IAM roles with least privilege
- VPC isolation and network segmentation
- Encrypted storage and databases

✅ **Code Quality**
- Consistent formatting
- Variable validation
- Comprehensive documentation
- DRY principle with modules

## Kubernetes Generator Features

### Manifest Templates

**Deployment Resources**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app
  namespace: default
spec:
  replicas: 3
  selector:
    matchLabels:
      app: app
  template:
    # Pod specification
```

**Service Types**
- ClusterIP for internal communication
- NodePort for external access
- LoadBalancer for cloud integration
- Ingress for advanced routing

**Configuration Management**
- ConfigMaps for application configuration
- Secrets for sensitive data
- Environment variables injection
- Volume mounts for persistent data

### Production-Ready Defaults

✅ **Resource Management**
- CPU and memory requests/limits
- Quality of Service (QoS) classes
- Pod disruption budgets

✅ **High Availability**
- Multiple replicas
- Pod anti-affinity rules
- Readiness and liveness probes
- Graceful shutdown handling

✅ **Security**
- RBAC with service accounts
- Network policies
- Pod security policies
- Image pull secrets

## CI/CD Generator Features

### Pipeline Stages

**Build Stage**
- Source code checkout
- Dependency resolution
- Code compilation/transpilation
- Unit testing
- Code quality analysis

**Test Stage**
- Integration testing
- End-to-end testing
- Security scanning
- Performance testing
- Coverage reporting

**Deploy Stage**
- Build Docker images
- Push to container registry
- Deploy to staging environment
- Run smoke tests
- Deploy to production

### Supported Platforms

**GitHub Actions**
- Workflow files (.github/workflows/)
- Matrix builds for multiple versions
- Secrets management
- GitHub-native integrations

**GitLab CI/CD**
- Pipeline definitions (.gitlab-ci.yml)
- Runners and executors
- Artifacts and caching
- Protected branches

**Jenkins**
- Declarative Pipeline syntax
- Shared libraries
- Credentials management
- Blue Ocean UI support

## Helm Generator Features

### Chart Structure

```
my-app/
├── Chart.yaml              # Chart metadata
├── values.yaml              # Default values
├── values-dev.yaml          # Development overrides
├── values-prod.yaml         # Production overrides
├── charts/                  # Subchart dependencies
├── templates/
│   ├── deployment.yaml      # Deployment template
│   ├── service.yaml         # Service template
│   ├── ingress.yaml         # Ingress template
│   ├── configmap.yaml       # ConfigMap template
│   ├── secret.yaml          # Secret template
│   ├── _helpers.tpl         # Template helpers
│   └── NOTES.txt            # Post-install notes
└── README.md                # Chart documentation
```

### Templating Features

✅ **Value Interpolation**
- Required values validation
- Default value fallbacks
- Conditional template sections
- Loop iterations

✅ **Reusability**
- Named templates (_helpers.tpl)
- Include statements
- Template functions
- Built-in Helm functions

### Testing and Validation

- Helm lint for syntax validation
- Template preview (helm template)
- Test charts (helm test)
- Schema validation

## Observability Generator Features

### Monitoring Stack (Prometheus)

**Components**
- Prometheus server for metrics collection
- Node Exporter for system metrics
- Custom exporters for application metrics
- Prometheus Operator for K8s integration

**Alerting**
- Alert rules based on thresholds
- Alertmanager for alert routing
- Notification channels (Slack, PagerDuty, email)
- Alert grouping and deduplication

### Logging Stack (ELK)

**Components**
- Elasticsearch for log storage and indexing
- Logstash for log processing and transformation
- Kibana for visualization and querying
- Filebeat/Metricbeat for log/metric shipping

**Features**
- Full-text search across logs
- Real-time log streaming
- Custom dashboards
- Log retention policies

### Distributed Tracing (Jaeger)

**Components**
- Jaeger Agent for local span collection
- Jaeger Collector for span processing
- Elasticsearch backend for storage
- Jaeger UI for visualization

**Instrumentation**
- Automatic instrumentation libraries
- Manual span creation
- Trace context propagation
- Service dependency mapping

### Dashboard Templates

✅ **Pre-built Dashboards**
- System metrics (CPU, memory, disk, network)
- Application performance (requests, latency, errors)
- Container metrics (if using Kubernetes)
- Business metrics

✅ **Alert Rules**
- High error rates
- High latency
- Resource exhaustion
- Service availability

## Generated Files

When running Dockerfile generator, you get:

1. **Dockerfile** - Optimized for your framework
2. **docker-compose.yml** - Complete application stack
3. **.dockerignore** - Build optimization
4. **DOCKER_README.md** - Deployment guide
5. **nginx/nginx.conf** - Reverse proxy (if applicable)
6. **config files** - Framework-specific configs
7. **requirements.txt.example** - Dependency template (Python)

## Adding New Generators

To add your own generator:

### 1. Create Generator Directory

```bash
mkdir -p scripts/generators/<category>
```

### 2. Create Generator Script

```bash
cat > scripts/generators/<category>/<name>-generator.sh << 'EOF'
#!/bin/bash

# Your generator code here
# Follow these conventions:
# - Use color functions for output
# - Support --help flag
# - Generate files in current directory
# - Create meaningful error messages

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# Your generator logic

echo -e "${GREEN}✓ Files generated successfully!${NC}"
EOF
```

### 3. Make Executable

```bash
chmod +x scripts/generators/<category>/<name>-generator.sh
```

### 4. Follow Naming Convention

- Directory: `scripts/generators/<category>/`
- File: `<name>-generator.sh`
- Example: `scripts/generators/docker/dockerfile-generator.sh`

### 5. Update Generator Manager

Edit `generator-manager.sh` to register your generator:

```bash
# Add to list_generators()
echo "  • <name>-generator   - Description"

# Add to show_generator_info()
<name>)
    cat << EOF
Details about your generator
EOF
    ;;

# Add to run_<generator>()
elif [[ "$GENERATOR" == "<category>/<name>" ]]; then
    run_<name>_generator
fi
```

### 6. Verify Installation

```bash
./generator-manager.sh check
```

## Best Practices

### Generator Code

- Use color output for better UX
- Provide clear error messages
- Support --help flag
- Validate user input
- Create files in current directory
- Generate templates, not finished products

### Generated Code

- Follow framework conventions
- Include comments and documentation
- Provide configuration examples
- Add security best practices
- Include troubleshooting section
- Document all customization options

## Troubleshooting

### Generator Not Found

```bash
./generator-manager.sh check
```

Verify all generators are installed and executable.

### Permission Denied

```bash
chmod +x scripts/generators/*/*.sh
```

Make scripts executable.

### Generator Not Working

```bash
# Run with verbose output
bash -x scripts/generators/docker/dockerfile-generator.sh

# Check for syntax errors
bash -n scripts/generators/docker/dockerfile-generator.sh
```

## Environment Variables

Configure generator behavior:

```bash
# Generator directory
GENERATORS_DIR=/path/to/generators

# Output directory
GENERATOR_OUTPUT_DIR=./

# Interactive mode
GENERATOR_INTERACTIVE=1

# Verbose output
GENERATOR_VERBOSE=0
```

## Performance

- **Generator startup:** < 1 second
- **Generator execution:** 10-30 seconds
- **Generated files:** 10-50 KB
- **Docker build:** 2-10 minutes

## File Structure Rules

```
scripts/generators/
├── generator-manager.sh          ✓ Main CLI
├── README.md                     ✓ This file
└── <category>/
    ├── <name>-generator.sh       ✓ Generator script
    └── README.md                 ✓ Category docs

Example: scripts/generators/docker/dockerfile-generator.sh
```

## Aliases

Convenient aliases for generator commands:

```bash
# Generator manager
gen              # Run generator manager
generator        # Run generator manager

# Generators
gen-docker       # Run Dockerfile generator
gen-terraform    # Run Terraform generator
gen-tf          # Run Terraform generator (short)
gen-kubernetes   # Run Kubernetes generator
gen-k8s         # Run Kubernetes generator (short)
gen-cicd        # Run CI/CD generator
gen-helm        # Run Helm generator
gen-observability # Run Observability generator
gen-obs         # Run Observability generator (short)

# Utilities
gen-list         # List all generators
gen-check        # Check generator status
gen-help         # Show help
gen-info         # Show generator info

# Alternative names
docker-gen       # Run Dockerfile generator
dockerfile-gen   # Run Dockerfile generator
terraform-gen    # Run Terraform generator
kubernetes-gen   # Run Kubernetes generator
k8s-gen         # Run Kubernetes generator
cicd-gen        # Run CI/CD generator
helm-gen        # Run Helm generator
obs-gen         # Run Observability generator
```

## Documentation

### Comprehensive Guides
- **User Guide**: `docs/GENERATORS.md`
- **Quick Start**: `GENERATORS_QUICK_START.md`
- **This File**: `scripts/generators/README.md` - Complete overview of all generators

### Generator-Specific Documentation
- **Docker Generator**: `scripts/generators/docker/README.md`
- **Terraform Generator**: `scripts/generators/terraform/README.md`
- **Kubernetes Generator**: `scripts/generators/kubernetes/README.md`
- **CI/CD Generator**: `scripts/generators/cicd/README.md`
- **Helm Generator**: `scripts/generators/helm/README.md`
- **Observability Generator**: `scripts/generators/observability/README.md`
- **Observability Guide**: `scripts/generators/observability/OBSERVABILITY-GUIDE.md`
- **Observability Cheatsheet**: `scripts/generators/observability/OBSERVABILITY-CHEATSHEET.md`

### Examples and Use Cases
- See `docs/GENERATORS.md#examples` for detailed examples
- Run `./generator-manager.sh info <generator>` for generator-specific information
- Run `./generator-manager.sh <generator>-help` for comprehensive help on each generator

## Support

For help:

```bash
# Show generator help
gen-help

# Get generator info
gen-info docker

# List all generators
gen-list

# Check status
gen-check

# Read documentation
cat docs/GENERATORS.md
cat GENERATORS_QUICK_START.md
```

## Roadmap

### Completed Generators
- [x] Docker/Dockerfile generator
- [x] Terraform Infrastructure-as-Code generator
- [x] Kubernetes manifests generator
- [x] CI/CD pipeline generator (GitHub Actions, GitLab CI, Jenkins, CircleCI, Azure Pipelines)
- [x] Helm charts generator
- [x] Observability & Monitoring stack generator

### Planned Generators
- [ ] Environment validator
- [ ] GitHub Copilot prompt generator
- [ ] API documentation generator
- [ ] Load testing configuration generator
- [ ] Infrastructure audit generator

### Planned Features
- [ ] Custom templates
- [ ] Generator plugins
- [ ] Template library
- [ ] Batch operations
- [ ] Configuration import/export
- [ ] Interactive template wizard
- [ ] Generator versioning
- [ ] Template marketplace
- [ ] Pre-commit hooks integration
- [ ] VS Code extension integration

## Contributing

To add new generators:

1. Create in appropriate category directory
2. Follow naming convention
3. Include --help support
4. Add documentation
5. Update generator-manager.sh
6. Test with `./generator-manager.sh check`

## License

All generators are part of the DevOps Workspace project.

---

**Start generating!** 🚀

```bash
./generator-manager.sh docker
```
