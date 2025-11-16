# Code & Configuration Generators

Centralized management system for code and configuration generators in your DevOps workspace.

## Overview

This directory contains command-line generators for creating optimized configurations, Dockerfiles, Kubernetes manifests, and more. All generators follow best practices and production-ready standards.

## Directory Structure

```
generators/
├── generator-manager.sh         # Main generator management CLI
├── README.md                    # This file
└── docker/
    ├── dockerfile-generator.sh  # Advanced Dockerfile generator
    └── README.md                # Docker generator docs
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

## Quick Start

### Run Generator Manager

```bash
# Show help
./generator-manager.sh help

# List generators
./generator-manager.sh list

# Check generator status
./generator-manager.sh check

# Run Dockerfile generator
./generator-manager.sh docker

# Get detailed info
./generator-manager.sh info docker
```

### Using Aliases

```bash
# Run via alias
gen-docker

# List all generators
gen-list

# Get help
gen-help

# Check status
gen-check
```

## Generator Manager Commands

### `list` - List all available generators

```bash
./generator-manager.sh list
```

Shows all available generators with descriptions.

### `docker` - Run Dockerfile generator

```bash
./generator-manager.sh docker
```

Launches interactive Dockerfile generator.

### `docker-help` - Show Dockerfile help

```bash
./generator-manager.sh docker-help
```

Shows detailed help for Dockerfile generator.

### `check` - Check generator status

```bash
./generator-manager.sh check
```

Verifies all generators are properly installed and executable.

### `info` - Get generator information

```bash
./generator-manager.sh info docker
```

Shows detailed information about a specific generator.

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
gen              # Run generator manager
gen-docker       # Run Dockerfile generator
gen-list         # List all generators
gen-check        # Check generator status
gen-help         # Show help
gen-info         # Show generator info
generator        # Run generator manager
docker-gen       # Run Dockerfile generator
dockerfile-gen   # Run Dockerfile generator
```

## Documentation

- **User Guide**: `docs/GENERATORS.md`
- **Quick Start**: `GENERATORS_QUICK_START.md`
- **Docker Generator**: `scripts/generators/docker/README.md`
- **Examples**: See `docs/GENERATORS.md#examples`

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

### Planned Generators
- [ ] Kubernetes manifests generator
- [ ] Helm charts generator
- [ ] GitHub Actions generator
- [ ] GitLab CI/CD generator
- [ ] Terraform generator
- [ ] Environment validator

### Planned Features
- [ ] Custom templates
- [ ] Generator plugins
- [ ] Template library
- [ ] Batch operations
- [ ] Configuration import/export

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
