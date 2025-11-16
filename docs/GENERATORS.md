# Code Generators Guide

Your DevOps workspace includes a comprehensive set of code and configuration generators to accelerate your development workflow.

## Overview

The generator system provides CLI tools to automatically create optimized configurations, Dockerfiles, Kubernetes manifests, and more. All generators follow best practices and production-ready standards.

## Available Generators

### 🐳 Dockerfile Generator

**Purpose:** Generate optimized, production-ready Dockerfiles for 13+ frameworks

**Supported Frameworks:**

#### JavaScript/TypeScript
- React (Create React App / Vite)
- Next.js (SSR/SSG)
- Vue.js (Vue CLI / Vite)
- Nuxt.js (SSR/SSG Vue)
- Angular
- Express.js
- Nest.js
- Node.js (Generic)

#### Python
- Django
- Flask
- FastAPI
- Streamlit
- Tornado
- Python (Generic)

#### PHP
- Laravel
- Symfony
- CodeIgniter
- WordPress
- PHP (Generic)

#### Go
- Gin
- Echo
- Fiber
- Go (Generic)

#### Java
- Spring Boot
- Quarkus
- Micronaut
- Java (Generic)

#### Ruby
- Ruby on Rails
- Sinatra
- Ruby (Generic)

#### .NET Core
- ASP.NET Core (Web API)
- ASP.NET Core MVC
- Blazor
- .NET (Generic)

## Usage

### Basic Commands

```bash
# List all available generators
generator-manager list

# Run Dockerfile generator
generator-manager docker

# Get help for Dockerfile generator
generator-manager docker-help

# Check generator status
generator-manager check

# Get detailed generator info
generator-manager info docker
```

### Quick Start with Dockerfile Generator

```bash
# 1. Start interactive generator
generator-manager docker

# 2. Select your language (1-7)
#    Example: 1 for JavaScript/TypeScript

# 3. Select your framework (1-8)
#    Example: 2 for Next.js

# 4. Answer configuration prompts
#    - Nginx reverse proxy? (y/n)
#    - Multi-stage build? (y/n)
#    - Healthcheck? (y/n)
#    - Non-root user? (y/n)
#    - Application port? (default: auto)

# 5. Review generated files
ls -la Dockerfile docker-compose.yml .dockerignore

# 6. Build and test
docker-compose up --build

# 7. Read the generated guide
cat DOCKER_README.md
```

## Generated Files

### Dockerfile Generator Output

When you run the Dockerfile generator, you get:

1. **Dockerfile**
   - Optimized for your framework
   - Multi-stage builds for smaller images
   - Security best practices (non-root user)
   - Healthcheck configuration
   - Framework-specific optimizations

2. **docker-compose.yml**
   - Complete application stack
   - Database support (if applicable)
   - Environment configuration
   - Network setup
   - Volume management

3. **.dockerignore**
   - Optimized build context
   - Excludes unnecessary files
   - Reduces build time and image size

4. **DOCKER_README.md**
   - Detailed deployment guide
   - Framework-specific instructions
   - Security best practices
   - Troubleshooting guide
   - Production checklist

5. **nginx/nginx.conf** (if applicable)
   - Reverse proxy configuration
   - Rate limiting
   - Static file caching
   - Security headers
   - WebSocket support

6. **config files** (framework-specific)
   - Laravel: docker/nginx/laravel.conf, docker/supervisor/supervisord.conf
   - Python: requirements.txt.example

## Features

### Multi-Stage Builds
Automatically enabled for applicable frameworks (React, Vue, Angular, Next.js, Django, Flask, FastAPI, Spring Boot)

```dockerfile
# Smaller production images
FROM node:18-alpine AS builder  # Build stage
...
FROM node:18-alpine              # Runtime stage
COPY --from=builder ...          # Copy only artifacts
```

### Security Features

✅ **Non-Root User**
- Runs containers as non-root user
- Reduces security risk
- Recommended for production

✅ **Healthchecks**
- Automatic health monitoring
- Configurable intervals and timeouts
- Framework-specific health endpoints

✅ **Security Headers**
- X-Frame-Options
- X-Content-Type-Options
- X-XSS-Protection
- CSP headers (where applicable)

### Framework-Specific Optimizations

**Frontend (React, Vue, Angular)**
- Multi-stage build with Nginx
- Client-side routing support
- Asset caching optimization
- Gzip compression

**SSR Frameworks (Next.js, Nuxt.js)**
- Standalone builds
- Node.js runtime
- Optimized for server-side rendering

**Backend APIs (Express, Flask, FastAPI)**
- Minimal base images
- Production WSGI/ASGI servers
- Request/response optimization

**Full Stack (Laravel, Rails)**
- Web server included
- Supervisor process management
- Asset pipeline integration

## Configuration Options

### When Running Generator

```bash
1. Language Selection
   - JavaScript/TypeScript (Node.js)
   - Python
   - PHP
   - Go
   - Java
   - Ruby
   - .NET Core

2. Framework Selection
   - Language-specific options
   - Default ports auto-configured

3. Build Options
   - Nginx: Reverse proxy or static serving
   - Multi-stage: Smaller images
   - Healthcheck: Monitoring
   - Non-root: Security
   - Custom port: Override defaults
```

## Best Practices

### Before Building

```bash
# 1. Ensure dependencies are listed
#    - package.json (Node)
#    - requirements.txt (Python)
#    - Gemfile (Ruby)
#    - pom.xml (Java)
#    - composer.json (PHP)

# 2. Configure environment variables
#    - Copy .env.example to .env
#    - Set production values

# 3. Review generated Dockerfile
#    - Customize if needed
#    - Check build commands

# 4. Test locally
docker-compose up --build
docker-compose exec app /bin/sh  # Test inside container
```

### Production Deployment

**Security Checklist:**
- [ ] Change default passwords
- [ ] Set strong SECRET_KEY values
- [ ] Enable HTTPS/TLS
- [ ] Configure CORS properly
- [ ] Set database encryption
- [ ] Enable logging
- [ ] Configure monitoring
- [ ] Scan for vulnerabilities (Trivy)
- [ ] Use private registries
- [ ] Implement rate limiting

**Performance Checklist:**
- [ ] Enable caching
- [ ] Optimize database queries
- [ ] Configure resource limits
- [ ] Enable compression (gzip)
- [ ] Use CDN for assets
- [ ] Implement auto-scaling
- [ ] Monitor performance metrics

## Troubleshooting

### Container won't start

```bash
# Check logs
docker-compose logs app

# Run in interactive mode
docker-compose run --rm app /bin/sh

# Check health status
docker-compose ps
docker inspect <container_id>
```

### Build failures

```bash
# Rebuild from scratch
docker-compose down
docker-compose build --no-cache

# Check base image
docker pull <base-image>

# View build output
docker-compose build --progress=plain app
```

### Port conflicts

```bash
# Find process using port
lsof -i :3000

# Change port in docker-compose.yml
ports:
  - "8080:3000"  # Use 8080 instead
```

### Permission errors

```bash
# Fix Docker daemon permissions
sudo usermod -aG docker $USER
newgrp docker

# Fix file permissions
sudo chown -R $USER:$USER .
chmod +x docker-compose.yml
```

## File Structure

```
scripts/generators/
├── generator-manager.sh          # Main generator manager CLI
└── docker/
    ├── dockerfile-generator.sh   # Dockerfile generator
    └── README.md                 # Generator-specific docs
```

## Creating Custom Generators

To add your own generators:

```bash
# 1. Create generator directory
mkdir -p scripts/generators/custom

# 2. Create generator script
cat > scripts/generators/custom/my-generator.sh << 'EOF'
#!/bin/bash
# Your generator code here
EOF

# 3. Make executable
chmod +x scripts/generators/custom/my-generator.sh

# 4. Follow naming convention
# Name: <name>-generator.sh

# 5. Verify
generator-manager check
```

## Examples

### Generate Next.js Dockerfile

```bash
$ generator-manager docker

# Select: 1 (JavaScript/TypeScript)
# Select: 2 (Next.js)
# Nginx: y (for reverse proxy)
# Multi-stage: y (auto-enabled)
# Healthcheck: y
# Non-root: y
# Port: 3000 (default)

# Output:
# ✓ Dockerfile (optimized for nextjs)
# ✓ docker-compose.yml
# ✓ .dockerignore
# ✓ DOCKER_README.md

# Deploy:
$ docker-compose up --build
```

### Generate Django Dockerfile

```bash
$ generator-manager docker

# Select: 2 (Python)
# Select: 1 (Django)
# Nginx: y (reverse proxy)
# Multi-stage: y
# Healthcheck: y
# Non-root: y
# Port: 8000 (default)

# Output includes:
# ✓ Dockerfile
# ✓ docker-compose.yml (with PostgreSQL)
# ✓ requirements.txt.example
# ✓ DOCKER_README.md

# Setup:
$ mv requirements.txt.example requirements.txt
$ # Add your dependencies to requirements.txt
$ docker-compose up --build
```

## Aliases

Convenient aliases are available:

```bash
# Generator management
generator                    # Run generator manager
gen-list                    # List all generators
gen-docker                  # Run Dockerfile generator
gen-check                   # Check generator status
gen-help                    # Show generator help
```

## Environment Variables

Configure generators via environment variables:

```bash
# Generator behavior
GENERATOR_INTERACTIVE=1     # Interactive mode (default)
GENERATOR_OUTPUT_DIR=./    # Output directory

# Framework defaults
DEFAULT_NODE_VERSION=18
DEFAULT_PYTHON_VERSION=3.11
DEFAULT_NGINX_PORT=80
```

## Performance

- **Generator runtime:** 10-30 seconds
- **Generated files size:** 10-50 KB
- **Build time (Docker):** 2-10 minutes (depends on dependencies)
- **Image sizes:**
  - Frontend: 30-100 MB
  - Backend: 200-800 MB
  - Multi-stage: 30-40% smaller

## Roadmap

### Coming Soon
- [ ] Kubernetes manifests generator
- [ ] Helm charts generator
- [ ] GitHub Actions generator
- [ ] GitLab CI/CD generator
- [ ] Terraform generator
- [ ] Environment variables validator
- [ ] Docker Compose optimizer

### Future Features
- [ ] Template customization
- [ ] Generator plugins
- [ ] Custom framework templates
- [ ] Batch generator execution
- [ ] Configuration import/export

## Support & Help

```bash
# Get help
generator-manager help

# List generators
generator-manager list

# Check status
generator-manager check

# Detailed info
generator-manager info docker

# Docker generator help
generator-manager docker-help

# View generated readme
cat DOCKER_README.md
```

## Resources

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Reference](https://docs.docker.com/compose/compose-file/)
- [Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [Security](https://docs.docker.com/develop/security-best-practices/)

## Feedback

To suggest improvements or report issues:

1. Check the generated DOCKER_README.md
2. Review framework-specific documentation
3. Test locally before deploying
4. Consult framework documentation
5. File issues in repository

---

**Happy generating!** 🚀
