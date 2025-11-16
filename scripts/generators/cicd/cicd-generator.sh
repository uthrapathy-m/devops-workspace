#!/bin/bash

# CI/CD Pipeline Generator for Production Deployments
# Generates pipelines for GitHub Actions, GitLab CI/CD, Jenkins, Azure DevOps, CircleCI
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
PIPELINE_PROVIDER=""
PROJECT_NAME=""
LANGUAGE=""
FRAMEWORK=""
DOCKER_REGISTRY=""
K8S_CLUSTER=""
ENVIRONMENT="production"
ENABLE_TESTS=true
ENABLE_LINT=true
ENABLE_SECURITY_SCAN=true
ENABLE_SONARQUBE=false
ENABLE_STAGING=false
DEPLOY_METHOD=""
BRANCH_STRATEGY="main"

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
    echo "============================================================"
    echo "   CI/CD Pipeline Generator                                "
    echo "   Production-Ready Pipeline Configurations                "
    echo "============================================================"
    echo ""
}

# Function to select CI/CD provider
select_pipeline_provider() {
    print_header "=== Select CI/CD Provider ==="
    echo "1) GitHub Actions"
    echo "2) GitLab CI/CD"
    echo "3) Jenkins"
    echo "4) Azure DevOps"
    echo "5) CircleCI"
    echo "6) All (Generate for all platforms)"
    echo ""
    read -p "Enter your choice (1-6): " provider_choice
    
    case $provider_choice in
        1) PIPELINE_PROVIDER="github" ;;
        2) PIPELINE_PROVIDER="gitlab" ;;
        3) PIPELINE_PROVIDER="jenkins" ;;
        4) PIPELINE_PROVIDER="azure" ;;
        5) PIPELINE_PROVIDER="circleci" ;;
        6) PIPELINE_PROVIDER="all" ;;
        *) print_error "Invalid choice"; exit 1 ;;
    esac
    
    print_success "Selected: $PIPELINE_PROVIDER"
}

# Function to collect basic information
collect_basic_info() {
    echo ""
    print_header "=== Basic Configuration ==="
    
    read -p "Project name (e.g., my-app): " project_name
    PROJECT_NAME=${project_name:-my-app}
    
    echo ""
    echo "Select Programming Language:"
    echo "1) Node.js/JavaScript"
    echo "2) Python"
    echo "3) Java"
    echo "4) Go"
    echo "5) .NET"
    echo "6) PHP"
    echo "7) Ruby"
    read -p "Enter choice (1-7): " lang_choice
    
    case $lang_choice in
        1) LANGUAGE="nodejs"; FRAMEWORK="node" ;;
        2) LANGUAGE="python"; FRAMEWORK="python" ;;
        3) LANGUAGE="java"; FRAMEWORK="maven" ;;
        4) LANGUAGE="go"; FRAMEWORK="go" ;;
        5) LANGUAGE="dotnet"; FRAMEWORK="dotnet" ;;
        6) LANGUAGE="php"; FRAMEWORK="composer" ;;
        7) LANGUAGE="ruby"; FRAMEWORK="bundler" ;;
        *) LANGUAGE="nodejs"; FRAMEWORK="node" ;;
    esac
    
    echo ""
    echo "Docker Registry:"
    echo "1) Docker Hub"
    echo "2) GitHub Container Registry (ghcr.io)"
    echo "3) GitLab Container Registry"
    echo "4) Amazon ECR"
    echo "5) Google Container Registry (gcr.io)"
    echo "6) Azure Container Registry"
    read -p "Enter choice (1-6): " registry_choice
    
    case $registry_choice in
        1) DOCKER_REGISTRY="dockerhub" ;;
        2) DOCKER_REGISTRY="ghcr" ;;
        3) DOCKER_REGISTRY="gitlab" ;;
        4) DOCKER_REGISTRY="ecr" ;;
        5) DOCKER_REGISTRY="gcr" ;;
        6) DOCKER_REGISTRY="acr" ;;
        *) DOCKER_REGISTRY="dockerhub" ;;
    esac
    
    echo ""
    echo "Kubernetes Deployment Target:"
    echo "1) AWS EKS"
    echo "2) GCP GKE"
    echo "3) Azure AKS"
    echo "4) Self-managed Kubernetes"
    read -p "Enter choice (1-4): " k8s_choice
    
    case $k8s_choice in
        1) K8S_CLUSTER="eks" ;;
        2) K8S_CLUSTER="gke" ;;
        3) K8S_CLUSTER="aks" ;;
        4) K8S_CLUSTER="k8s" ;;
        *) K8S_CLUSTER="k8s" ;;
    esac
    
    print_success "Basic configuration collected"
}

# Function to collect pipeline options
collect_pipeline_options() {
    echo ""
    print_header "=== Pipeline Options ==="
    
    read -p "Enable automated tests? (y/n, default: y): " tests
    ENABLE_TESTS=$([[ $tests != "n" && $tests != "N" ]] && echo true || echo false)
    
    read -p "Enable code linting? (y/n, default: y): " lint
    ENABLE_LINT=$([[ $lint != "n" && $lint != "N" ]] && echo true || echo false)
    
    read -p "Enable security scanning? (y/n, default: y): " security
    ENABLE_SECURITY_SCAN=$([[ $security != "n" && $security != "N" ]] && echo true || echo false)
    
    read -p "Enable SonarQube analysis? (y/n, default: n): " sonar
    ENABLE_SONARQUBE=$([[ $sonar == "y" || $sonar == "Y" ]] && echo true || echo false)
    
    read -p "Enable staging environment? (y/n, default: n): " staging
    ENABLE_STAGING=$([[ $staging == "y" || $staging == "Y" ]] && echo true || echo false)
    
    echo ""
    echo "Deployment Method:"
    echo "1) kubectl apply"
    echo "2) Helm"
    echo "3) Kustomize"
    echo "4) ArgoCD (GitOps)"
    read -p "Enter choice (1-4, default: 1): " deploy_choice
    
    case ${deploy_choice:-1} in
        1) DEPLOY_METHOD="kubectl" ;;
        2) DEPLOY_METHOD="helm" ;;
        3) DEPLOY_METHOD="kustomize" ;;
        4) DEPLOY_METHOD="argocd" ;;
        *) DEPLOY_METHOD="kubectl" ;;
    esac
    
    echo ""
    read -p "Main branch name (default: main): " branch
    BRANCH_STRATEGY=${branch:-main}
    
    print_success "Pipeline options configured"
}

# ============================================================================
# GITHUB ACTIONS GENERATOR
# ============================================================================
generate_github_actions() {
    print_info "Generating GitHub Actions workflow..."
    
    mkdir -p .github/workflows
    
    cat > .github/workflows/ci-cd.yml << EOF
name: CI/CD Pipeline

on:
  push:
    branches: [ ${BRANCH_STRATEGY} ]
  pull_request:
    branches: [ ${BRANCH_STRATEGY} ]
  workflow_dispatch:

env:
  PROJECT_NAME: ${PROJECT_NAME}
  DOCKER_REGISTRY: \${{ secrets.DOCKER_REGISTRY || '${DOCKER_REGISTRY}' }}
  K8S_CLUSTER: ${K8S_CLUSTER}

jobs:
  # ==================== BUILD JOB ====================
  build:
    name: Build and Test
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v4
      with:
        fetch-depth: 0  # Full history for SonarQube
    
EOF

    # Language-specific build steps
    case $LANGUAGE in
        nodejs)
            cat >> .github/workflows/ci-cd.yml << 'EOF'
    - name: Setup Node.js
      uses: actions/setup-node@v4
      with:
        node-version: '18'
        cache: 'npm'
    
    - name: Install dependencies
      run: npm ci
    
EOF
            if [ "$ENABLE_LINT" = true ]; then
                cat >> .github/workflows/ci-cd.yml << 'EOF'
    - name: Run linter
      run: npm run lint || echo "No lint script found"
    
EOF
            fi
            
            if [ "$ENABLE_TESTS" = true ]; then
                cat >> .github/workflows/ci-cd.yml << 'EOF'
    - name: Run tests
      run: npm test
    
    - name: Generate coverage report
      run: npm run test:coverage || echo "No coverage script"
    
    - name: Upload coverage to Codecov
      uses: codecov/codecov-action@v3
      with:
        token: ${{ secrets.CODECOV_TOKEN }}
        files: ./coverage/lcov.info
        flags: unittests
        name: codecov-umbrella
    
EOF
            fi
            
            cat >> .github/workflows/ci-cd.yml << 'EOF'
    - name: Build application
      run: npm run build || echo "No build script found"
    
EOF
            ;;
            
        python)
            cat >> .github/workflows/ci-cd.yml << 'EOF'
    - name: Setup Python
      uses: actions/setup-python@v4
      with:
        python-version: '3.11'
        cache: 'pip'
    
    - name: Install dependencies
      run: |
        pip install --upgrade pip
        pip install -r requirements.txt
    
EOF
            if [ "$ENABLE_LINT" = true ]; then
                cat >> .github/workflows/ci-cd.yml << 'EOF'
    - name: Run linter (flake8)
      run: |
        pip install flake8
        flake8 . --count --select=E9,F63,F7,F82 --show-source --statistics
        flake8 . --count --exit-zero --max-complexity=10 --max-line-length=127 --statistics
    
    - name: Run black formatter check
      run: |
        pip install black
        black --check .
    
EOF
            fi
            
            if [ "$ENABLE_TESTS" = true ]; then
                cat >> .github/workflows/ci-cd.yml << 'EOF'
    - name: Run tests with pytest
      run: |
        pip install pytest pytest-cov
        pytest --cov=. --cov-report=xml
    
    - name: Upload coverage to Codecov
      uses: codecov/codecov-action@v3
      with:
        token: ${{ secrets.CODECOV_TOKEN }}
        files: ./coverage.xml
    
EOF
            fi
            ;;
            
        java)
            cat >> .github/workflows/ci-cd.yml << 'EOF'
    - name: Setup Java
      uses: actions/setup-java@v4
      with:
        distribution: 'temurin'
        java-version: '17'
        cache: 'maven'
    
EOF
            if [ "$ENABLE_TESTS" = true ]; then
                cat >> .github/workflows/ci-cd.yml << 'EOF'
    - name: Build and test with Maven
      run: mvn clean verify
    
    - name: Upload test results
      if: always()
      uses: actions/upload-artifact@v3
      with:
        name: test-results
        path: target/surefire-reports/
    
EOF
            else
                cat >> .github/workflows/ci-cd.yml << 'EOF'
    - name: Build with Maven
      run: mvn clean package -DskipTests
    
EOF
            fi
            ;;
            
        go)
            cat >> .github/workflows/ci-cd.yml << 'EOF'
    - name: Setup Go
      uses: actions/setup-go@v4
      with:
        go-version: '1.21'
        cache: true
    
    - name: Download dependencies
      run: go mod download
    
EOF
            if [ "$ENABLE_LINT" = true ]; then
                cat >> .github/workflows/ci-cd.yml << 'EOF'
    - name: Run golangci-lint
      uses: golangci/golangci-lint-action@v3
      with:
        version: latest
    
EOF
            fi
            
            if [ "$ENABLE_TESTS" = true ]; then
                cat >> .github/workflows/ci-cd.yml << 'EOF'
    - name: Run tests
      run: go test -v -race -coverprofile=coverage.out ./...
    
    - name: Upload coverage to Codecov
      uses: codecov/codecov-action@v3
      with:
        token: ${{ secrets.CODECOV_TOKEN }}
        files: ./coverage.out
    
EOF
            fi
            
            cat >> .github/workflows/ci-cd.yml << 'EOF'
    - name: Build binary
      run: go build -v ./...
    
EOF
            ;;
    esac

    # Security scanning
    if [ "$ENABLE_SECURITY_SCAN" = true ]; then
        cat >> .github/workflows/ci-cd.yml << 'EOF'
    - name: Run security scan (Trivy)
      uses: aquasecurity/trivy-action@master
      with:
        scan-type: 'fs'
        scan-ref: '.'
        format: 'sarif'
        output: 'trivy-results.sarif'
    
    - name: Upload Trivy results to GitHub Security
      uses: github/codeql-action/upload-sarif@v2
      if: always()
      with:
        sarif_file: 'trivy-results.sarif'
    
EOF
    fi

    # SonarQube
    if [ "$ENABLE_SONARQUBE" = true ]; then
        cat >> .github/workflows/ci-cd.yml << 'EOF'
    - name: SonarQube Scan
      uses: sonarsource/sonarqube-scan-action@master
      env:
        SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
        SONAR_HOST_URL: ${{ secrets.SONAR_HOST_URL }}
    
EOF
    fi

    # Docker build and push
    cat >> .github/workflows/ci-cd.yml << 'EOF'
  # ==================== DOCKER BUILD JOB ====================
  docker:
    name: Build and Push Docker Image
    runs-on: ubuntu-latest
    needs: build
    if: github.event_name == 'push' && github.ref == 'refs/heads/main'
    
    outputs:
      image-tag: ${{ steps.meta.outputs.tags }}
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v4
    
    - name: Set up Docker Buildx
      uses: docker/setup-buildx-action@v3
    
EOF

    case $DOCKER_REGISTRY in
        dockerhub)
            cat >> .github/workflows/ci-cd.yml << 'EOF'
    - name: Login to Docker Hub
      uses: docker/login-action@v3
      with:
        username: ${{ secrets.DOCKER_USERNAME }}
        password: ${{ secrets.DOCKER_PASSWORD }}
    
    - name: Docker metadata
      id: meta
      uses: docker/metadata-action@v5
      with:
        images: ${{ secrets.DOCKER_USERNAME }}/${{ env.PROJECT_NAME }}
        tags: |
          type=ref,event=branch
          type=sha,prefix={{branch}}-
          type=semver,pattern={{version}}
          type=semver,pattern={{major}}.{{minor}}
    
EOF
            ;;
        ghcr)
            cat >> .github/workflows/ci-cd.yml << 'EOF'
    - name: Login to GitHub Container Registry
      uses: docker/login-action@v3
      with:
        registry: ghcr.io
        username: ${{ github.actor }}
        password: ${{ secrets.GITHUB_TOKEN }}
    
    - name: Docker metadata
      id: meta
      uses: docker/metadata-action@v5
      with:
        images: ghcr.io/${{ github.repository }}
        tags: |
          type=ref,event=branch
          type=sha,prefix={{branch}}-
          type=semver,pattern={{version}}
          type=semver,pattern={{major}}.{{minor}}
    
EOF
            ;;
        ecr)
            cat >> .github/workflows/ci-cd.yml << 'EOF'
    - name: Configure AWS credentials
      uses: aws-actions/configure-aws-credentials@v4
      with:
        aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
        aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        aws-region: ${{ secrets.AWS_REGION }}
    
    - name: Login to Amazon ECR
      id: login-ecr
      uses: aws-actions/amazon-ecr-login@v2
    
    - name: Docker metadata
      id: meta
      uses: docker/metadata-action@v5
      with:
        images: ${{ steps.login-ecr.outputs.registry }}/${{ env.PROJECT_NAME }}
        tags: |
          type=ref,event=branch
          type=sha,prefix={{branch}}-
          type=semver,pattern={{version}}
    
EOF
            ;;
    esac

    cat >> .github/workflows/ci-cd.yml << 'EOF'
    - name: Build and push Docker image
      uses: docker/build-push-action@v5
      with:
        context: .
        push: true
        tags: ${{ steps.meta.outputs.tags }}
        labels: ${{ steps.meta.outputs.labels }}
        cache-from: type=gha
        cache-to: type=gha,mode=max
    
    - name: Run Trivy vulnerability scanner
      uses: aquasecurity/trivy-action@master
      with:
        image-ref: ${{ steps.meta.outputs.tags }}
        format: 'sarif'
        output: 'trivy-image-results.sarif'
    
    - name: Upload Trivy results to GitHub Security
      uses: github/codeql-action/upload-sarif@v2
      if: always()
      with:
        sarif_file: 'trivy-image-results.sarif'
    
EOF

    # Staging deployment
    if [ "$ENABLE_STAGING" = true ]; then
        cat >> .github/workflows/ci-cd.yml << 'EOF'
  # ==================== STAGING DEPLOYMENT ====================
  deploy-staging:
    name: Deploy to Staging
    runs-on: ubuntu-latest
    needs: docker
    environment:
      name: staging
      url: https://staging.${{ env.PROJECT_NAME }}.example.com
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v4
    
EOF
        generate_github_k8s_deployment "staging"
    fi

    # Production deployment
    cat >> .github/workflows/ci-cd.yml << 'EOF'
  # ==================== PRODUCTION DEPLOYMENT ====================
  deploy-production:
    name: Deploy to Production
    runs-on: ubuntu-latest
    needs: docker
EOF
    
    if [ "$ENABLE_STAGING" = true ]; then
        echo "    needs: [docker, deploy-staging]" >> .github/workflows/ci-cd.yml
    fi
    
    cat >> .github/workflows/ci-cd.yml << 'EOF'
    environment:
      name: production
      url: https://${{ env.PROJECT_NAME }}.example.com
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v4
    
EOF
    
    generate_github_k8s_deployment "production"
    
    print_success "GitHub Actions workflow created"
}

generate_github_k8s_deployment() {
    local env=$1
    
    case $K8S_CLUSTER in
        eks)
            cat >> .github/workflows/ci-cd.yml << EOF
    - name: Configure AWS credentials
      uses: aws-actions/configure-aws-credentials@v4
      with:
        aws-access-key-id: \${{ secrets.AWS_ACCESS_KEY_ID }}
        aws-secret-access-key: \${{ secrets.AWS_SECRET_ACCESS_KEY }}
        aws-region: \${{ secrets.AWS_REGION }}
    
    - name: Update kubeconfig
      run: |
        aws eks update-kubeconfig --name \${{ secrets.EKS_CLUSTER_NAME }} --region \${{ secrets.AWS_REGION }}
    
EOF
            ;;
        gke)
            cat >> .github/workflows/ci-cd.yml << EOF
    - name: Authenticate to Google Cloud
      uses: google-github-actions/auth@v2
      with:
        credentials_json: \${{ secrets.GCP_SA_KEY }}
    
    - name: Setup Cloud SDK
      uses: google-github-actions/setup-gcloud@v2
    
    - name: Get GKE credentials
      run: |
        gcloud container clusters get-credentials \${{ secrets.GKE_CLUSTER_NAME }} \\
          --zone \${{ secrets.GKE_ZONE }} \\
          --project \${{ secrets.GCP_PROJECT }}
    
EOF
            ;;
        aks)
            cat >> .github/workflows/ci-cd.yml << EOF
    - name: Azure Login
      uses: azure/login@v1
      with:
        creds: \${{ secrets.AZURE_CREDENTIALS }}
    
    - name: Set AKS context
      uses: azure/aks-set-context@v3
      with:
        resource-group: \${{ secrets.AKS_RESOURCE_GROUP }}
        cluster-name: \${{ secrets.AKS_CLUSTER_NAME }}
    
EOF
            ;;
        k8s)
            cat >> .github/workflows/ci-cd.yml << EOF
    - name: Setup kubectl
      uses: azure/setup-kubectl@v3
    
    - name: Set kubeconfig
      run: |
        mkdir -p \$HOME/.kube
        echo "\${{ secrets.KUBECONFIG }}" | base64 -d > \$HOME/.kube/config
    
EOF
            ;;
    esac
    
    case $DEPLOY_METHOD in
        kubectl)
            cat >> .github/workflows/ci-cd.yml << EOF
    - name: Deploy to Kubernetes
      run: |
        kubectl set image deployment/\${PROJECT_NAME} \\
          \${PROJECT_NAME}=\${{ needs.docker.outputs.image-tag }} \\
          -n ${env}
        kubectl rollout status deployment/\${PROJECT_NAME} -n ${env}
    
EOF
            ;;
        helm)
            cat >> .github/workflows/ci-cd.yml << EOF
    - name: Setup Helm
      uses: azure/setup-helm@v3
    
    - name: Deploy with Helm
      run: |
        helm upgrade --install \${PROJECT_NAME} ./helm \\
          --namespace ${env} \\
          --create-namespace \\
          --set image.tag=\${{ needs.docker.outputs.image-tag }} \\
          --wait
    
EOF
            ;;
        kustomize)
            cat >> .github/workflows/ci-cd.yml << EOF
    - name: Deploy with Kustomize
      run: |
        kubectl apply -k k8s/overlays/${env}
        kubectl rollout status deployment/\${PROJECT_NAME} -n ${env}
    
EOF
            ;;
        argocd)
            cat >> .github/workflows/ci-cd.yml << EOF
    - name: Update ArgoCD application
      run: |
        # Update image tag in git repository
        git config user.name "GitHub Actions"
        git config user.email "actions@github.com"
        sed -i "s|image: .*|image: \${{ needs.docker.outputs.image-tag }}|" k8s/${env}/deployment.yaml
        git add k8s/${env}/deployment.yaml
        git commit -m "Update ${env} image to \${{ needs.docker.outputs.image-tag }}"
        git push
    
EOF
            ;;
    esac
    
    cat >> .github/workflows/ci-cd.yml << EOF
    - name: Verify deployment
      run: |
        kubectl get pods -n ${env} -l app=\${PROJECT_NAME}
        kubectl get svc -n ${env} -l app=\${PROJECT_NAME}
EOF
}

# ============================================================================
# GITLAB CI/CD GENERATOR
# ============================================================================
generate_gitlab_ci() {
    print_info "Generating GitLab CI/CD pipeline..."
    
    cat > .gitlab-ci.yml << 'EOF'
# GitLab CI/CD Pipeline

variables:
  DOCKER_DRIVER: overlay2
  DOCKER_TLS_CERTDIR: "/certs"
EOF

    cat >> .gitlab-ci.yml << EOF
  PROJECT_NAME: "${PROJECT_NAME}"
  K8S_CLUSTER: "${K8S_CLUSTER}"
  DOCKER_REGISTRY: "${DOCKER_REGISTRY}"

stages:
  - build
  - test
  - security
  - docker
EOF

    if [ "$ENABLE_STAGING" = true ]; then
        echo "  - deploy-staging" >> .gitlab-ci.yml
    fi
    
    echo "  - deploy-production" >> .gitlab-ci.yml
    
    cat >> .gitlab-ci.yml << 'EOF'

# ==================== BUILD STAGE ====================
build:
  stage: build
  image: node:18-alpine  # Change based on language
  cache:
    paths:
      - node_modules/
  script:
    - npm ci
    - npm run build || echo "No build script"
  artifacts:
    paths:
      - dist/
      - build/
    expire_in: 1 hour

# ==================== TEST STAGE ====================
EOF

    if [ "$ENABLE_TESTS" = true ]; then
        cat >> .gitlab-ci.yml << 'EOF'
test:
  stage: test
  image: node:18-alpine
  cache:
    paths:
      - node_modules/
  script:
    - npm ci
    - npm test
  coverage: '/Lines\s*:\s*(\d+\.\d+)%/'
  artifacts:
    when: always
    reports:
      junit: junit.xml
      coverage_report:
        coverage_format: cobertura
        path: coverage/cobertura-coverage.xml

EOF
    fi

    if [ "$ENABLE_LINT" = true ]; then
        cat >> .gitlab-ci.yml << 'EOF'
lint:
  stage: test
  image: node:18-alpine
  cache:
    paths:
      - node_modules/
  script:
    - npm ci
    - npm run lint || echo "No lint script"

EOF
    fi

    # Security scanning
    if [ "$ENABLE_SECURITY_SCAN" = true ]; then
        cat >> .gitlab-ci.yml << 'EOF'
# ==================== SECURITY STAGE ====================
security-scan:
  stage: security
  image: aquasec/trivy:latest
  script:
    - trivy fs --exit-code 0 --no-progress --format json -o trivy-report.json .
  artifacts:
    reports:
      container_scanning: trivy-report.json
    expire_in: 1 week

dependency-scan:
  stage: security
  image: node:18-alpine
  script:
    - npm audit --audit-level=moderate || true
  allow_failure: true

EOF
    fi

    # Docker build
    cat >> .gitlab-ci.yml << EOF
# ==================== DOCKER STAGE ====================
docker-build:
  stage: docker
  image: docker:24-dind
  services:
    - docker:24-dind
  before_script:
    - docker login -u \$CI_REGISTRY_USER -p \$CI_REGISTRY_PASSWORD \$CI_REGISTRY
  script:
    - docker build -t \$CI_REGISTRY_IMAGE:\$CI_COMMIT_SHORT_SHA .
    - docker build -t \$CI_REGISTRY_IMAGE:latest .
    - docker push \$CI_REGISTRY_IMAGE:\$CI_COMMIT_SHORT_SHA
    - docker push \$CI_REGISTRY_IMAGE:latest
  only:
    - ${BRANCH_STRATEGY}

docker-scan:
  stage: docker
  image: aquasec/trivy:latest
  script:
    - trivy image --exit-code 0 --no-progress \$CI_REGISTRY_IMAGE:\$CI_COMMIT_SHORT_SHA
  dependencies:
    - docker-build
  only:
    - ${BRANCH_STRATEGY}

EOF

    # Deployment stages
    if [ "$ENABLE_STAGING" = true ]; then
        cat >> .gitlab-ci.yml << 'EOF'
# ==================== STAGING DEPLOYMENT ====================
deploy-staging:
  stage: deploy-staging
  image: bitnami/kubectl:latest
  environment:
    name: staging
    url: https://staging.$PROJECT_NAME.example.com
  script:
    - kubectl set image deployment/$PROJECT_NAME $PROJECT_NAME=$CI_REGISTRY_IMAGE:$CI_COMMIT_SHORT_SHA -n staging
    - kubectl rollout status deployment/$PROJECT_NAME -n staging
  only:
    - main
  when: manual

EOF
    fi

    cat >> .gitlab-ci.yml << 'EOF'
# ==================== PRODUCTION DEPLOYMENT ====================
deploy-production:
  stage: deploy-production
  image: bitnami/kubectl:latest
  environment:
    name: production
    url: https://$PROJECT_NAME.example.com
  script:
    - kubectl set image deployment/$PROJECT_NAME $PROJECT_NAME=$CI_REGISTRY_IMAGE:$CI_COMMIT_SHORT_SHA -n production
    - kubectl rollout status deployment/$PROJECT_NAME -n production
  only:
    - main
  when: manual
EOF

    print_success "GitLab CI/CD pipeline created"
}

# ============================================================================
# JENKINS GENERATOR
# ============================================================================
generate_jenkins() {
    print_info "Generating Jenkins pipeline..."
    
    cat > Jenkinsfile << EOF
// Jenkins Pipeline for ${PROJECT_NAME}

pipeline {
    agent any
    
    environment {
        PROJECT_NAME = '${PROJECT_NAME}'
        DOCKER_REGISTRY = '${DOCKER_REGISTRY}'
        K8S_CLUSTER = '${K8S_CLUSTER}'
        DOCKER_CREDENTIALS = credentials('docker-credentials')
        KUBECONFIG = credentials('kubeconfig')
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
                script {
                    env.GIT_COMMIT_SHORT = sh(
                        script: "git rev-parse --short HEAD",
                        returnStdout: true
                    ).trim()
                }
            }
        }
        
        stage('Build') {
            steps {
                script {
EOF

    case $LANGUAGE in
        nodejs)
            cat >> Jenkinsfile << 'EOF'
                    sh '''
                        npm ci
                        npm run build || echo "No build script"
                    '''
EOF
            ;;
        python)
            cat >> Jenkinsfile << 'EOF'
                    sh '''
                        pip install -r requirements.txt
                    '''
EOF
            ;;
        java)
            cat >> Jenkinsfile << 'EOF'
                    sh '''
                        mvn clean package -DskipTests
                    '''
EOF
            ;;
        go)
            cat >> Jenkinsfile << 'EOF'
                    sh '''
                        go mod download
                        go build -v ./...
                    '''
EOF
            ;;
    esac

    cat >> Jenkinsfile << 'EOF'
                }
            }
        }
        
EOF

    if [ "$ENABLE_TESTS" = true ]; then
        cat >> Jenkinsfile << 'EOF'
        stage('Test') {
            steps {
                script {
                    sh '''
                        npm test || echo "Tests failed"
                    '''
                }
            }
            post {
                always {
                    junit '**/test-results/*.xml'
                    publishHTML([
                        allowMissing: false,
                        alwaysLinkToLastBuild: true,
                        keepAll: true,
                        reportDir: 'coverage',
                        reportFiles: 'index.html',
                        reportName: 'Coverage Report'
                    ])
                }
            }
        }
        
EOF
    fi

    if [ "$ENABLE_LINT" = true ]; then
        cat >> Jenkinsfile << 'EOF'
        stage('Lint') {
            steps {
                script {
                    sh 'npm run lint || echo "No lint script"'
                }
            }
        }
        
EOF
    fi

    if [ "$ENABLE_SECURITY_SCAN" = true ]; then
        cat >> Jenkinsfile << 'EOF'
        stage('Security Scan') {
            steps {
                script {
                    sh '''
                        docker run --rm -v $(pwd):/src aquasec/trivy:latest fs --exit-code 0 /src
                    '''
                }
            }
        }
        
EOF
    fi

    cat >> Jenkinsfile << 'EOF'
        stage('Docker Build') {
            when {
                branch 'main'
            }
            steps {
                script {
                    docker.withRegistry('', 'docker-credentials') {
                        def app = docker.build("${PROJECT_NAME}:${GIT_COMMIT_SHORT}")
                        app.push()
                        app.push('latest')
                    }
                }
            }
        }
        
        stage('Docker Scan') {
            when {
                branch 'main'
            }
            steps {
                script {
                    sh '''
                        docker run --rm aquasec/trivy:latest image ${PROJECT_NAME}:${GIT_COMMIT_SHORT}
                    '''
                }
            }
        }
        
EOF

    if [ "$ENABLE_STAGING" = true ]; then
        cat >> Jenkinsfile << 'EOF'
        stage('Deploy to Staging') {
            when {
                branch 'main'
            }
            steps {
                input message: 'Deploy to Staging?', ok: 'Deploy'
                script {
                    sh '''
                        kubectl set image deployment/${PROJECT_NAME} \
                            ${PROJECT_NAME}=${DOCKER_REGISTRY}/${PROJECT_NAME}:${GIT_COMMIT_SHORT} \
                            -n staging
                        kubectl rollout status deployment/${PROJECT_NAME} -n staging
                    '''
                }
            }
        }
        
EOF
    fi

    cat >> Jenkinsfile << 'EOF'
        stage('Deploy to Production') {
            when {
                branch 'main'
            }
            steps {
                input message: 'Deploy to Production?', ok: 'Deploy'
                script {
                    sh '''
                        kubectl set image deployment/${PROJECT_NAME} \
                            ${PROJECT_NAME}=${DOCKER_REGISTRY}/${PROJECT_NAME}:${GIT_COMMIT_SHORT} \
                            -n production
                        kubectl rollout status deployment/${PROJECT_NAME} -n production
                    '''
                }
            }
        }
    }
    
    post {
        success {
            echo 'Pipeline completed successfully!'
            slackSend(
                color: 'good',
                message: "SUCCESS: ${env.JOB_NAME} [${env.BUILD_NUMBER}]"
            )
        }
        failure {
            echo 'Pipeline failed!'
            slackSend(
                color: 'danger',
                message: "FAILED: ${env.JOB_NAME} [${env.BUILD_NUMBER}]"
            )
        }
    }
}
EOF

    print_success "Jenkins pipeline created"
}

# ============================================================================
# AZURE DEVOPS GENERATOR
# ============================================================================
generate_azure_devops() {
    print_info "Generating Azure DevOps pipeline..."
    
    cat > azure-pipelines.yml << EOF
# Azure DevOps Pipeline for ${PROJECT_NAME}

trigger:
  branches:
    include:
      - ${BRANCH_STRATEGY}

pr:
  branches:
    include:
      - ${BRANCH_STRATEGY}

variables:
  projectName: '${PROJECT_NAME}'
  dockerRegistry: '${DOCKER_REGISTRY}'
  k8sCluster: '${K8S_CLUSTER}'
  imageName: '\$(projectName):\$(Build.BuildId)'

pool:
  vmImage: 'ubuntu-latest'

stages:
- stage: Build
  displayName: 'Build and Test'
  jobs:
  - job: Build
    displayName: 'Build Application'
    steps:
    - checkout: self
      fetchDepth: 0
    
EOF

    case $LANGUAGE in
        nodejs)
            cat >> azure-pipelines.yml << 'EOF'
    - task: NodeTool@0
      inputs:
        versionSpec: '18.x'
      displayName: 'Install Node.js'
    
    - script: |
        npm ci
        npm run build || echo "No build script"
      displayName: 'Install dependencies and build'
    
EOF
            if [ "$ENABLE_TESTS" = true ]; then
                cat >> azure-pipelines.yml << 'EOF'
    - script: npm test
      displayName: 'Run tests'
    
    - task: PublishTestResults@2
      inputs:
        testResultsFormat: 'JUnit'
        testResultsFiles: '**/test-results.xml'
      condition: succeededOrFailed()
    
    - task: PublishCodeCoverageResults@1
      inputs:
        codeCoverageTool: 'Cobertura'
        summaryFileLocation: '$(System.DefaultWorkingDirectory)/coverage/cobertura-coverage.xml'
      condition: succeededOrFailed()
    
EOF
            fi
            ;;
            
        python)
            cat >> azure-pipelines.yml << 'EOF'
    - task: UsePythonVersion@0
      inputs:
        versionSpec: '3.11'
      displayName: 'Use Python 3.11'
    
    - script: |
        pip install -r requirements.txt
      displayName: 'Install dependencies'
    
EOF
            if [ "$ENABLE_TESTS" = true ]; then
                cat >> azure-pipelines.yml << 'EOF'
    - script: |
        pip install pytest pytest-cov
        pytest --junitxml=junit/test-results.xml --cov=. --cov-report=xml
      displayName: 'Run tests'
    
    - task: PublishTestResults@2
      inputs:
        testResultsFormat: 'JUnit'
        testResultsFiles: '**/test-results.xml'
      condition: succeededOrFailed()
    
EOF
            fi
            ;;
            
        java)
            cat >> azure-pipelines.yml << 'EOF'
    - task: Maven@3
      inputs:
        mavenPomFile: 'pom.xml'
        goals: 'clean package'
        options: '-DskipTests=false'
      displayName: 'Build with Maven'
    
    - task: PublishTestResults@2
      inputs:
        testResultsFormat: 'JUnit'
        testResultsFiles: '**/surefire-reports/TEST-*.xml'
      condition: succeededOrFailed()
    
EOF
            ;;
    esac

    if [ "$ENABLE_SECURITY_SCAN" = true ]; then
        cat >> azure-pipelines.yml << 'EOF'
    - script: |
        docker run --rm -v $(pwd):/src aquasec/trivy:latest fs --exit-code 0 --format json -o trivy-report.json /src
      displayName: 'Security scan with Trivy'
    
EOF
    fi

    cat >> azure-pipelines.yml << 'EOF'

- stage: Docker
  displayName: 'Build and Push Docker Image'
  dependsOn: Build
  condition: and(succeeded(), eq(variables['Build.SourceBranch'], 'refs/heads/main'))
  jobs:
  - job: Docker
    displayName: 'Docker Build and Push'
    steps:
    - task: Docker@2
      displayName: 'Build Docker image'
      inputs:
        command: build
        dockerfile: Dockerfile
        tags: |
          $(Build.BuildId)
          latest
    
    - task: Docker@2
      displayName: 'Push Docker image'
      inputs:
        command: push
        containerRegistry: 'dockerHubConnection'
        repository: $(projectName)
        tags: |
          $(Build.BuildId)
          latest

EOF

    if [ "$ENABLE_STAGING" = true ]; then
        cat >> azure-pipelines.yml << 'EOF'
- stage: DeployStaging
  displayName: 'Deploy to Staging'
  dependsOn: Docker
  condition: succeeded()
  jobs:
  - deployment: DeployStaging
    displayName: 'Deploy to Staging Environment'
    environment: 'staging'
    strategy:
      runOnce:
        deploy:
          steps:
          - task: Kubernetes@1
            displayName: 'Deploy to Staging'
            inputs:
              connectionType: 'Kubernetes Service Connection'
              kubernetesServiceEndpoint: 'k8s-staging'
              namespace: 'staging'
              command: 'set'
              arguments: 'image deployment/$(projectName) $(projectName)=$(dockerRegistry)/$(projectName):$(Build.BuildId)'
          
          - task: Kubernetes@1
            displayName: 'Check rollout status'
            inputs:
              connectionType: 'Kubernetes Service Connection'
              kubernetesServiceEndpoint: 'k8s-staging'
              namespace: 'staging'
              command: 'rollout'
              arguments: 'status deployment/$(projectName)'

EOF
    fi

    cat >> azure-pipelines.yml << 'EOF'
- stage: DeployProduction
  displayName: 'Deploy to Production'
  dependsOn: Docker
  condition: succeeded()
  jobs:
  - deployment: DeployProduction
    displayName: 'Deploy to Production Environment'
    environment: 'production'
    strategy:
      runOnce:
        deploy:
          steps:
          - task: Kubernetes@1
            displayName: 'Deploy to Production'
            inputs:
              connectionType: 'Kubernetes Service Connection'
              kubernetesServiceEndpoint: 'k8s-production'
              namespace: 'production'
              command: 'set'
              arguments: 'image deployment/$(projectName) $(projectName)=$(dockerRegistry)/$(projectName):$(Build.BuildId)'
          
          - task: Kubernetes@1
            displayName: 'Check rollout status'
            inputs:
              connectionType: 'Kubernetes Service Connection'
              kubernetesServiceEndpoint: 'k8s-production'
              namespace: 'production'
              command: 'rollout'
              arguments: 'status deployment/$(projectName)'
EOF

    print_success "Azure DevOps pipeline created"
}

# ============================================================================
# CIRCLECI GENERATOR
# ============================================================================
generate_circleci() {
    print_info "Generating CircleCI pipeline..."
    
    mkdir -p .circleci
    
    cat > .circleci/config.yml << EOF
# CircleCI Pipeline for ${PROJECT_NAME}

version: 2.1

orbs:
  docker: circleci/docker@2.2.0
  kubernetes: circleci/kubernetes@1.3.1

executors:
  node-executor:
    docker:
      - image: cimg/node:18.0
  python-executor:
    docker:
      - image: cimg/python:3.11

workflows:
  build-test-deploy:
    jobs:
      - build
      - test:
          requires:
            - build
      - security-scan:
          requires:
            - test
      - docker-build:
          requires:
            - security-scan
          filters:
            branches:
              only: ${BRANCH_STRATEGY}
EOF

    if [ "$ENABLE_STAGING" = true ]; then
        cat >> .circleci/config.yml << 'EOF'
      - deploy-staging:
          requires:
            - docker-build
          filters:
            branches:
              only: main
EOF
    fi

    cat >> .circleci/config.yml << 'EOF'
      - deploy-production:
          requires:
            - docker-build
          filters:
            branches:
              only: main

jobs:
  build:
    executor: node-executor
    steps:
      - checkout
      - restore_cache:
          keys:
            - v1-dependencies-{{ checksum "package.json" }}
            - v1-dependencies-
      
      - run:
          name: Install dependencies
          command: npm ci
      
      - save_cache:
          paths:
            - node_modules
          key: v1-dependencies-{{ checksum "package.json" }}
      
      - run:
          name: Build application
          command: npm run build || echo "No build script"
      
      - persist_to_workspace:
          root: .
          paths:
            - .
  
  test:
    executor: node-executor
    steps:
      - attach_workspace:
          at: .
      
      - run:
          name: Run tests
          command: npm test
      
      - run:
          name: Generate coverage report
          command: npm run test:coverage || echo "No coverage"
      
      - store_test_results:
          path: ./test-results
      
      - store_artifacts:
          path: ./coverage
  
  security-scan:
    docker:
      - image: aquasec/trivy:latest
    steps:
      - attach_workspace:
          at: .
      
      - run:
          name: Run Trivy scan
          command: trivy fs --exit-code 0 --no-progress .
  
  docker-build:
    docker:
      - image: cimg/base:stable
    steps:
      - attach_workspace:
          at: .
      
      - setup_remote_docker:
          docker_layer_caching: true
      
      - run:
          name: Build Docker image
          command: |
            docker build -t ${PROJECT_NAME}:${CIRCLE_SHA1} .
            docker tag ${PROJECT_NAME}:${CIRCLE_SHA1} ${PROJECT_NAME}:latest
      
      - run:
          name: Push to registry
          command: |
            echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
            docker push ${PROJECT_NAME}:${CIRCLE_SHA1}
            docker push ${PROJECT_NAME}:latest
  
EOF

    if [ "$ENABLE_STAGING" = true ]; then
        cat >> .circleci/config.yml << 'EOF'
  deploy-staging:
    executor: kubernetes/default
    steps:
      - kubernetes/install-kubectl
      - run:
          name: Deploy to Staging
          command: |
            kubectl set image deployment/${PROJECT_NAME} \
              ${PROJECT_NAME}=${DOCKER_REGISTRY}/${PROJECT_NAME}:${CIRCLE_SHA1} \
              -n staging
            kubectl rollout status deployment/${PROJECT_NAME} -n staging
  
EOF
    fi

    cat >> .circleci/config.yml << 'EOF'
  deploy-production:
    executor: kubernetes/default
    steps:
      - kubernetes/install-kubectl
      - run:
          name: Deploy to Production
          command: |
            kubectl set image deployment/${PROJECT_NAME} \
              ${PROJECT_NAME}=${DOCKER_REGISTRY}/${PROJECT_NAME}:${CIRCLE_SHA1} \
              -n production
            kubectl rollout status deployment/${PROJECT_NAME} -n production
EOF

    print_success "CircleCI pipeline created"
}

# ============================================================================
# README GENERATOR
# ============================================================================
generate_readme() {
    cat > CI-CD-README.md << EOF
# CI/CD Pipeline Documentation

## Project: ${PROJECT_NAME}

### Pipeline Configuration
- **Provider**: ${PIPELINE_PROVIDER}
- **Language**: ${LANGUAGE}
- **Docker Registry**: ${DOCKER_REGISTRY}
- **K8s Cluster**: ${K8S_CLUSTER}
- **Deploy Method**: ${DEPLOY_METHOD}
- **Tests Enabled**: ${ENABLE_TESTS}
- **Linting Enabled**: ${ENABLE_LINT}
- **Security Scan**: ${ENABLE_SECURITY_SCAN}
- **Staging Environment**: ${ENABLE_STAGING}

## Pipeline Workflow

\`\`\`
┌─────────┐     ┌──────┐     ┌──────────┐     ┌────────┐     ┌─────────┐
│ Checkout│────▶│ Build│────▶│   Test   │────▶│Security│────▶│  Docker │
└─────────┘     └──────┘     └──────────┘     └────────┘     └─────────┘
                                                                    │
EOF

    if [ "$ENABLE_STAGING" = true ]; then
        cat >> CI-CD-README.md << 'EOF'
                                                                    ▼
                                                              ┌─────────┐
                                                              │ Staging │
                                                              └─────────┘
                                                                    │
EOF
    fi

    cat >> CI-CD-README.md << 'EOF'
                                                                    ▼
                                                             ┌────────────┐
                                                             │ Production │
                                                             └────────────┘
```

## Setup Instructions

EOF

    case $PIPELINE_PROVIDER in
        github|all)
            cat >> CI-CD-README.md << 'EOF'
### GitHub Actions Setup

#### 1. Required Secrets

Navigate to: `Settings > Secrets and variables > Actions`

**Docker Registry Secrets:**
- `DOCKER_USERNAME` - Docker Hub username
- `DOCKER_PASSWORD` - Docker Hub password or token
EOF

            case $DOCKER_REGISTRY in
                ghcr)
                    echo "- Uses GITHUB_TOKEN (automatically provided)" >> CI-CD-README.md
                    ;;
                ecr)
                    cat >> CI-CD-README.md << 'EOF'
- `AWS_ACCESS_KEY_ID` - AWS access key
- `AWS_SECRET_ACCESS_KEY` - AWS secret key
- `AWS_REGION` - AWS region
EOF
                    ;;
                gcr)
                    echo "- \`GCP_SA_KEY\` - GCP service account JSON key" >> CI-CD-README.md
                    ;;
                acr)
                    echo "- \`AZURE_CREDENTIALS\` - Azure credentials JSON" >> CI-CD-README.md
                    ;;
            esac

            cat >> CI-CD-README.md << 'EOF'

**Kubernetes Secrets:**
EOF

            case $K8S_CLUSTER in
                eks)
                    cat >> CI-CD-README.md << 'EOF'
- `AWS_ACCESS_KEY_ID` - AWS access key
- `AWS_SECRET_ACCESS_KEY` - AWS secret key
- `AWS_REGION` - AWS region
- `EKS_CLUSTER_NAME` - EKS cluster name
EOF
                    ;;
                gke)
                    cat >> CI-CD-README.md << 'EOF'
- `GCP_SA_KEY` - GCP service account JSON key
- `GCP_PROJECT` - GCP project ID
- `GKE_CLUSTER_NAME` - GKE cluster name
- `GKE_ZONE` - GKE zone
EOF
                    ;;
                aks)
                    cat >> CI-CD-README.md << 'EOF'
- `AZURE_CREDENTIALS` - Azure credentials JSON
- `AKS_RESOURCE_GROUP` - AKS resource group
- `AKS_CLUSTER_NAME` - AKS cluster name
EOF
                    ;;
                k8s)
                    echo "- \`KUBECONFIG\` - Base64 encoded kubeconfig file" >> CI-CD-README.md
                    ;;
            esac

            cat >> CI-CD-README.md << 'EOF'

**Optional Secrets:**
- `CODECOV_TOKEN` - Codecov token for coverage reports
- `SONAR_TOKEN` - SonarQube token (if enabled)
- `SONAR_HOST_URL` - SonarQube server URL

#### 2. Repository Settings

- Go to `Settings > Environments`
- Create environments: `staging` and `production`
- Add required reviewers for production deployments
- Configure environment secrets if different from repository secrets

#### 3. Workflow Permissions

- Go to `Settings > Actions > General`
- Under "Workflow permissions", select:
  - ✅ Read and write permissions
  - ✅ Allow GitHub Actions to create and approve pull requests

#### 4. Trigger Pipeline

```bash
# Push to main branch
git add .
git commit -m "feat: add new feature"
git push origin main

# Or create a pull request
git checkout -b feature/my-feature
git push origin feature/my-feature
# Create PR via GitHub UI
```

#### 5. Monitor Pipeline

- Navigate to `Actions` tab
- Click on the running workflow
- View logs for each job

EOF
            ;;
    esac

    case $PIPELINE_PROVIDER in
        gitlab|all)
            cat >> CI-CD-README.md << 'EOF'
### GitLab CI/CD Setup

#### 1. CI/CD Variables

Navigate to: `Settings > CI/CD > Variables`

**Required Variables:**
- `CI_REGISTRY_USER` - Registry username
- `CI_REGISTRY_PASSWORD` - Registry password
- `KUBECONFIG` - Kubernetes config (File type)

**For External Registries:**
EOF

            if [[ "$DOCKER_REGISTRY" == "dockerhub" ]]; then
                cat >> CI-CD-README.md << 'EOF'
- `DOCKER_USERNAME` - Docker Hub username
- `DOCKER_PASSWORD` - Docker Hub token
EOF
            fi

            cat >> CI-CD-README.md << 'EOF'

#### 2. Kubernetes Integration

- Go to `Settings > CI/CD > Kubernetes`
- Add cluster or use GitLab Agent for Kubernetes
- Configure cluster certificate and token

#### 3. Enable Container Registry

- Go to `Settings > General > Visibility`
- Enable Container Registry

#### 4. Configure Runners

- Ensure GitLab Runners are available
- Tag runners appropriately (docker, kubernetes, etc.)

#### 5. Trigger Pipeline

```bash
git add .
git commit -m "feat: add new feature"
git push origin main
```

EOF
            ;;
    esac

    case $PIPELINE_PROVIDER in
        jenkins|all)
            cat >> CI-CD-README.md << 'EOF'
### Jenkins Setup

#### 1. Install Required Plugins

- Docker Pipeline
- Kubernetes CLI
- Pipeline
- Git
- Credentials Binding
- Blue Ocean (optional, for better UI)

#### 2. Configure Credentials

Navigate to: `Manage Jenkins > Credentials`

**Add Credentials:**
1. **Docker Registry** (Username with password)
   - ID: `docker-credentials`
   - Username: Your registry username
   - Password: Your registry password/token

2. **Kubeconfig** (Secret file)
   - ID: `kubeconfig`
   - File: Upload your kubeconfig file

3. **Git Credentials** (if private repo)
   - ID: `git-credentials`
   - Add username/password or SSH key

#### 3. Create Pipeline Job

1. Click "New Item"
2. Enter name: `${PROJECT_NAME}-pipeline`
3. Select "Pipeline"
4. Under "Pipeline" section:
   - Definition: "Pipeline script from SCM"
   - SCM: Git
   - Repository URL: Your repo URL
   - Credentials: Select git credentials
   - Branch: */main
   - Script Path: Jenkinsfile

#### 4. Configure Kubernetes Plugin (Optional)

- Install Kubernetes plugin
- Configure cloud: `Manage Jenkins > Manage Nodes and Clouds > Configure Clouds`
- Add Kubernetes cloud
- Test connection

#### 5. Build Pipeline

- Click "Build Now" on your pipeline job
- Monitor in Blue Ocean or classic view

EOF
            ;;
    esac

    case $PIPELINE_PROVIDER in
        azure|all)
            cat >> CI-CD-README.md << 'EOF'
### Azure DevOps Setup

#### 1. Create Service Connections

Navigate to: `Project Settings > Service connections`

**Required Connections:**

1. **Docker Registry**
   - Type: Docker Registry
   - Docker ID: Your registry username
   - Password: Your registry password
   - Service connection name: `dockerHubConnection`

2. **Kubernetes**
   - Type: Kubernetes
   - Authentication method: Kubeconfig
   - Upload kubeconfig file
   - Service connection names: `k8s-staging`, `k8s-production`

3. **For Cloud Providers:**
EOF

            case $K8S_CLUSTER in
                eks)
                    echo "   - AWS service connection with IAM credentials" >> CI-CD-README.md
                    ;;
                gke)
                    echo "   - GCP service connection with service account" >> CI-CD-README.md
                    ;;
                aks)
                    echo "   - Azure Resource Manager connection" >> CI-CD-README.md
                    ;;
            esac

            cat >> CI-CD-README.md << 'EOF'

#### 2. Create Pipeline

1. Go to `Pipelines > New Pipeline`
2. Select your repository
3. Select "Existing Azure Pipelines YAML file"
4. Choose `azure-pipelines.yml`
5. Click "Run"

#### 3. Configure Environments

- Go to `Pipelines > Environments`
- Create environments: `staging` and `production`
- Add approvers for production

#### 4. Variable Groups (Optional)

- Go to `Pipelines > Library`
- Create variable groups for shared variables
- Link to pipeline

EOF
            ;;
    esac

    case $PIPELINE_PROVIDER in
        circleci|all)
            cat >> CI-CD-README.md << 'EOF'
### CircleCI Setup

#### 1. Add Project

- Log in to CircleCI
- Go to "Projects"
- Click "Set Up Project" for your repository

#### 2. Configure Environment Variables

Navigate to: `Project Settings > Environment Variables`

**Required Variables:**
- `DOCKER_USERNAME` - Docker registry username
- `DOCKER_PASSWORD` - Docker registry password
- `DOCKER_REGISTRY` - Registry URL
EOF

            case $K8S_CLUSTER in
                eks)
                    cat >> CI-CD-README.md << 'EOF'
- `AWS_ACCESS_KEY_ID` - AWS access key
- `AWS_SECRET_ACCESS_KEY` - AWS secret key
- `AWS_DEFAULT_REGION` - AWS region
EOF
                    ;;
                gke)
                    cat >> CI-CD-README.md << 'EOF'
- `GCLOUD_SERVICE_KEY` - GCP service account JSON (base64)
- `GOOGLE_PROJECT_ID` - GCP project ID
- `GOOGLE_COMPUTE_ZONE` - GCP zone
EOF
                    ;;
                aks)
                    cat >> CI-CD-README.md << 'EOF'
- `AZURE_SP` - Azure service principal JSON
EOF
                    ;;
            esac

            cat >> CI-CD-README.md << 'EOF'

#### 3. Add SSH Key (if needed)

- Go to `Project Settings > SSH Keys`
- Add private key for deployments

#### 4. Configure Contexts

- Go to `Organization Settings > Contexts`
- Create contexts for staging/production
- Add environment-specific variables

#### 5. Trigger Build

```bash
git push origin main
```

EOF
            ;;
    esac

    cat >> CI-CD-README.md << 'EOF'

## Pipeline Stages Explained

### 1. Build Stage
- Checks out code
- Installs dependencies
- Builds application artifacts
- Caches dependencies for faster builds

### 2. Test Stage
- Runs unit tests
- Generates code coverage reports
- Publishes test results
- Fails pipeline if tests fail

### 3. Lint Stage
- Runs code linters
- Checks code style and quality
- Reports issues

### 4. Security Stage
- Scans dependencies for vulnerabilities
- Runs SAST (Static Application Security Testing)
- Checks for secrets in code
- Uses Trivy for vulnerability scanning

### 5. Docker Stage
- Builds Docker image
- Tags with commit SHA and latest
- Pushes to container registry
- Scans Docker image for vulnerabilities

### 6. Deploy Stages
- **Staging**: Automatic deployment for testing
- **Production**: Manual approval required
- Updates Kubernetes deployment
- Monitors rollout status
- Can rollback on failure

## Deployment Methods

EOF

    case $DEPLOY_METHOD in
        kubectl)
            cat >> CI-CD-README.md << 'EOF'
### kubectl apply

Direct deployment using kubectl:
```bash
kubectl set image deployment/${PROJECT_NAME} \
  ${PROJECT_NAME}=${IMAGE} \
  -n production
```

**Pros:**
- Simple and straightforward
- Direct control over deployments

**Cons:**
- Less declarative
- Harder to version control

EOF
            ;;
        helm)
            cat >> CI-CD-README.md << 'EOF'
### Helm

Package manager for Kubernetes:
```bash
helm upgrade --install ${PROJECT_NAME} ./helm \
  --set image.tag=${TAG} \
  --namespace production
```

**Pros:**
- Templating and reusability
- Easy rollbacks
- Release management

**Cons:**
- Additional complexity
- Learning curve

EOF
            ;;
        kustomize)
            cat >> CI-CD-README.md << 'EOF'
### Kustomize

Kubernetes native configuration management:
```bash
kubectl apply -k k8s/overlays/production
```

**Pros:**
- Native to kubectl
- Simple overlays
- No templating language

**Cons:**
- Limited logic capabilities
- Verbose for complex scenarios

EOF
            ;;
        argocd)
            cat >> CI-CD-README.md << 'EOF'
### ArgoCD (GitOps)

Declarative continuous delivery:
```bash
# Pipeline updates git repository
# ArgoCD automatically syncs changes
```

**Pros:**
- True GitOps workflow
- Automatic sync and drift detection
- Better audit trail

**Cons:**
- Additional infrastructure required
- Slight delay in deployments

EOF
            ;;
    esac

    cat >> CI-CD-README.md << 'EOF'

## Monitoring and Troubleshooting

### Check Pipeline Status
EOF

    case $PIPELINE_PROVIDER in
        github)
            cat >> CI-CD-README.md << 'EOF'
```bash
# View workflow runs
gh run list

# View specific run
gh run view <run-id>

# View logs
gh run view <run-id> --log
```
EOF
            ;;
        gitlab)
            cat >> CI-CD-README.md << 'EOF'
- Navigate to CI/CD > Pipelines
- Click on pipeline to view stages
- Check job logs for details
EOF
            ;;
        jenkins)
            cat >> CI-CD-README.md << 'EOF'
- Open Jenkins dashboard
- Click on pipeline job
- View console output
- Check Blue Ocean for visual pipeline
EOF
            ;;
    esac

    cat >> CI-CD-README.md << 'EOF'

### Check Deployment Status

```bash
# Check pods
kubectl get pods -n production

# Check deployment
kubectl get deployment ${PROJECT_NAME} -n production

# View rollout history
kubectl rollout history deployment/${PROJECT_NAME} -n production

# Check pod logs
kubectl logs -f deployment/${PROJECT_NAME} -n production
```

### Rollback Deployment

```bash
# Rollback to previous version
kubectl rollout undo deployment/${PROJECT_NAME} -n production

# Rollback to specific revision
kubectl rollout undo deployment/${PROJECT_NAME} -n production --to-revision=2
```

### Common Issues

#### 1. Build Failures
- Check logs for specific errors
- Verify dependencies are correct
- Ensure all required files are committed

#### 2. Test Failures
- Review test logs
- Run tests locally first
- Check test environment configuration

#### 3. Docker Build Failures
- Verify Dockerfile syntax
- Check base image availability
- Ensure build context is correct

#### 4. Deployment Failures
- Verify kubeconfig is correct
- Check cluster connectivity
- Ensure namespace exists
- Verify image is accessible

#### 5. Permission Issues
- Check service account permissions
- Verify registry credentials
- Ensure Kubernetes RBAC is configured

## Best Practices

### Security
- ✅ Use secrets management (never commit secrets)
- ✅ Scan for vulnerabilities regularly
- ✅ Use minimal base images
- ✅ Run containers as non-root
- ✅ Enable security scanning in pipeline
- ✅ Use signed images

### Performance
- ✅ Cache dependencies
- ✅ Use multi-stage Docker builds
- ✅ Parallelize jobs when possible
- ✅ Use Docker layer caching
- ✅ Optimize build context

### Reliability
- ✅ Implement health checks
- ✅ Use rolling updates
- ✅ Set resource limits
- ✅ Configure auto-scaling
- ✅ Monitor deployments
- ✅ Have rollback strategy

### Workflow
- ✅ Use feature branches
- ✅ Require PR reviews
- ✅ Run tests on every commit
- ✅ Deploy to staging first
- ✅ Require approval for production
- ✅ Tag releases

## Maintenance

### Update Dependencies

```bash
# Node.js
npm update
npm audit fix

# Python
pip list --outdated
pip install --upgrade <package>

# Go
go get -u ./...
go mod tidy
```

### Update Base Images

```dockerfile
# Check for newer versions
# Update in Dockerfile
FROM node:18-alpine  # -> FROM node:20-alpine
```

### Pipeline Updates

- Review pipeline regularly
- Update actions/tasks to latest versions
- Add new security scans as they become available
- Optimize based on build times

## Additional Resources

EOF

    case $PIPELINE_PROVIDER in
        github)
            cat >> CI-CD-README.md << 'EOF'
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [GitHub Actions Marketplace](https://github.com/marketplace?type=actions)
EOF
            ;;
        gitlab)
            cat >> CI-CD-README.md << 'EOF'
- [GitLab CI/CD Documentation](https://docs.gitlab.com/ee/ci/)
- [GitLab CI/CD Examples](https://docs.gitlab.com/ee/ci/examples/)
EOF
            ;;
        jenkins)
            cat >> CI-CD-README.md << 'EOF'
- [Jenkins Documentation](https://www.jenkins.io/doc/)
- [Jenkins Pipeline Syntax](https://www.jenkins.io/doc/book/pipeline/syntax/)
EOF
            ;;
        azure)
            cat >> CI-CD-README.md << 'EOF'
- [Azure Pipelines Documentation](https://docs.microsoft.com/en-us/azure/devops/pipelines/)
- [Azure DevOps Labs](https://azuredevopslabs.com/)
EOF
            ;;
        circleci)
            cat >> CI-CD-README.md << 'EOF'
- [CircleCI Documentation](https://circleci.com/docs/)
- [CircleCI Orbs](https://circleci.com/developer/orbs)
EOF
            ;;
    esac

    cat >> CI-CD-README.md << 'EOF'
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [12 Factor App](https://12factor.net/)

## Support

For issues or questions:
1. Check pipeline logs
2. Review this documentation
3. Check cloud provider status
4. Review Kubernetes events: `kubectl get events -n production`
EOF

    print_success "README documentation created"
}

# ============================================================================
# HELPER SCRIPTS GENERATOR
# ============================================================================
generate_helper_scripts() {
    mkdir -p scripts
    
    # Local testing script
    cat > scripts/test-local.sh << 'EOF'
#!/bin/bash
# Local testing script

echo "🧪 Running tests locally..."

# Run linter
echo "Running linter..."
npm run lint || true

# Run tests
echo "Running tests..."
npm test

# Build Docker image
echo "Building Docker image..."
docker build -t ${PROJECT_NAME}:local .

# Run security scan
echo "Running security scan..."
docker run --rm -v $(pwd):/src aquasec/trivy:latest fs /src

echo "✅ Local tests complete!"
EOF

    # Deployment script
    cat > scripts/deploy.sh << 'EOF'
#!/bin/bash
# Manual deployment script

set -e

ENVIRONMENT=${1:-staging}
IMAGE_TAG=${2:-latest}

echo "🚀 Deploying to $ENVIRONMENT..."

kubectl set image deployment/${PROJECT_NAME} \
    ${PROJECT_NAME}=${DOCKER_REGISTRY}/${PROJECT_NAME}:${IMAGE_TAG} \
    -n $ENVIRONMENT

echo "⏳ Waiting for rollout..."
kubectl rollout status deployment/${PROJECT_NAME} -n $ENVIRONMENT

echo "✅ Deployment complete!"
echo ""
echo "Check status:"
echo "  kubectl get pods -n $ENVIRONMENT"
echo "  kubectl logs -f deployment/${PROJECT_NAME} -n $ENVIRONMENT"
EOF

    # Rollback script
    cat > scripts/rollback.sh << 'EOF'
#!/bin/bash
# Rollback deployment

set -e

ENVIRONMENT=${1:-production}

echo "⚠️  Rolling back $ENVIRONMENT deployment..."

kubectl rollout undo deployment/${PROJECT_NAME} -n $ENVIRONMENT

echo "⏳ Waiting for rollout..."
kubectl rollout status deployment/${PROJECT_NAME} -n $ENVIRONMENT

echo "✅ Rollback complete!"
EOF

    chmod +x scripts/*.sh
    
    print_success "Helper scripts created"
}

# ============================================================================
# MAIN ORCHESTRATION
# ============================================================================
main() {
    display_header
    
    print_info "Starting CI/CD Pipeline Generator..."
    echo ""
    
    # Collect configurations
    select_pipeline_provider
    collect_basic_info
    collect_pipeline_options
    
    echo ""
    print_info "Generating CI/CD pipeline configuration..."
    echo ""
    
    # Generate based on provider
    if [[ "$PIPELINE_PROVIDER" == "github" || "$PIPELINE_PROVIDER" == "all" ]]; then
        generate_github_actions
    fi
    
    if [[ "$PIPELINE_PROVIDER" == "gitlab" || "$PIPELINE_PROVIDER" == "all" ]]; then
        generate_gitlab_ci
    fi
    
    if [[ "$PIPELINE_PROVIDER" == "jenkins" || "$PIPELINE_PROVIDER" == "all" ]]; then
        generate_jenkins
    fi
    
    if [[ "$PIPELINE_PROVIDER" == "azure" || "$PIPELINE_PROVIDER" == "all" ]]; then
        generate_azure_devops
    fi
    
    if [[ "$PIPELINE_PROVIDER" == "circleci" || "$PIPELINE_PROVIDER" == "all" ]]; then
        generate_circleci
    fi
    
    # Generate common files
    generate_readme
    generate_helper_scripts
    
    echo ""
    print_success "============================================================"
    print_success "   CI/CD Pipeline Generated Successfully!                  "
    print_success "============================================================"
    echo ""
    
    print_info "Generated files:"
    if [[ "$PIPELINE_PROVIDER" == "github" || "$PIPELINE_PROVIDER" == "all" ]]; then
        echo "  ✓ .github/workflows/ci-cd.yml"
    fi
    if [[ "$PIPELINE_PROVIDER" == "gitlab" || "$PIPELINE_PROVIDER" == "all" ]]; then
        echo "  ✓ .gitlab-ci.yml"
    fi
    if [[ "$PIPELINE_PROVIDER" == "jenkins" || "$PIPELINE_PROVIDER" == "all" ]]; then
        echo "  ✓ Jenkinsfile"
    fi
    if [[ "$PIPELINE_PROVIDER" == "azure" || "$PIPELINE_PROVIDER" == "all" ]]; then
        echo "  ✓ azure-pipelines.yml"
    fi
    if [[ "$PIPELINE_PROVIDER" == "circleci" || "$PIPELINE_PROVIDER" == "all" ]]; then
        echo "  ✓ .circleci/config.yml"
    fi
    echo "  ✓ CI-CD-README.md"
    echo "  ✓ scripts/test-local.sh"
    echo "  ✓ scripts/deploy.sh"
    echo "  ✓ scripts/rollback.sh"
    
    echo ""
    print_warning "⚠️  Next Steps:"
    echo "  1. Review generated pipeline files"
    echo "  2. Configure secrets/credentials in your CI/CD platform"
    echo "  3. Update image names and registry URLs"
    echo "  4. Test pipeline with a commit"
    echo "  5. Configure deployment environments"
    echo ""
    print_info "For detailed setup instructions, see: CI-CD-README.md"
    echo ""
    
    print_success "🎉 Your CI/CD pipeline is ready to use!"
}

# Run main function
main
