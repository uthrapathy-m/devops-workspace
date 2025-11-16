#!/bin/bash

# Advanced Dockerfile Generator for Production Deployments
# Supports specific frameworks with optimized configurations
# Author: Generated Script

set -e

# Colors for better UI
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Global variables
LANGUAGE=""
FRAMEWORK=""
USE_NGINX=false
MULTISTAGE=false
HEALTHCHECK=false
NONROOT=false
APP_PORT=3000
BUILD_DIR=""
STATIC_DIR=""

# Function to print colored output
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${MAGENTA}$1${NC}"
}

# Function to display header
display_header() {
    clear
    echo "========================================================"
    echo "   Advanced Dockerfile Generator for Production        "
    echo "   Framework-Specific Optimized Configurations         "
    echo "========================================================"
    echo ""
}

# Function to select programming language and framework
select_language_and_framework() {
    echo "Select Programming Language:"
    echo "1) JavaScript/TypeScript (Node.js)"
    echo "2) Python"
    echo "3) PHP"
    echo "4) Go"
    echo "5) Java"
    echo "6) Ruby"
    echo "7) .NET Core"
    echo ""
    read -p "Enter your choice (1-7): " lang_choice
    
    case $lang_choice in
        1) 
            LANGUAGE="javascript"
            select_javascript_framework
            ;;
        2) 
            LANGUAGE="python"
            select_python_framework
            ;;
        3) 
            LANGUAGE="php"
            select_php_framework
            ;;
        4) 
            LANGUAGE="go"
            select_go_framework
            ;;
        5) 
            LANGUAGE="java"
            select_java_framework
            ;;
        6) 
            LANGUAGE="ruby"
            select_ruby_framework
            ;;
        7) 
            LANGUAGE="dotnet"
            select_dotnet_framework
            ;;
        *) 
            print_error "Invalid choice"
            exit 1 
            ;;
    esac
}

# JavaScript/TypeScript Framework Selection
select_javascript_framework() {
    echo ""
    print_header "Select JavaScript/TypeScript Framework:"
    echo "1) React (SPA - Create React App / Vite)"
    echo "2) Next.js (SSR/SSG React Framework)"
    echo "3) Vue.js (SPA - Vue CLI / Vite)"
    echo "4) Nuxt.js (SSR/SSG Vue Framework)"
    echo "5) Angular (SPA)"
    echo "6) Express.js (Backend API)"
    echo "7) Nest.js (Backend Framework)"
    echo "8) Node.js (Generic/Custom)"
    echo ""
    read -p "Enter your choice (1-8): " fw_choice
    
    case $fw_choice in
        1) FRAMEWORK="react"; APP_PORT=80; BUILD_DIR="build"; STATIC_DIR="/usr/share/nginx/html" ;;
        2) FRAMEWORK="nextjs"; APP_PORT=3000 ;;
        3) FRAMEWORK="vue"; APP_PORT=80; BUILD_DIR="dist"; STATIC_DIR="/usr/share/nginx/html" ;;
        4) FRAMEWORK="nuxtjs"; APP_PORT=3000 ;;
        5) FRAMEWORK="angular"; APP_PORT=80; BUILD_DIR="dist"; STATIC_DIR="/usr/share/nginx/html" ;;
        6) FRAMEWORK="express"; APP_PORT=3000 ;;
        7) FRAMEWORK="nestjs"; APP_PORT=3000 ;;
        8) FRAMEWORK="nodejs"; APP_PORT=3000 ;;
        *) print_error "Invalid choice"; exit 1 ;;
    esac
    
    print_success "Selected: $FRAMEWORK"
}

# Python Framework Selection
select_python_framework() {
    echo ""
    print_header "Select Python Framework:"
    echo "1) Django (Full-stack Web Framework)"
    echo "2) Flask (Micro Web Framework)"
    echo "3) FastAPI (Modern API Framework)"
    echo "4) Streamlit (Data Apps)"
    echo "5) Tornado (Async Framework)"
    echo "6) Python (Generic/Custom)"
    echo ""
    read -p "Enter your choice (1-6): " fw_choice
    
    case $fw_choice in
        1) FRAMEWORK="django"; APP_PORT=8000 ;;
        2) FRAMEWORK="flask"; APP_PORT=5000 ;;
        3) FRAMEWORK="fastapi"; APP_PORT=8000 ;;
        4) FRAMEWORK="streamlit"; APP_PORT=8501 ;;
        5) FRAMEWORK="tornado"; APP_PORT=8888 ;;
        6) FRAMEWORK="python"; APP_PORT=8000 ;;
        *) print_error "Invalid choice"; exit 1 ;;
    esac
    
    print_success "Selected: $FRAMEWORK"
}

# PHP Framework Selection
select_php_framework() {
    echo ""
    print_header "Select PHP Framework:"
    echo "1) Laravel"
    echo "2) Symfony"
    echo "3) CodeIgniter"
    echo "4) WordPress"
    echo "5) PHP (Generic/Custom)"
    echo ""
    read -p "Enter your choice (1-5): " fw_choice
    
    case $fw_choice in
        1) FRAMEWORK="laravel"; APP_PORT=9000 ;;
        2) FRAMEWORK="symfony"; APP_PORT=9000 ;;
        3) FRAMEWORK="codeigniter"; APP_PORT=9000 ;;
        4) FRAMEWORK="wordpress"; APP_PORT=9000 ;;
        5) FRAMEWORK="php"; APP_PORT=9000 ;;
        *) print_error "Invalid choice"; exit 1 ;;
    esac
    
    print_success "Selected: $FRAMEWORK"
}

# Go Framework Selection
select_go_framework() {
    echo ""
    print_header "Select Go Framework:"
    echo "1) Gin (HTTP Web Framework)"
    echo "2) Echo (High Performance Framework)"
    echo "3) Fiber (Express-inspired Framework)"
    echo "4) Go (Generic/Custom)"
    echo ""
    read -p "Enter your choice (1-4): " fw_choice
    
    case $fw_choice in
        1) FRAMEWORK="gin"; APP_PORT=8080 ;;
        2) FRAMEWORK="echo"; APP_PORT=8080 ;;
        3) FRAMEWORK="fiber"; APP_PORT=3000 ;;
        4) FRAMEWORK="go"; APP_PORT=8080 ;;
        *) print_error "Invalid choice"; exit 1 ;;
    esac
    
    print_success "Selected: $FRAMEWORK"
}

# Java Framework Selection
select_java_framework() {
    echo ""
    print_header "Select Java Framework:"
    echo "1) Spring Boot"
    echo "2) Quarkus"
    echo "3) Micronaut"
    echo "4) Java (Generic/Custom)"
    echo ""
    read -p "Enter your choice (1-4): " fw_choice
    
    case $fw_choice in
        1) FRAMEWORK="springboot"; APP_PORT=8080 ;;
        2) FRAMEWORK="quarkus"; APP_PORT=8080 ;;
        3) FRAMEWORK="micronaut"; APP_PORT=8080 ;;
        4) FRAMEWORK="java"; APP_PORT=8080 ;;
        *) print_error "Invalid choice"; exit 1 ;;
    esac
    
    print_success "Selected: $FRAMEWORK"
}

# Ruby Framework Selection
select_ruby_framework() {
    echo ""
    print_header "Select Ruby Framework:"
    echo "1) Ruby on Rails"
    echo "2) Sinatra"
    echo "3) Ruby (Generic/Custom)"
    echo ""
    read -p "Enter your choice (1-3): " fw_choice
    
    case $fw_choice in
        1) FRAMEWORK="rails"; APP_PORT=3000 ;;
        2) FRAMEWORK="sinatra"; APP_PORT=4567 ;;
        3) FRAMEWORK="ruby"; APP_PORT=3000 ;;
        *) print_error "Invalid choice"; exit 1 ;;
    esac
    
    print_success "Selected: $FRAMEWORK"
}

# .NET Framework Selection
select_dotnet_framework() {
    echo ""
    print_header "Select .NET Framework:"
    echo "1) ASP.NET Core (Web API)"
    echo "2) ASP.NET Core MVC"
    echo "3) Blazor"
    echo "4) .NET (Generic/Custom)"
    echo ""
    read -p "Enter your choice (1-4): " fw_choice
    
    case $fw_choice in
        1) FRAMEWORK="aspnet-api"; APP_PORT=5000 ;;
        2) FRAMEWORK="aspnet-mvc"; APP_PORT=5000 ;;
        3) FRAMEWORK="blazor"; APP_PORT=5000 ;;
        4) FRAMEWORK="dotnet"; APP_PORT=5000 ;;
        *) print_error "Invalid choice"; exit 1 ;;
    esac
    
    print_success "Selected: $FRAMEWORK"
}

# Function to ask for Nginx
ask_nginx() {
    echo ""
    
    # For SPA frameworks, Nginx is required
    if [[ "$FRAMEWORK" == "react" || "$FRAMEWORK" == "vue" || "$FRAMEWORK" == "angular" ]]; then
        print_info "Nginx is required for $FRAMEWORK (serving static files)"
        USE_NGINX=true
        return
    fi
    
    # For other frameworks, ask
    read -p "Do you want to include Nginx as reverse proxy? (y/n): " nginx_choice
    if [[ $nginx_choice == "y" || $nginx_choice == "Y" ]]; then
        USE_NGINX=true
        print_success "Nginx will be included"
    else
        USE_NGINX=false
        print_info "Nginx will not be included"
    fi
}

# Function to ask for additional options
ask_additional_options() {
    echo ""
    
    # Multi-stage is automatic for some frameworks
    if [[ "$FRAMEWORK" == "react" || "$FRAMEWORK" == "vue" || "$FRAMEWORK" == "angular" || "$FRAMEWORK" == "nextjs" ]]; then
        MULTISTAGE=true
        print_info "Multi-stage build is automatically enabled for $FRAMEWORK"
    else
        read -p "Enable multi-stage build for smaller image? (y/n): " multistage
        MULTISTAGE=$([[ $multistage == "y" || $multistage == "Y" ]] && echo true || echo false)
    fi
    
    echo ""
    read -p "Add healthcheck? (y/n): " healthcheck
    HEALTHCHECK=$([[ $healthcheck == "y" || $healthcheck == "Y" ]] && echo true || echo false)
    
    echo ""
    read -p "Run as non-root user? (recommended for security) (y/n): " nonroot
    NONROOT=$([[ $nonroot == "y" || $nonroot == "Y" ]] && echo true || echo false)
    
    echo ""
    read -p "Enter application port (default: $APP_PORT): " app_port
    APP_PORT=${app_port:-$APP_PORT}
}

# ============================================================================
# REACT DOCKERFILE GENERATOR
# ============================================================================
generate_react_dockerfile() {
    cat > Dockerfile << 'EOF'
# Multi-stage build for React application
# Stage 1: Build
FROM node:18-alpine AS builder

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy source code
COPY . .

# Build the application
RUN npm run build

# Stage 2: Production with Nginx
FROM nginx:alpine

# Remove default nginx config
RUN rm /etc/nginx/conf.d/default.conf

# Copy custom nginx configuration
COPY nginx.conf /etc/nginx/conf.d/

# Copy built assets from builder
COPY --from=builder /app/build /usr/share/nginx/html

EOF

    if [ "$NONROOT" = true ]; then
        cat >> Dockerfile << 'EOF'
# Create non-root user
RUN addgroup -g 1001 -S nginx && adduser -S nginx -u 1001 -G nginx

# Change ownership
RUN chown -R nginx:nginx /usr/share/nginx/html && \
    chown -R nginx:nginx /var/cache/nginx && \
    chown -R nginx:nginx /var/log/nginx && \
    chown -R nginx:nginx /etc/nginx/conf.d && \
    touch /var/run/nginx.pid && \
    chown -R nginx:nginx /var/run/nginx.pid

# Switch to non-root user
USER nginx

EOF
    fi

    cat >> Dockerfile << EOF
# Expose port
EXPOSE 80

EOF

    if [ "$HEALTHCHECK" = true ]; then
        cat >> Dockerfile << 'EOF'
# Healthcheck
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:80/ || exit 1

EOF
    fi

    cat >> Dockerfile << 'EOF'
# Start nginx
CMD ["nginx", "-g", "daemon off;"]
EOF

    # Create React-specific nginx config
    cat > nginx.conf << 'EOF'
server {
    listen 80;
    server_name _;
    root /usr/share/nginx/html;
    index index.html;

    # Gzip compression
    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;
    gzip_min_length 1000;

    # Handle client-side routing
    location / {
        try_files $uri $uri/ /index.html;
        add_header Cache-Control "no-cache";
    }

    # Cache static assets
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
}
EOF
    print_success "React-specific nginx.conf created"
}

# ============================================================================
# NEXT.JS DOCKERFILE GENERATOR
# ============================================================================
generate_nextjs_dockerfile() {
    cat > Dockerfile << 'EOF'
# Multi-stage build for Next.js application
FROM node:18-alpine AS deps

WORKDIR /app

# Copy package files
COPY package*.json ./
RUN npm ci

# Builder stage
FROM node:18-alpine AS builder

WORKDIR /app

COPY --from=deps /app/node_modules ./node_modules
COPY . .

# Build Next.js app
RUN npm run build

# Production stage
FROM node:18-alpine AS runner

WORKDIR /app

ENV NODE_ENV production

EOF

    if [ "$NONROOT" = true ]; then
        cat >> Dockerfile << 'EOF'
# Create non-root user
RUN addgroup -g 1001 -S nodejs && adduser -S nextjs -u 1001 -G nodejs

EOF
    fi

    cat >> Dockerfile << 'EOF'
# Copy necessary files
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static

EOF

    if [ "$NONROOT" = true ]; then
        cat >> Dockerfile << 'EOF'
# Change ownership
RUN chown -R nextjs:nodejs /app

USER nextjs

EOF
    fi

    cat >> Dockerfile << EOF
EXPOSE ${APP_PORT}

ENV PORT ${APP_PORT}

EOF

    if [ "$HEALTHCHECK" = true ]; then
        cat >> Dockerfile << EOF
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \\
  CMD node -e "require('http').get('http://localhost:${APP_PORT}/', (r) => process.exit(r.statusCode === 200 ? 0 : 1))"

EOF
    fi

    cat >> Dockerfile << 'EOF'
CMD ["node", "server.js"]
EOF
}

# ============================================================================
# VUE.JS DOCKERFILE GENERATOR
# ============================================================================
generate_vue_dockerfile() {
    cat > Dockerfile << 'EOF'
# Multi-stage build for Vue.js application
# Stage 1: Build
FROM node:18-alpine AS builder

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy source code
COPY . .

# Build the application
RUN npm run build

# Stage 2: Production with Nginx
FROM nginx:alpine

# Remove default nginx config
RUN rm /etc/nginx/conf.d/default.conf

# Copy custom nginx configuration
COPY nginx.conf /etc/nginx/conf.d/

# Copy built assets from builder
COPY --from=builder /app/dist /usr/share/nginx/html

EOF

    if [ "$NONROOT" = true ]; then
        cat >> Dockerfile << 'EOF'
# Create non-root user
RUN addgroup -g 1001 -S nginx && adduser -S nginx -u 1001 -G nginx

# Change ownership
RUN chown -R nginx:nginx /usr/share/nginx/html && \
    chown -R nginx:nginx /var/cache/nginx && \
    chown -R nginx:nginx /var/log/nginx && \
    chown -R nginx:nginx /etc/nginx/conf.d && \
    touch /var/run/nginx.pid && \
    chown -R nginx:nginx /var/run/nginx.pid

USER nginx

EOF
    fi

    cat >> Dockerfile << EOF
EXPOSE 80

EOF

    if [ "$HEALTHCHECK" = true ]; then
        cat >> Dockerfile << 'EOF'
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:80/ || exit 1

EOF
    fi

    cat >> Dockerfile << 'EOF'
CMD ["nginx", "-g", "daemon off;"]
EOF

    # Create Vue-specific nginx config
    cat > nginx.conf << 'EOF'
server {
    listen 80;
    server_name _;
    root /usr/share/nginx/html;
    index index.html;

    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;

    location / {
        try_files $uri $uri/ /index.html;
    }

    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
EOF
    print_success "Vue-specific nginx.conf created"
}

# ============================================================================
# ANGULAR DOCKERFILE GENERATOR
# ============================================================================
generate_angular_dockerfile() {
    cat > Dockerfile << 'EOF'
# Multi-stage build for Angular application
FROM node:18-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build -- --configuration production

# Production stage
FROM nginx:alpine

RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d/

# Copy built assets (adjust project name if needed)
COPY --from=builder /app/dist /usr/share/nginx/html

EOF

    if [ "$NONROOT" = true ]; then
        cat >> Dockerfile << 'EOF'
RUN addgroup -g 1001 -S nginx && adduser -S nginx -u 1001 -G nginx
RUN chown -R nginx:nginx /usr/share/nginx/html && \
    chown -R nginx:nginx /var/cache/nginx && \
    chown -R nginx:nginx /var/log/nginx && \
    chown -R nginx:nginx /etc/nginx/conf.d && \
    touch /var/run/nginx.pid && \
    chown -R nginx:nginx /var/run/nginx.pid

USER nginx

EOF
    fi

    cat >> Dockerfile << EOF
EXPOSE 80

EOF

    if [ "$HEALTHCHECK" = true ]; then
        cat >> Dockerfile << 'EOF'
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:80/ || exit 1

EOF
    fi

    cat >> Dockerfile << 'EOF'
CMD ["nginx", "-g", "daemon off;"]
EOF

    cat > nginx.conf << 'EOF'
server {
    listen 80;
    server_name _;
    root /usr/share/nginx/html;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }

    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
EOF
    print_success "Angular-specific nginx.conf created"
}

# ============================================================================
# EXPRESS.JS DOCKERFILE GENERATOR
# ============================================================================
generate_express_dockerfile() {
    if [ "$MULTISTAGE" = true ]; then
        cat > Dockerfile << 'EOF'
FROM node:18-alpine AS builder

WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

FROM node:18-alpine

RUN apk add --no-cache dumb-init

WORKDIR /app

EOF
    else
        cat > Dockerfile << 'EOF'
FROM node:18-alpine

RUN apk add --no-cache dumb-init

WORKDIR /app

COPY package*.json ./
RUN npm ci --only=production

EOF
    fi

    if [ "$NONROOT" = true ]; then
        cat >> Dockerfile << 'EOF'
RUN addgroup -g 1001 -S nodejs && adduser -S nodejs -u 1001 -G nodejs

EOF
    fi

    if [ "$MULTISTAGE" = true ]; then
        cat >> Dockerfile << 'EOF'
COPY --from=builder /app/node_modules ./node_modules

EOF
    fi

    cat >> Dockerfile << 'EOF'
COPY . .

EOF

    if [ "$NONROOT" = true ]; then
        cat >> Dockerfile << 'EOF'
RUN chown -R nodejs:nodejs /app
USER nodejs

EOF
    fi

    cat >> Dockerfile << EOF
EXPOSE ${APP_PORT}

EOF

    if [ "$HEALTHCHECK" = true ]; then
        cat >> Dockerfile << EOF
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \\
  CMD node -e "require('http').get('http://localhost:${APP_PORT}/health', (r) => process.exit(r.statusCode === 200 ? 0 : 1))"

EOF
    fi

    cat >> Dockerfile << 'EOF'
CMD ["dumb-init", "node", "index.js"]
EOF
}

# ============================================================================
# NEST.JS DOCKERFILE GENERATOR
# ============================================================================
generate_nestjs_dockerfile() {
    cat > Dockerfile << 'EOF'
# Multi-stage build for NestJS
FROM node:18-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

# Production stage
FROM node:18-alpine

RUN apk add --no-cache dumb-init

WORKDIR /app

EOF

    if [ "$NONROOT" = true ]; then
        cat >> Dockerfile << 'EOF'
RUN addgroup -g 1001 -S nodejs && adduser -S nodejs -u 1001 -G nodejs

EOF
    fi

    cat >> Dockerfile << 'EOF'
COPY package*.json ./
RUN npm ci --only=production

COPY --from=builder /app/dist ./dist

EOF

    if [ "$NONROOT" = true ]; then
        cat >> Dockerfile << 'EOF'
RUN chown -R nodejs:nodejs /app
USER nodejs

EOF
    fi

    cat >> Dockerfile << EOF
EXPOSE ${APP_PORT}

EOF

    if [ "$HEALTHCHECK" = true ]; then
        cat >> Dockerfile << EOF
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \\
  CMD node -e "require('http').get('http://localhost:${APP_PORT}/health', (r) => process.exit(r.statusCode === 200 ? 0 : 1))"

EOF
    fi

    cat >> Dockerfile << 'EOF'
CMD ["dumb-init", "node", "dist/main.js"]
EOF
}

# ============================================================================
# DJANGO DOCKERFILE GENERATOR
# ============================================================================
generate_django_dockerfile() {
    if [ "$MULTISTAGE" = true ]; then
        cat > Dockerfile << 'EOF'
# Multi-stage build for Django
FROM python:3.11-slim AS builder

WORKDIR /app

COPY requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt

# Production stage
FROM python:3.11-slim

WORKDIR /app

# Install runtime dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    libpq5 \
    && rm -rf /var/lib/apt/lists/*

EOF
    else
        cat > Dockerfile << 'EOF'
FROM python:3.11-slim

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    libpq5 \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

EOF
    fi

    if [ "$NONROOT" = true ]; then
        cat >> Dockerfile << 'EOF'
RUN useradd -m -u 1001 django

EOF
    fi

    if [ "$MULTISTAGE" = true ]; then
        cat >> Dockerfile << 'EOF'
COPY --from=builder /root/.local /home/django/.local

EOF
    fi

    cat >> Dockerfile << 'EOF'
COPY . .

# Collect static files
RUN python manage.py collectstatic --noinput

EOF

    if [ "$NONROOT" = true ]; then
        cat >> Dockerfile << 'EOF'
RUN chown -R django:django /app
USER django
ENV PATH=/home/django/.local/bin:$PATH

EOF
    fi

    cat >> Dockerfile << EOF
EXPOSE ${APP_PORT}

EOF

    if [ "$HEALTHCHECK" = true ]; then
        cat >> Dockerfile << EOF
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \\
  CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:${APP_PORT}/health')" || exit 1

EOF
    fi

    cat >> Dockerfile << 'EOF'
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "4", "project.wsgi:application"]
EOF

    # Create requirements.txt template
    cat > requirements.txt.example << 'EOF'
Django>=4.2,<5.0
gunicorn>=21.0.0
psycopg2-binary>=2.9.0
python-decouple>=3.8
whitenoise>=6.5.0
EOF
    print_success "Created requirements.txt.example (rename to requirements.txt)"
}

# ============================================================================
# FLASK DOCKERFILE GENERATOR
# ============================================================================
generate_flask_dockerfile() {
    if [ "$MULTISTAGE" = true ]; then
        cat > Dockerfile << 'EOF'
FROM python:3.11-slim AS builder

WORKDIR /app
COPY requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt

FROM python:3.11-slim

WORKDIR /app

EOF
    else
        cat > Dockerfile << 'EOF'
FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

EOF
    fi

    if [ "$NONROOT" = true ]; then
        cat >> Dockerfile << 'EOF'
RUN useradd -m -u 1001 flask

EOF
    fi

    if [ "$MULTISTAGE" = true ]; then
        cat >> Dockerfile << 'EOF'
COPY --from=builder /root/.local /home/flask/.local

EOF
    fi

    cat >> Dockerfile << 'EOF'
COPY . .

EOF

    if [ "$NONROOT" = true ]; then
        cat >> Dockerfile << 'EOF'
RUN chown -R flask:flask /app
USER flask
ENV PATH=/home/flask/.local/bin:$PATH

EOF
    fi

    cat >> Dockerfile << EOF
EXPOSE ${APP_PORT}

EOF

    if [ "$HEALTHCHECK" = true ]; then
        cat >> Dockerfile << EOF
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \\
  CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:${APP_PORT}/health')" || exit 1

EOF
    fi

    cat >> Dockerfile << 'EOF'
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "4", "app:app"]
EOF

    cat > requirements.txt.example << 'EOF'
Flask>=3.0.0
gunicorn>=21.0.0
python-decouple>=3.8
EOF
    print_success "Created requirements.txt.example"
}

# ============================================================================
# FASTAPI DOCKERFILE GENERATOR
# ============================================================================
generate_fastapi_dockerfile() {
    if [ "$MULTISTAGE" = true ]; then
        cat > Dockerfile << 'EOF'
FROM python:3.11-slim AS builder

WORKDIR /app
COPY requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt

FROM python:3.11-slim

WORKDIR /app

EOF
    else
        cat > Dockerfile << 'EOF'
FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

EOF
    fi

    if [ "$NONROOT" = true ]; then
        cat >> Dockerfile << 'EOF'
RUN useradd -m -u 1001 fastapi

EOF
    fi

    if [ "$MULTISTAGE" = true ]; then
        cat >> Dockerfile << 'EOF'
COPY --from=builder /root/.local /home/fastapi/.local

EOF
    fi

    cat >> Dockerfile << 'EOF'
COPY . .

EOF

    if [ "$NONROOT" = true ]; then
        cat >> Dockerfile << 'EOF'
RUN chown -R fastapi:fastapi /app
USER fastapi
ENV PATH=/home/fastapi/.local/bin:$PATH

EOF
    fi

    cat >> Dockerfile << EOF
EXPOSE ${APP_PORT}

EOF

    if [ "$HEALTHCHECK" = true ]; then
        cat >> Dockerfile << EOF
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \\
  CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:${APP_PORT}/health')" || exit 1

EOF
    fi

    cat >> Dockerfile << 'EOF'
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000", "--workers", "4"]
EOF

    cat > requirements.txt.example << 'EOF'
fastapi>=0.104.0
uvicorn[standard]>=0.24.0
pydantic>=2.5.0
python-decouple>=3.8
EOF
    print_success "Created requirements.txt.example"
}

# ============================================================================
# LARAVEL DOCKERFILE GENERATOR
# ============================================================================
generate_laravel_dockerfile() {
    cat > Dockerfile << 'EOF'
FROM php:8.2-fpm-alpine

# Install dependencies
RUN apk add --no-cache \
    nginx \
    supervisor \
    nodejs \
    npm \
    && docker-php-ext-install pdo pdo_mysql opcache

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

# Copy composer files
COPY composer.json composer.lock ./

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader --no-scripts

# Copy application files
COPY . .

# Install npm dependencies and build assets
RUN npm ci && npm run build

# Set permissions
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Copy configurations
COPY docker/nginx/laravel.conf /etc/nginx/http.d/default.conf
COPY docker/supervisor/supervisord.conf /etc/supervisord.conf

EOF

    if [ "$NONROOT" = true ]; then
        cat >> Dockerfile << 'EOF'
USER www-data

EOF
    fi

    cat >> Dockerfile << EOF
EXPOSE ${APP_PORT}

EOF

    if [ "$HEALTHCHECK" = true ]; then
        cat >> Dockerfile << EOF
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \\
  CMD wget --no-verbose --tries=1 --spider http://localhost:${APP_PORT}/health || exit 1

EOF
    fi

    cat >> Dockerfile << 'EOF'
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
EOF

    # Create Laravel nginx config
    mkdir -p docker/nginx
    cat > docker/nginx/laravel.conf << 'EOF'
server {
    listen 9000;
    server_name _;
    root /var/www/html/public;
    index index.php index.html;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        fastcgi_pass 127.0.0.1:9000;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }

    location ~ /\.(?!well-known).* {
        deny all;
    }
}
EOF

    mkdir -p docker/supervisor
    cat > docker/supervisor/supervisord.conf << 'EOF'
[supervisord]
nodaemon=true
user=root

[program:php-fpm]
command=php-fpm -F
stdout_logfile=/dev/stdout
stdout_logfile_maxbytes=0
stderr_logfile=/dev/stderr
stderr_logfile_maxbytes=0

[program:nginx]
command=nginx -g 'daemon off;'
stdout_logfile=/dev/stdout
stdout_logfile_maxbytes=0
stderr_logfile=/dev/stderr
stderr_logfile_maxbytes=0
EOF
    print_success "Laravel configuration files created"
}

# ============================================================================
# SPRING BOOT DOCKERFILE GENERATOR
# ============================================================================
generate_springboot_dockerfile() {
    cat > Dockerfile << 'EOF'
# Multi-stage build for Spring Boot
FROM maven:3.9-eclipse-temurin-17 AS builder

WORKDIR /app

COPY pom.xml .
RUN mvn dependency:go-offline

COPY src ./src
RUN mvn clean package -DskipTests

# Production stage
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

EOF

    if [ "$NONROOT" = true ]; then
        cat >> Dockerfile << 'EOF'
RUN addgroup -g 1001 -S spring && adduser -S spring -u 1001 -G spring

EOF
    fi

    cat >> Dockerfile << 'EOF'
COPY --from=builder /app/target/*.jar app.jar

EOF

    if [ "$NONROOT" = true ]; then
        cat >> Dockerfile << 'EOF'
RUN chown spring:spring app.jar
USER spring

EOF
    fi

    cat >> Dockerfile << EOF
EXPOSE ${APP_PORT}

EOF

    if [ "$HEALTHCHECK" = true ]; then
        cat >> Dockerfile << EOF
HEALTHCHECK --interval=30s --timeout=3s --start-period=60s --retries=3 \\
  CMD wget --no-verbose --tries=1 --spider http://localhost:${APP_PORT}/actuator/health || exit 1

EOF
    fi

    cat >> Dockerfile << 'EOF'
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
EOF
}

# ============================================================================
# RAILS DOCKERFILE GENERATOR
# ============================================================================
generate_rails_dockerfile() {
    cat > Dockerfile << 'EOF'
FROM ruby:3.2-alpine

RUN apk add --no-cache \
    build-base \
    postgresql-dev \
    nodejs \
    yarn \
    tzdata

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 4 --retry 3

COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

COPY . .

# Precompile assets
RUN bundle exec rails assets:precompile

EOF

    if [ "$NONROOT" = true ]; then
        cat >> Dockerfile << 'EOF'
RUN addgroup -g 1001 -S rails && adduser -S rails -u 1001 -G rails
RUN chown -R rails:rails /app
USER rails

EOF
    fi

    cat >> Dockerfile << EOF
EXPOSE ${APP_PORT}

EOF

    if [ "$HEALTHCHECK" = true ]; then
        cat >> Dockerfile << EOF
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \\
  CMD wget --no-verbose --tries=1 --spider http://localhost:${APP_PORT}/health || exit 1

EOF
    fi

    cat >> Dockerfile << 'EOF'
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
EOF
}

# ============================================================================
# NGINX CONFIGURATION GENERATOR (for backend APIs)
# ============================================================================
generate_nginx_reverse_proxy() {
    mkdir -p nginx
    cat > nginx/nginx.conf << EOF
events {
    worker_connections 1024;
}

http {
    upstream backend {
        server app:${APP_PORT};
    }

    # Rate limiting
    limit_req_zone \$binary_remote_addr zone=api_limit:10m rate=10r/s;

    server {
        listen 80;
        server_name _;

        client_max_body_size 100M;

        # Rate limiting
        limit_req zone=api_limit burst=20 nodelay;

        location / {
            proxy_pass http://backend;
            proxy_set_header Host \$host;
            proxy_set_header X-Real-IP \$remote_addr;
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto \$scheme;
            
            # WebSocket support
            proxy_http_version 1.1;
            proxy_set_header Upgrade \$http_upgrade;
            proxy_set_header Connection "upgrade";
            
            # Timeouts
            proxy_connect_timeout 60s;
            proxy_send_timeout 60s;
            proxy_read_timeout 60s;
        }

        # Static files (if any)
        location /static/ {
            alias /var/www/static/;
            expires 1y;
            add_header Cache-Control "public, immutable";
        }

        # Health check
        location /nginx-health {
            access_log off;
            return 200 "healthy\n";
            add_header Content-Type text/plain;
        }
    }
}
EOF
    print_success "Nginx reverse proxy configuration created at nginx/nginx.conf"
}

# ============================================================================
# DOCKER-COMPOSE GENERATOR
# ============================================================================
generate_docker_compose() {
    cat > docker-compose.yml << EOF
version: '3.8'

services:
  app:
    build:
      context: .
      dockerfile: Dockerfile
    container_name: ${FRAMEWORK}_app
    restart: unless-stopped
    environment:
      - NODE_ENV=production
      - PORT=${APP_PORT}
    ports:
      - "${APP_PORT}:${APP_PORT}"
EOF

    if [ "$USE_NGINX" = true ] && [[ "$FRAMEWORK" != "react" && "$FRAMEWORK" != "vue" && "$FRAMEWORK" != "angular" ]]; then
        cat >> docker-compose.yml << EOF
    networks:
      - app-network

  nginx:
    image: nginx:alpine
    container_name: nginx_proxy
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf:ro
    depends_on:
      - app
    networks:
      - app-network

networks:
  app-network:
    driver: bridge
EOF
    fi

    # Add database if needed
    if [[ "$FRAMEWORK" == "django" || "$FRAMEWORK" == "rails" || "$FRAMEWORK" == "laravel" ]]; then
        cat >> docker-compose.yml << 'EOF'

  db:
    image: postgres:15-alpine
    container_name: postgres_db
    restart: unless-stopped
    environment:
      - POSTGRES_DB=appdb
      - POSTGRES_USER=appuser
      - POSTGRES_PASSWORD=changeme
    volumes:
      - postgres_data:/var/lib/postgresql/data
    networks:
      - app-network

volumes:
  postgres_data:
EOF
    fi

    print_success "docker-compose.yml created"
}

# ============================================================================
# DOCKERIGNORE GENERATOR
# ============================================================================
generate_dockerignore() {
    cat > .dockerignore << 'EOF'
# Git
.git
.gitignore
.gitattributes

# Documentation
README.md
LICENSE
*.md
docs/

# Dependencies
node_modules
vendor
venv
__pycache__
*.pyc
.pytest_cache

# IDE
.vscode
.idea
*.swp
*.swo
*.sublime-*

# Build artifacts
dist
build
*.log
.next
out

# Environment files
.env
.env.local
.env.*.local
*.env

# Testing
coverage
.nyc_output
*.test.js
*.spec.js
test/
tests/

# OS files
.DS_Store
Thumbs.db

# Docker
Dockerfile
docker-compose.yml
.dockerignore
EOF
    print_success ".dockerignore created"
}

# ============================================================================
# README GENERATOR
# ============================================================================
generate_readme() {
    cat > DOCKER_README.md << EOF
# Docker Deployment Guide

## Generated Configuration
- **Language**: ${LANGUAGE}
- **Framework**: ${FRAMEWORK}
- **Nginx**: ${USE_NGINX}
- **Multi-stage build**: ${MULTISTAGE}
- **Healthcheck**: ${HEALTHCHECK}
- **Non-root user**: ${NONROOT}
- **Application port**: ${APP_PORT}

## Build and Run

### Using Docker
\`\`\`bash
# Build the image
docker build -t ${FRAMEWORK}-app .

# Run the container
docker run -d -p ${APP_PORT}:${APP_PORT} --name ${FRAMEWORK}-app ${FRAMEWORK}-app
\`\`\`

### Using Docker Compose (Recommended)
\`\`\`bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f app

# Stop services
docker-compose down

# Rebuild after changes
docker-compose up -d --build
\`\`\`

## Framework-Specific Notes

EOF

    # Add framework-specific instructions
    case $FRAMEWORK in
        react|vue|angular)
            cat >> DOCKER_README.md << 'EOF'
### Frontend Application
Your application is built as static files and served with Nginx.

**Build command**: Ensure your package.json has a "build" script
**Output directory**: Build artifacts are automatically copied to Nginx

Access your application at: http://localhost:80
EOF
            ;;
        nextjs|nuxtjs)
            cat >> DOCKER_README.md << 'EOF'
### SSR/SSG Framework
Your application runs as a Node.js server with server-side rendering.

**Important**: For Next.js, ensure you have `output: 'standalone'` in next.config.js

Access your application at: http://localhost:${APP_PORT}
EOF
            ;;
        django)
            cat >> DOCKER_README.md << 'EOF'
### Django Application
**Required files**:
- requirements.txt (Python dependencies)
- manage.py (Django management script)

**Before building**:
1. Ensure your settings.py has proper ALLOWED_HOSTS
2. Configure database settings
3. Set SECRET_KEY via environment variable

**Static files**: Collected automatically during build

**Production server**: Gunicorn (4 workers)
EOF
            ;;
        flask)
            cat >> DOCKER_README.md << 'EOF'
### Flask Application
**Required files**:
- requirements.txt (Python dependencies)
- app.py (Flask application)

**Production server**: Gunicorn (4 workers)
EOF
            ;;
        fastapi)
            cat >> DOCKER_README.md << 'EOF'
### FastAPI Application
**Required files**:
- requirements.txt (Python dependencies)
- main.py (FastAPI application)

**Production server**: Uvicorn (4 workers)
**API Docs**: Available at /docs and /redoc
EOF
            ;;
        laravel)
            cat >> DOCKER_README.md << 'EOF'
### Laravel Application
**Required files**:
- composer.json (PHP dependencies)
- package.json (Node dependencies for assets)

**Before building**:
1. Configure .env file
2. Run php artisan key:generate locally
3. Set up database configuration

**Services running**:
- PHP-FPM (backend)
- Nginx (web server)
- Supervised by Supervisor
EOF
            ;;
        springboot)
            cat >> DOCKER_README.md << 'EOF'
### Spring Boot Application
**Required files**:
- pom.xml (Maven dependencies)
- src/ (source code)

**Health endpoint**: /actuator/health
**Profile**: Set SPRING_PROFILES_ACTIVE environment variable
EOF
            ;;
        rails)
            cat >> DOCKER_README.md << 'EOF'
### Ruby on Rails Application
**Required files**:
- Gemfile (Ruby dependencies)
- package.json (JavaScript dependencies)

**Before building**:
1. Configure database.yml
2. Set SECRET_KEY_BASE environment variable

**Assets**: Precompiled automatically
EOF
            ;;
    esac

    cat >> DOCKER_README.md << EOF

## Environment Variables

Create a \`.env\` file for environment-specific configuration:

\`\`\`env
# Application
APP_ENV=production
APP_PORT=${APP_PORT}

# Database (if applicable)
DB_HOST=db
DB_PORT=5432
DB_NAME=appdb
DB_USER=appuser
DB_PASSWORD=changeme

# Security
SECRET_KEY=your-secret-key-here
EOF

    if [[ "$FRAMEWORK" == "django" ]]; then
        cat >> DOCKER_README.md << 'EOF'
DJANGO_SECRET_KEY=your-django-secret-key
ALLOWED_HOSTS=localhost,127.0.0.1
EOF
    fi

    cat >> DOCKER_README.md << 'EOF'
```

## Production Deployment Checklist

- [ ] Change all default passwords
- [ ] Set proper environment variables
- [ ] Configure SSL/TLS certificates
- [ ] Set up database backups
- [ ] Configure logging and monitoring
- [ ] Implement rate limiting
- [ ] Set up health checks
- [ ] Configure auto-restart policies
- [ ] Scan images for vulnerabilities
- [ ] Set resource limits (CPU/Memory)

## Security Best Practices

1. **Secrets Management**: Use Docker secrets or external vaults
2. **Network Isolation**: Use Docker networks
3. **Regular Updates**: Keep base images updated
4. **Scan Images**: Use tools like Trivy or Snyk
5. **Minimal Permissions**: Run as non-root user (enabled in your config)

## Monitoring

### View logs
```bash
docker-compose logs -f app
```

### Check container health
```bash
docker ps
docker inspect <container_id>
```

### Resource usage
```bash
docker stats
```

## Troubleshooting

### Container won't start
```bash
docker-compose logs app
```

### Port already in use
```bash
# Change port in docker-compose.yml
ports:
  - "8080:${APP_PORT}"  # Use 8080 instead
```

### Permission issues
Check that non-root user has proper permissions

## Additional Resources

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)
- [Security Best Practices](https://docs.docker.com/develop/security-best-practices/)
EOF

    print_success "DOCKER_README.md created with detailed instructions"
}

# ============================================================================
# MAIN ORCHESTRATION
# ============================================================================
main() {
    display_header
    
    print_info "Starting Advanced Dockerfile generation process..."
    echo ""
    
    # Collect user inputs
    select_language_and_framework
    ask_nginx
    ask_additional_options
    
    echo ""
    print_info "Generating files for $FRAMEWORK..."
    echo ""
    
    # Generate Dockerfile based on framework
    case $FRAMEWORK in
        react) generate_react_dockerfile ;;
        nextjs) generate_nextjs_dockerfile ;;
        vue) generate_vue_dockerfile ;;
        angular) generate_angular_dockerfile ;;
        express) generate_express_dockerfile ;;
        nestjs) generate_nestjs_dockerfile ;;
        nodejs) generate_express_dockerfile ;;
        django) generate_django_dockerfile ;;
        flask) generate_flask_dockerfile ;;
        fastapi) generate_fastapi_dockerfile ;;
        laravel) generate_laravel_dockerfile ;;
        springboot) generate_springboot_dockerfile ;;
        rails) generate_rails_dockerfile ;;
        *) 
            print_error "Framework $FRAMEWORK not yet implemented"
            exit 1
            ;;
    esac
    
    print_success "Dockerfile created for $FRAMEWORK"
    
    # Generate additional files
    if [ "$USE_NGINX" = true ] && [[ "$FRAMEWORK" != "react" && "$FRAMEWORK" != "vue" && "$FRAMEWORK" != "angular" ]]; then
        generate_nginx_reverse_proxy
    fi
    
    generate_docker_compose
    generate_dockerignore
    generate_readme
    
    echo ""
    print_success "========================================================"
    print_success "   All files generated successfully!                   "
    print_success "========================================================"
    echo ""
    print_info "Generated files:"
    echo "  ✓ Dockerfile (optimized for $FRAMEWORK)"
    echo "  ✓ docker-compose.yml"
    echo "  ✓ .dockerignore"
    echo "  ✓ DOCKER_README.md"
    
    if [[ "$FRAMEWORK" == "react" || "$FRAMEWORK" == "vue" || "$FRAMEWORK" == "angular" ]]; then
        echo "  ✓ nginx.conf (for serving static files)"
    elif [ "$USE_NGINX" = true ]; then
        echo "  ✓ nginx/nginx.conf (reverse proxy)"
    fi
    
    if [[ "$FRAMEWORK" == "laravel" ]]; then
        echo "  ✓ docker/nginx/laravel.conf"
        echo "  ✓ docker/supervisor/supervisord.conf"
    fi
    
    if [[ "$FRAMEWORK" == "django" || "$FRAMEWORK" == "flask" || "$FRAMEWORK" == "fastapi" ]]; then
        echo "  ✓ requirements.txt.example"
    fi
    
    echo ""
    print_info "Next steps:"
    echo "  1. Review the generated Dockerfile and configurations"
    echo "  2. Customize environment variables in docker-compose.yml"
    if [[ "$FRAMEWORK" == "django" || "$FRAMEWORK" == "flask" || "$FRAMEWORK" == "fastapi" ]]; then
        echo "  3. Rename requirements.txt.example to requirements.txt and add dependencies"
    fi
    echo "  4. Build and test: docker-compose up --build"
    echo ""
    print_info "For detailed instructions, see DOCKER_README.md"
    echo ""
    print_warning "Remember to:"
    echo "  • Change default passwords in docker-compose.yml"
    echo "  • Configure environment variables for production"
    echo "  • Set up SSL/TLS for HTTPS"
    echo "  • Review security settings"
}

# Run main function
main
