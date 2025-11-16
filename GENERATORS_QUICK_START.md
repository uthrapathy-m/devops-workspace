# Code Generators - Quick Start

Your DevOps workspace includes powerful code and configuration generators for rapid development.

## What's Available?

### 🐳 Dockerfile Generator
Generate optimized Dockerfiles for **13+ frameworks**

**Supported Frameworks:**
- Node.js: React, Next.js, Vue, Nuxt, Angular, Express, Nest
- Python: Django, Flask, FastAPI, Streamlit, Tornado
- PHP: Laravel, Symfony, CodeIgniter, WordPress
- Go: Gin, Echo, Fiber
- Java: Spring Boot, Quarkus, Micronaut
- Ruby: Rails, Sinatra
- .NET Core: ASP.NET Core, Blazor

## Quick Start

### 1. Generate a Dockerfile

```bash
# Start generator
generator-manager docker

# OR use alias
gen-docker
```

### 2. Answer the prompts
```
Select programming language: 1 (JavaScript/TypeScript)
Select framework: 2 (Next.js)
Nginx reverse proxy? (y/n): y
Multi-stage build? (y/n): y (auto for some)
Add healthcheck? (y/n): y
Run as non-root? (y/n): y
Application port: [3000]
```

### 3. Review generated files
```
✓ Dockerfile       - Production-ready Dockerfile
✓ docker-compose.yml - Complete stack
✓ .dockerignore    - Optimized build
✓ DOCKER_README.md - Detailed guide
✓ nginx/nginx.conf - Reverse proxy (if applicable)
```

### 4. Deploy
```bash
# Test locally
docker-compose up --build

# View logs
docker-compose logs -f app

# Stop
docker-compose down
```

## Common Commands

```bash
# List all generators
generator-manager list
alias: gen-list

# Run Dockerfile generator
generator-manager docker
alias: gen-docker

# Get Dockerfile help
generator-manager docker-help

# Check generator status
generator-manager check
alias: gen-check

# Get generator info
generator-manager info docker

# Show help
generator-manager help
alias: gen-help
```

## Examples by Framework

### Next.js

```bash
$ gen-docker

Language: 1 (JavaScript/TypeScript)
Framework: 2 (Next.js)
Nginx: y
Multi-stage: y (auto-enabled)
Healthcheck: y
Non-root: y
Port: 3000 ↵

$ cat DOCKER_README.md  # Read instructions
$ docker-compose up --build
```

### Django

```bash
$ gen-docker

Language: 2 (Python)
Framework: 1 (Django)
Nginx: y
Multi-stage: y
Healthcheck: y
Non-root: y
Port: 8000 ↵

$ mv requirements.txt.example requirements.txt
$ # Add dependencies
$ docker-compose up --build
```

### React

```bash
$ gen-docker

Language: 1 (JavaScript/TypeScript)
Framework: 1 (React)
Nginx: y (auto)
Multi-stage: y (auto)
Healthcheck: y
Non-root: y
Port: 80 ↵

$ docker-compose up --build
```

### Express.js

```bash
$ gen-docker

Language: 1 (JavaScript/TypeScript)
Framework: 6 (Express.js)
Nginx: y
Multi-stage: y
Healthcheck: y
Non-root: y
Port: 3000 ↵

$ docker-compose up --build
```

### Spring Boot

```bash
$ gen-docker

Language: 5 (Java)
Framework: 1 (Spring Boot)
Nginx: y
Multi-stage: y (auto)
Healthcheck: y
Non-root: y
Port: 8080 ↵

$ docker-compose up --build
```

### Laravel

```bash
$ gen-docker

Language: 3 (PHP)
Framework: 1 (Laravel)
Nginx: y (auto)
Multi-stage: n
Healthcheck: y
Non-root: y
Port: 9000 ↵

$ docker-compose up --build
```

## Generated Files

### Dockerfile
- Framework-specific optimizations
- Multi-stage builds (if enabled)
- Non-root user setup (if enabled)
- Healthcheck configuration (if enabled)
- Security best practices

### docker-compose.yml
- Application service
- Database service (if applicable)
- Nginx reverse proxy (if enabled)
- Environment variables
- Volume management
- Network setup

### .dockerignore
- Optimized build context
- Excludes git, node_modules, etc.
- Reduces build time

### DOCKER_README.md
- Deployment instructions
- Framework-specific notes
- Environment variables
- Production checklist
- Troubleshooting guide

## Features

✅ **Multi-Stage Builds**
- Smaller production images
- Separate build and runtime

✅ **Security**
- Non-root user support
- Security headers
- Network isolation

✅ **Monitoring**
- Healthcheck endpoints
- Framework-specific checks
- Log configuration

✅ **Optimization**
- Framework-specific settings
- Caching strategies
- Build optimization

## Customization

Generated files are templates. Customize as needed:

```bash
# Edit Dockerfile
nano Dockerfile

# Modify docker-compose.yml
nano docker-compose.yml

# Adjust ports
nano docker-compose.yml  # Change port mapping

# Update environment variables
nano docker-compose.yml  # Update environment section
```

## Production Deployment

### Before deploying:

1. **Security**
   - [ ] Change passwords
   - [ ] Set SECRET_KEY
   - [ ] Enable HTTPS
   - [ ] Configure CORS

2. **Performance**
   - [ ] Set resource limits
   - [ ] Enable caching
   - [ ] Configure logging

3. **Reliability**
   - [ ] Test locally
   - [ ] Review logs
   - [ ] Configure monitoring
   - [ ] Set up auto-restart

### Deploy:

```bash
# Build image
docker build -t myapp:latest .

# Push to registry
docker push myapp:latest

# Deploy to production
docker run -d \
  -e NODE_ENV=production \
  -p 3000:3000 \
  --restart unless-stopped \
  myapp:latest
```

## Troubleshooting

```bash
# View logs
docker-compose logs -f app

# Execute command in container
docker-compose exec app bash

# Rebuild without cache
docker-compose build --no-cache

# Check process in container
docker-compose exec app ps aux

# Test port connection
docker-compose exec app curl http://localhost:3000/health
```

## File Locations

```
scripts/generators/
├── generator-manager.sh         # Main CLI tool
└── docker/
    └── dockerfile-generator.sh  # Dockerfile generator

docs/
└── GENERATORS.md               # Detailed documentation

GENERATORS_QUICK_START.md       # This file
```

## Aliases

Add to your shell:

```bash
alias gen='generator-manager'
alias gen-docker='generator-manager docker'
alias gen-help='generator-manager help'
alias gen-list='generator-manager list'
alias gen-check='generator-manager check'
alias gen-info='generator-manager info'
```

## Performance

- **Generator time:** 10-30 seconds
- **Docker build:** 2-10 minutes (depends on dependencies)
- **Image size:** 50-800 MB (framework dependent)
  - Frontend: 30-100 MB
  - Backend: 200-800 MB

## Next Steps

1. **Run a generator**
   ```bash
   gen-docker
   ```

2. **Review generated files**
   ```bash
   ls -la
   cat DOCKER_README.md
   ```

3. **Test locally**
   ```bash
   docker-compose up --build
   ```

4. **Deploy**
   ```bash
   docker-compose up -d
   ```

## Need More Help?

```bash
# Full documentation
cat docs/GENERATORS.md

# Generator information
gen-info docker

# Generator help
gen-docker --help

# Docker Compose help
docker-compose help
```

## Resources

- [Docker Docs](https://docs.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)
- [Framework Guides](docs/GENERATORS.md#examples)

---

**Start generating!** 🚀

Generate your first Dockerfile:
```bash
gen-docker
```
