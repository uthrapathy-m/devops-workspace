#!/bin/bash

# Helm Chart Generator for Production Deployments
# Generates complete Helm charts with multi-environment support
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
CHART_NAME=""
APP_TYPE=""
CHART_VERSION="0.1.0"
APP_VERSION="1.0.0"
REPLICAS=3
ENABLE_INGRESS=false
ENABLE_HPA=false
ENABLE_PDB=false
ENABLE_SERVICE_MONITOR=false
ENABLE_DATABASE=false
ENABLE_REDIS=false
ENABLE_CONFIGMAP=true
ENABLE_SECRET=true
IMAGE_REGISTRY="docker.io"
IMAGE_REPOSITORY=""
IMAGE_TAG="latest"
SERVICE_TYPE="ClusterIP"
CONTAINER_PORT=8080

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
    echo "   Helm Chart Generator for Production                     "
    echo "   Advanced Kubernetes Package Management                  "
    echo "============================================================"
    echo ""
}

# Function to collect basic information
collect_basic_info() {
    print_header "=== Basic Chart Configuration ==="
    echo ""
    
    read -p "Chart name (e.g., my-app): " chart_name
    CHART_NAME=${chart_name:-my-app}
    
    read -p "Chart version (default: 0.1.0): " chart_version
    CHART_VERSION=${chart_version:-0.1.0}
    
    read -p "Application version (default: 1.0.0): " app_version
    APP_VERSION=${app_version:-1.0.0}
    
    echo ""
    echo "Select Application Type:"
    echo "1) Web Application (Frontend/Backend)"
    echo "2) Microservice API"
    echo "3) Worker/Job Processor"
    echo "4) Database (StatefulSet)"
    echo "5) CronJob"
    read -p "Enter choice (1-5, default: 1): " app_choice
    
    case ${app_choice:-1} in
        1) APP_TYPE="webapp" ;;
        2) APP_TYPE="api" ;;
        3) APP_TYPE="worker" ;;
        4) APP_TYPE="database" ;;
        5) APP_TYPE="cronjob" ;;
        *) APP_TYPE="webapp" ;;
    esac
    
    echo ""
    read -p "Container port (default: 8080): " port
    CONTAINER_PORT=${port:-8080}
    
    read -p "Default replicas (default: 3): " replicas
    REPLICAS=${replicas:-3}
    
    print_success "Basic configuration collected"
}

# Function to collect image information
collect_image_info() {
    echo ""
    print_header "=== Docker Image Configuration ==="
    
    read -p "Image registry (default: docker.io): " registry
    IMAGE_REGISTRY=${registry:-docker.io}
    
    read -p "Image repository (e.g., mycompany/myapp): " repository
    IMAGE_REPOSITORY=${repository:-mycompany/${CHART_NAME}}
    
    read -p "Image tag (default: latest): " tag
    IMAGE_TAG=${tag:-latest}
    
    print_success "Image configuration collected"
}

# Function to collect service configuration
collect_service_config() {
    echo ""
    print_header "=== Service Configuration ==="
    
    echo "Service type:"
    echo "1) ClusterIP (internal only)"
    echo "2) NodePort (external via node port)"
    echo "3) LoadBalancer (cloud load balancer)"
    read -p "Enter choice (1-3, default: 1): " service_choice
    
    case ${service_choice:-1} in
        1) SERVICE_TYPE="ClusterIP" ;;
        2) SERVICE_TYPE="NodePort" ;;
        3) SERVICE_TYPE="LoadBalancer" ;;
        *) SERVICE_TYPE="ClusterIP" ;;
    esac
    
    print_success "Service type: $SERVICE_TYPE"
}

# Function to collect optional features
collect_optional_features() {
    echo ""
    print_header "=== Optional Features ==="
    
    read -p "Enable Ingress? (y/n): " ingress
    ENABLE_INGRESS=$([[ $ingress == "y" || $ingress == "Y" ]] && echo true || echo false)
    
    read -p "Enable Horizontal Pod Autoscaler (HPA)? (y/n): " hpa
    ENABLE_HPA=$([[ $hpa == "y" || $hpa == "Y" ]] && echo true || echo false)
    
    read -p "Enable Pod Disruption Budget (PDB)? (y/n): " pdb
    ENABLE_PDB=$([[ $pdb == "y" || $pdb == "Y" ]] && echo true || echo false)
    
    read -p "Enable ServiceMonitor (Prometheus)? (y/n): " monitor
    ENABLE_SERVICE_MONITOR=$([[ $monitor == "y" || $monitor == "Y" ]] && echo true || echo false)
    
    read -p "Include PostgreSQL dependency? (y/n): " postgres
    ENABLE_DATABASE=$([[ $postgres == "y" || $postgres == "Y" ]] && echo true || echo false)
    
    read -p "Include Redis dependency? (y/n): " redis
    ENABLE_REDIS=$([[ $redis == "y" || $redis == "Y" ]] && echo true || echo false)
    
    print_success "Optional features configured"
}

# ============================================================================
# CHART.YAML GENERATOR
# ============================================================================
generate_chart_yaml() {
    cat > ${CHART_NAME}/Chart.yaml << EOF
apiVersion: v2
name: ${CHART_NAME}
description: A Helm chart for ${CHART_NAME} on Kubernetes
type: application
version: ${CHART_VERSION}
appVersion: "${APP_VERSION}"
keywords:
  - ${CHART_NAME}
  - kubernetes
  - helm
home: https://github.com/yourorg/${CHART_NAME}
sources:
  - https://github.com/yourorg/${CHART_NAME}
maintainers:
  - name: Your Team
    email: team@example.com
    url: https://example.com
EOF

    if [ "$ENABLE_DATABASE" = true ] || [ "$ENABLE_REDIS" = true ]; then
        cat >> ${CHART_NAME}/Chart.yaml << EOF

dependencies:
EOF
        
        if [ "$ENABLE_DATABASE" = true ]; then
            cat >> ${CHART_NAME}/Chart.yaml << 'EOF'
  - name: postgresql
    version: 12.x.x
    repository: https://charts.bitnami.com/bitnami
    condition: postgresql.enabled
EOF
        fi
        
        if [ "$ENABLE_REDIS" = true ]; then
            cat >> ${CHART_NAME}/Chart.yaml << 'EOF'
  - name: redis
    version: 17.x.x
    repository: https://charts.bitnami.com/bitnami
    condition: redis.enabled
EOF
        fi
    fi
    
    print_success "Chart.yaml created"
}

# ============================================================================
# VALUES.YAML GENERATOR
# ============================================================================
generate_values_yaml() {
    cat > ${CHART_NAME}/values.yaml << EOF
# Default values for ${CHART_NAME}
# This is a YAML-formatted file.
# Declare variables to be passed into your templates.

# -- Number of replicas for the deployment
replicaCount: ${REPLICAS}

# Image configuration
image:
  # -- Docker registry
  registry: ${IMAGE_REGISTRY}
  # -- Image repository
  repository: ${IMAGE_REPOSITORY}
  # -- Image pull policy
  pullPolicy: IfNotPresent
  # -- Image tag (defaults to Chart appVersion if not specified)
  tag: "${IMAGE_TAG}"

# -- Image pull secrets for private registries
imagePullSecrets: []
# - name: docker-registry-secret

# -- Override the chart name
nameOverride: ""
# -- Override the full release name
fullnameOverride: ""

# Service Account configuration
serviceAccount:
  # -- Specifies whether a service account should be created
  create: true
  # -- Annotations to add to the service account
  annotations: {}
  # -- The name of the service account to use
  name: ""

# Pod annotations
podAnnotations: {}
  # prometheus.io/scrape: "true"
  # prometheus.io/port: "${CONTAINER_PORT}"
  # prometheus.io/path: "/metrics"

# Pod security context
podSecurityContext:
  runAsNonRoot: true
  runAsUser: 1000
  fsGroup: 1000
  seccompProfile:
    type: RuntimeDefault

# Container security context
securityContext:
  allowPrivilegeEscalation: false
  capabilities:
    drop:
    - ALL
  readOnlyRootFilesystem: true
  runAsNonRoot: true
  runAsUser: 1000

# Service configuration
service:
  # -- Service type
  type: ${SERVICE_TYPE}
  # -- Service port
  port: 80
  # -- Target port on the container
  targetPort: ${CONTAINER_PORT}
  # -- NodePort (only used if service.type is NodePort)
  # nodePort: 30080
  # -- Service annotations
  annotations: {}
  # -- Session affinity
  sessionAffinity: ClientIP

EOF

    if [ "$ENABLE_INGRESS" = true ]; then
        cat >> ${CHART_NAME}/values.yaml << 'EOF'
# Ingress configuration
ingress:
  # -- Enable ingress
  enabled: true
  # -- Ingress class name
  className: "nginx"
  # -- Ingress annotations
  annotations:
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
    nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
    # nginx.ingress.kubernetes.io/rate-limit: "100"
  # -- Ingress hosts configuration
  hosts:
    - host: chart-example.local
      paths:
        - path: /
          pathType: Prefix
  # -- Ingress TLS configuration
  tls:
    - secretName: chart-example-tls
      hosts:
        - chart-example.local

EOF
    else
        cat >> ${CHART_NAME}/values.yaml << 'EOF'
# Ingress configuration
ingress:
  enabled: false
  className: "nginx"
  annotations: {}
  hosts: []
  tls: []

EOF
    fi

    cat >> ${CHART_NAME}/values.yaml << 'EOF'
# Resource limits and requests
resources:
  limits:
    cpu: 500m
    memory: 512Mi
  requests:
    cpu: 100m
    memory: 128Mi

EOF

    if [ "$ENABLE_HPA" = true ]; then
        cat >> ${CHART_NAME}/values.yaml << 'EOF'
# Horizontal Pod Autoscaler configuration
autoscaling:
  # -- Enable HPA
  enabled: true
  # -- Minimum number of replicas
  minReplicas: 2
  # -- Maximum number of replicas
  maxReplicas: 10
  # -- Target CPU utilization percentage
  targetCPUUtilizationPercentage: 80
  # -- Target memory utilization percentage
  targetMemoryUtilizationPercentage: 80
  # -- Behavior configuration for scaling
  behavior:
    scaleDown:
      stabilizationWindowSeconds: 300
      policies:
      - type: Percent
        value: 50
        periodSeconds: 60
      - type: Pods
        value: 2
        periodSeconds: 60
      selectPolicy: Min
    scaleUp:
      stabilizationWindowSeconds: 0
      policies:
      - type: Percent
        value: 100
        periodSeconds: 30
      - type: Pods
        value: 4
        periodSeconds: 30
      selectPolicy: Max

EOF
    else
        cat >> ${CHART_NAME}/values.yaml << 'EOF'
# Horizontal Pod Autoscaler configuration
autoscaling:
  enabled: false
  minReplicas: 2
  maxReplicas: 10
  targetCPUUtilizationPercentage: 80
  targetMemoryUtilizationPercentage: 80

EOF
    fi

    if [ "$ENABLE_PDB" = true ]; then
        cat >> ${CHART_NAME}/values.yaml << 'EOF'
# Pod Disruption Budget configuration
podDisruptionBudget:
  # -- Enable PDB
  enabled: true
  # -- Minimum available pods (can use minAvailable or maxUnavailable)
  minAvailable: 1
  # maxUnavailable: 1

EOF
    else
        cat >> ${CHART_NAME}/values.yaml << 'EOF'
# Pod Disruption Budget configuration
podDisruptionBudget:
  enabled: false
  minAvailable: 1

EOF
    fi

    cat >> ${CHART_NAME}/values.yaml << EOF
# Node selector
nodeSelector: {}

# Tolerations
tolerations: []

# Affinity rules
affinity:
  podAntiAffinity:
    preferredDuringSchedulingIgnoredDuringExecution:
    - weight: 100
      podAffinityTerm:
        labelSelector:
          matchExpressions:
          - key: app.kubernetes.io/name
            operator: In
            values:
            - ${CHART_NAME}
        topologyKey: kubernetes.io/hostname

# Health checks
livenessProbe:
  httpGet:
    path: /health
    port: http
  initialDelaySeconds: 30
  periodSeconds: 10
  timeoutSeconds: 5
  failureThreshold: 3

readinessProbe:
  httpGet:
    path: /ready
    port: http
  initialDelaySeconds: 10
  periodSeconds: 5
  timeoutSeconds: 3
  failureThreshold: 3

startupProbe:
  httpGet:
    path: /health
    port: http
  initialDelaySeconds: 0
  periodSeconds: 5
  timeoutSeconds: 3
  failureThreshold: 30

# Environment variables
env: []
  # - name: LOG_LEVEL
  #   value: "info"
  # - name: DATABASE_HOST
  #   valueFrom:
  #     secretKeyRef:
  #       name: db-secret
  #       key: host

# ConfigMap data
configMap:
  # -- Enable ConfigMap
  enabled: true
  # -- ConfigMap data
  data:
    APP_NAME: "${CHART_NAME}"
    ENVIRONMENT: "production"
    LOG_LEVEL: "info"

# Secret data (will be base64 encoded)
secret:
  # -- Enable Secret
  enabled: true
  # -- Secret data (these are examples, replace with actual secrets)
  data:
    # API_KEY: "your-api-key-here"
    # DATABASE_PASSWORD: "change-me"

# Persistent Volume configuration
persistence:
  # -- Enable persistence
  enabled: false
  # -- Storage class
  storageClass: ""
  # -- Access mode
  accessMode: ReadWriteOnce
  # -- Volume size
  size: 10Gi
  # -- Mount path
  mountPath: /data
  # -- Annotations
  annotations: {}

EOF

    if [ "$ENABLE_SERVICE_MONITOR" = true ]; then
        cat >> ${CHART_NAME}/values.yaml << 'EOF'
# ServiceMonitor for Prometheus Operator
serviceMonitor:
  # -- Enable ServiceMonitor
  enabled: true
  # -- Additional labels
  additionalLabels: {}
  # -- Scrape interval
  interval: 30s
  # -- Scrape timeout
  scrapeTimeout: 10s
  # -- Metrics path
  path: /metrics
  # -- Port name
  portName: http

EOF
    else
        cat >> ${CHART_NAME}/values.yaml << 'EOF'
# ServiceMonitor for Prometheus Operator
serviceMonitor:
  enabled: false
  interval: 30s
  path: /metrics

EOF
    fi

    if [ "$ENABLE_DATABASE" = true ]; then
        cat >> ${CHART_NAME}/values.yaml << 'EOF'
# PostgreSQL dependency configuration
postgresql:
  # -- Enable PostgreSQL
  enabled: true
  # -- PostgreSQL architecture
  architecture: standalone
  auth:
    # -- PostgreSQL username
    username: appuser
    # -- PostgreSQL password
    password: changeme
    # -- PostgreSQL database
    database: appdb
  primary:
    persistence:
      enabled: true
      size: 20Gi
    resources:
      requests:
        memory: 256Mi
        cpu: 250m
      limits:
        memory: 512Mi
        cpu: 500m

EOF
    fi

    if [ "$ENABLE_REDIS" = true ]; then
        cat >> ${CHART_NAME}/values.yaml << 'EOF'
# Redis dependency configuration
redis:
  # -- Enable Redis
  enabled: true
  # -- Redis architecture
  architecture: standalone
  auth:
    # -- Enable Redis authentication
    enabled: true
    # -- Redis password
    password: changeme
  master:
    persistence:
      enabled: true
      size: 8Gi
    resources:
      requests:
        memory: 128Mi
        cpu: 100m
      limits:
        memory: 256Mi
        cpu: 250m

EOF
    fi

    cat >> ${CHART_NAME}/values.yaml << 'EOF'
# Network Policy
networkPolicy:
  # -- Enable NetworkPolicy
  enabled: false
  # -- Pod selector for ingress
  podSelector:
    matchLabels: {}
  # -- Ingress rules
  ingress: []
  # -- Egress rules
  egress: []

# Horizontal Pod Autoscaler v2 (advanced)
# Uncomment to use custom metrics
# customMetrics:
#   - type: Pods
#     pods:
#       metric:
#         name: custom_metric
#       target:
#         type: AverageValue
#         averageValue: "100"
EOF

    print_success "values.yaml created"
}

# ============================================================================
# ENVIRONMENT-SPECIFIC VALUES
# ============================================================================
generate_environment_values() {
    mkdir -p ${CHART_NAME}/values
    
    # Development values
    cat > ${CHART_NAME}/values/dev.yaml << 'EOF'
# Development environment overrides

replicaCount: 1

image:
  pullPolicy: Always
  tag: "dev"

resources:
  limits:
    cpu: 200m
    memory: 256Mi
  requests:
    cpu: 50m
    memory: 64Mi

ingress:
  enabled: true
  hosts:
    - host: dev.example.com
      paths:
        - path: /
          pathType: Prefix
  tls:
    - secretName: dev-tls
      hosts:
        - dev.example.com

configMap:
  data:
    ENVIRONMENT: "development"
    LOG_LEVEL: "debug"

autoscaling:
  enabled: false

postgresql:
  enabled: true
  auth:
    password: dev-password
  primary:
    persistence:
      size: 5Gi
    resources:
      requests:
        memory: 128Mi
        cpu: 100m
      limits:
        memory: 256Mi
        cpu: 200m

redis:
  enabled: true
  auth:
    password: dev-password
  master:
    persistence:
      size: 2Gi
EOF

    # Staging values
    cat > ${CHART_NAME}/values/staging.yaml << 'EOF'
# Staging environment overrides

replicaCount: 2

image:
  tag: "staging"

resources:
  limits:
    cpu: 500m
    memory: 512Mi
  requests:
    cpu: 100m
    memory: 128Mi

ingress:
  enabled: true
  hosts:
    - host: staging.example.com
      paths:
        - path: /
          pathType: Prefix
  tls:
    - secretName: staging-tls
      hosts:
        - staging.example.com

configMap:
  data:
    ENVIRONMENT: "staging"
    LOG_LEVEL: "info"

autoscaling:
  enabled: true
  minReplicas: 2
  maxReplicas: 5

podDisruptionBudget:
  enabled: true
  minAvailable: 1

postgresql:
  enabled: true
  auth:
    password: staging-password
  primary:
    persistence:
      size: 10Gi

redis:
  enabled: true
  auth:
    password: staging-password
EOF

    # Production values
    cat > ${CHART_NAME}/values/prod.yaml << 'EOF'
# Production environment overrides

replicaCount: 3

image:
  pullPolicy: IfNotPresent
  tag: "stable"

resources:
  limits:
    cpu: 1000m
    memory: 1Gi
  requests:
    cpu: 200m
    memory: 256Mi

ingress:
  enabled: true
  annotations:
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
    nginx.ingress.kubernetes.io/rate-limit: "100"
  hosts:
    - host: app.example.com
      paths:
        - path: /
          pathType: Prefix
  tls:
    - secretName: prod-tls
      hosts:
        - app.example.com

configMap:
  data:
    ENVIRONMENT: "production"
    LOG_LEVEL: "warn"

autoscaling:
  enabled: true
  minReplicas: 3
  maxReplicas: 10
  targetCPUUtilizationPercentage: 70
  targetMemoryUtilizationPercentage: 80

podDisruptionBudget:
  enabled: true
  minAvailable: 2

postgresql:
  enabled: true
  architecture: replication
  auth:
    password: "" # Use external secret management
  primary:
    persistence:
      size: 50Gi
    resources:
      requests:
        memory: 512Mi
        cpu: 500m
      limits:
        memory: 1Gi
        cpu: 1000m

redis:
  enabled: true
  architecture: replication
  auth:
    password: "" # Use external secret management
  master:
    persistence:
      size: 20Gi
    resources:
      requests:
        memory: 256Mi
        cpu: 250m
      limits:
        memory: 512Mi
        cpu: 500m

networkPolicy:
  enabled: true
EOF

    print_success "Environment-specific values created"
}

# ============================================================================
# TEMPLATES GENERATOR
# ============================================================================
generate_templates() {
    mkdir -p ${CHART_NAME}/templates
    
    generate_helpers_tpl
    generate_deployment_yaml
    generate_service_yaml
    generate_serviceaccount_yaml
    generate_configmap_yaml
    generate_secret_yaml
    
    if [ "$ENABLE_INGRESS" = true ]; then
        generate_ingress_yaml
    fi
    
    if [ "$ENABLE_HPA" = true ]; then
        generate_hpa_yaml
    fi
    
    if [ "$ENABLE_PDB" = true ]; then
        generate_pdb_yaml
    fi
    
    if [ "$ENABLE_SERVICE_MONITOR" = true ]; then
        generate_servicemonitor_yaml
    fi
    
    generate_notes_txt
}

# ============================================================================
# _HELPERS.TPL
# ============================================================================
generate_helpers_tpl() {
    cat > ${CHART_NAME}/templates/_helpers.tpl << 'EOF'
{{/*
Expand the name of the chart.
*/}}
{{- define "mychart.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "mychart.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "mychart.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "mychart.labels" -}}
helm.sh/chart: {{ include "mychart.chart" . }}
{{ include "mychart.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "mychart.selectorLabels" -}}
app.kubernetes.io/name: {{ include "mychart.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "mychart.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "mychart.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Image name
*/}}
{{- define "mychart.image" -}}
{{- $registry := .Values.image.registry -}}
{{- $repository := .Values.image.repository -}}
{{- $tag := .Values.image.tag | default .Chart.AppVersion -}}
{{- printf "%s/%s:%s" $registry $repository $tag -}}
{{- end }}

{{/*
PostgreSQL host
*/}}
{{- define "mychart.postgresql.host" -}}
{{- if .Values.postgresql.enabled -}}
{{- printf "%s-postgresql" .Release.Name -}}
{{- else -}}
{{- .Values.externalDatabase.host -}}
{{- end -}}
{{- end }}

{{/*
Redis host
*/}}
{{- define "mychart.redis.host" -}}
{{- if .Values.redis.enabled -}}
{{- printf "%s-redis-master" .Release.Name -}}
{{- else -}}
{{- .Values.externalRedis.host -}}
{{- end -}}
{{- end }}
EOF

    print_success "_helpers.tpl created"
}

# ============================================================================
# DEPLOYMENT.YAML
# ============================================================================
generate_deployment_yaml() {
    cat > ${CHART_NAME}/templates/deployment.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "mychart.fullname" . }}
  labels:
    {{- include "mychart.labels" . | nindent 4 }}
spec:
  {{- if not .Values.autoscaling.enabled }}
  replicas: {{ .Values.replicaCount }}
  {{- end }}
  selector:
    matchLabels:
      {{- include "mychart.selectorLabels" . | nindent 6 }}
  template:
    metadata:
      annotations:
        checksum/config: {{ include (print $.Template.BasePath "/configmap.yaml") . | sha256sum }}
        checksum/secret: {{ include (print $.Template.BasePath "/secret.yaml") . | sha256sum }}
        {{- with .Values.podAnnotations }}
        {{- toYaml . | nindent 8 }}
        {{- end }}
      labels:
        {{- include "mychart.selectorLabels" . | nindent 8 }}
    spec:
      {{- with .Values.imagePullSecrets }}
      imagePullSecrets:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      serviceAccountName: {{ include "mychart.serviceAccountName" . }}
      securityContext:
        {{- toYaml .Values.podSecurityContext | nindent 8 }}
      containers:
      - name: {{ .Chart.Name }}
        securityContext:
          {{- toYaml .Values.securityContext | nindent 12 }}
        image: {{ include "mychart.image" . }}
        imagePullPolicy: {{ .Values.image.pullPolicy }}
        ports:
        - name: http
          containerPort: {{ .Values.service.targetPort }}
          protocol: TCP
        {{- if .Values.livenessProbe }}
        livenessProbe:
          {{- toYaml .Values.livenessProbe | nindent 12 }}
        {{- end }}
        {{- if .Values.readinessProbe }}
        readinessProbe:
          {{- toYaml .Values.readinessProbe | nindent 12 }}
        {{- end }}
        {{- if .Values.startupProbe }}
        startupProbe:
          {{- toYaml .Values.startupProbe | nindent 12 }}
        {{- end }}
        resources:
          {{- toYaml .Values.resources | nindent 12 }}
        env:
        {{- if .Values.configMap.enabled }}
        - name: CONFIG_MAP_NAME
          value: {{ include "mychart.fullname" . }}
        {{- end }}
        {{- if .Values.postgresql.enabled }}
        - name: DATABASE_HOST
          value: {{ include "mychart.postgresql.host" . }}
        - name: DATABASE_PORT
          value: "5432"
        - name: DATABASE_NAME
          value: {{ .Values.postgresql.auth.database }}
        - name: DATABASE_USER
          value: {{ .Values.postgresql.auth.username }}
        - name: DATABASE_PASSWORD
          valueFrom:
            secretKeyRef:
              name: {{ .Release.Name }}-postgresql
              key: password
        {{- end }}
        {{- if .Values.redis.enabled }}
        - name: REDIS_HOST
          value: {{ include "mychart.redis.host" . }}
        - name: REDIS_PORT
          value: "6379"
        - name: REDIS_PASSWORD
          valueFrom:
            secretKeyRef:
              name: {{ .Release.Name }}-redis
              key: redis-password
        {{- end }}
        {{- with .Values.env }}
        {{- toYaml . | nindent 8 }}
        {{- end }}
        {{- if .Values.configMap.enabled }}
        envFrom:
        - configMapRef:
            name: {{ include "mychart.fullname" . }}
        {{- end }}
        {{- if .Values.secret.enabled }}
        - secretRef:
            name: {{ include "mychart.fullname" . }}
        {{- end }}
        volumeMounts:
        - name: tmp
          mountPath: /tmp
        {{- if .Values.persistence.enabled }}
        - name: data
          mountPath: {{ .Values.persistence.mountPath }}
        {{- end }}
      volumes:
      - name: tmp
        emptyDir: {}
      {{- if .Values.persistence.enabled }}
      - name: data
        persistentVolumeClaim:
          claimName: {{ include "mychart.fullname" . }}
      {{- end }}
      {{- with .Values.nodeSelector }}
      nodeSelector:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.affinity }}
      affinity:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.tolerations }}
      tolerations:
        {{- toYaml . | nindent 8 }}
      {{- end }}
EOF

    print_success "deployment.yaml created"
}

# ============================================================================
# SERVICE.YAML
# ============================================================================
generate_service_yaml() {
    cat > ${CHART_NAME}/templates/service.yaml << 'EOF'
apiVersion: v1
kind: Service
metadata:
  name: {{ include "mychart.fullname" . }}
  labels:
    {{- include "mychart.labels" . | nindent 4 }}
  {{- with .Values.service.annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
spec:
  type: {{ .Values.service.type }}
  {{- if and (eq .Values.service.type "ClusterIP") .Values.service.sessionAffinity }}
  sessionAffinity: {{ .Values.service.sessionAffinity }}
  sessionAffinityConfig:
    clientIP:
      timeoutSeconds: 10800
  {{- end }}
  ports:
    - port: {{ .Values.service.port }}
      targetPort: http
      protocol: TCP
      name: http
      {{- if and (eq .Values.service.type "NodePort") .Values.service.nodePort }}
      nodePort: {{ .Values.service.nodePort }}
      {{- end }}
  selector:
    {{- include "mychart.selectorLabels" . | nindent 4 }}
EOF

    print_success "service.yaml created"
}

# ============================================================================
# SERVICEACCOUNT.YAML
# ============================================================================
generate_serviceaccount_yaml() {
    cat > ${CHART_NAME}/templates/serviceaccount.yaml << 'EOF'
{{- if .Values.serviceAccount.create -}}
apiVersion: v1
kind: ServiceAccount
metadata:
  name: {{ include "mychart.serviceAccountName" . }}
  labels:
    {{- include "mychart.labels" . | nindent 4 }}
  {{- with .Values.serviceAccount.annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
{{- end }}
EOF

    print_success "serviceaccount.yaml created"
}

# ============================================================================
# CONFIGMAP.YAML
# ============================================================================
generate_configmap_yaml() {
    cat > ${CHART_NAME}/templates/configmap.yaml << 'EOF'
{{- if .Values.configMap.enabled -}}
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "mychart.fullname" . }}
  labels:
    {{- include "mychart.labels" . | nindent 4 }}
data:
  {{- range $key, $value := .Values.configMap.data }}
  {{ $key }}: {{ $value | quote }}
  {{- end }}
{{- end }}
EOF

    print_success "configmap.yaml created"
}

# ============================================================================
# SECRET.YAML
# ============================================================================
generate_secret_yaml() {
    cat > ${CHART_NAME}/templates/secret.yaml << 'EOF'
{{- if .Values.secret.enabled -}}
apiVersion: v1
kind: Secret
metadata:
  name: {{ include "mychart.fullname" . }}
  labels:
    {{- include "mychart.labels" . | nindent 4 }}
type: Opaque
data:
  {{- range $key, $value := .Values.secret.data }}
  {{ $key }}: {{ $value | b64enc | quote }}
  {{- end }}
{{- end }}
EOF

    print_success "secret.yaml created"
}

# ============================================================================
# INGRESS.YAML
# ============================================================================
generate_ingress_yaml() {
    cat > ${CHART_NAME}/templates/ingress.yaml << 'EOF'
{{- if .Values.ingress.enabled -}}
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ include "mychart.fullname" . }}
  labels:
    {{- include "mychart.labels" . | nindent 4 }}
  {{- with .Values.ingress.annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
spec:
  {{- if .Values.ingress.className }}
  ingressClassName: {{ .Values.ingress.className }}
  {{- end }}
  {{- if .Values.ingress.tls }}
  tls:
    {{- range .Values.ingress.tls }}
    - hosts:
        {{- range .hosts }}
        - {{ . | quote }}
        {{- end }}
      secretName: {{ .secretName }}
    {{- end }}
  {{- end }}
  rules:
    {{- range .Values.ingress.hosts }}
    - host: {{ .host | quote }}
      http:
        paths:
          {{- range .paths }}
          - path: {{ .path }}
            pathType: {{ .pathType }}
            backend:
              service:
                name: {{ include "mychart.fullname" $ }}
                port:
                  number: {{ $.Values.service.port }}
          {{- end }}
    {{- end }}
{{- end }}
EOF

    print_success "ingress.yaml created"
}

# ============================================================================
# HPA.YAML
# ============================================================================
generate_hpa_yaml() {
    cat > ${CHART_NAME}/templates/hpa.yaml << 'EOF'
{{- if .Values.autoscaling.enabled }}
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: {{ include "mychart.fullname" . }}
  labels:
    {{- include "mychart.labels" . | nindent 4 }}
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: {{ include "mychart.fullname" . }}
  minReplicas: {{ .Values.autoscaling.minReplicas }}
  maxReplicas: {{ .Values.autoscaling.maxReplicas }}
  metrics:
    {{- if .Values.autoscaling.targetCPUUtilizationPercentage }}
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: {{ .Values.autoscaling.targetCPUUtilizationPercentage }}
    {{- end }}
    {{- if .Values.autoscaling.targetMemoryUtilizationPercentage }}
    - type: Resource
      resource:
        name: memory
        target:
          type: Utilization
          averageUtilization: {{ .Values.autoscaling.targetMemoryUtilizationPercentage }}
    {{- end }}
  {{- if .Values.autoscaling.behavior }}
  behavior:
    {{- toYaml .Values.autoscaling.behavior | nindent 4 }}
  {{- end }}
{{- end }}
EOF

    print_success "hpa.yaml created"
}

# ============================================================================
# PDB.YAML
# ============================================================================
generate_pdb_yaml() {
    cat > ${CHART_NAME}/templates/pdb.yaml << 'EOF'
{{- if .Values.podDisruptionBudget.enabled }}
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: {{ include "mychart.fullname" . }}
  labels:
    {{- include "mychart.labels" . | nindent 4 }}
spec:
  {{- if .Values.podDisruptionBudget.minAvailable }}
  minAvailable: {{ .Values.podDisruptionBudget.minAvailable }}
  {{- end }}
  {{- if .Values.podDisruptionBudget.maxUnavailable }}
  maxUnavailable: {{ .Values.podDisruptionBudget.maxUnavailable }}
  {{- end }}
  selector:
    matchLabels:
      {{- include "mychart.selectorLabels" . | nindent 6 }}
{{- end }}
EOF

    print_success "pdb.yaml created"
}

# ============================================================================
# SERVICEMONITOR.YAML
# ============================================================================
generate_servicemonitor_yaml() {
    cat > ${CHART_NAME}/templates/servicemonitor.yaml << 'EOF'
{{- if .Values.serviceMonitor.enabled }}
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: {{ include "mychart.fullname" . }}
  labels:
    {{- include "mychart.labels" . | nindent 4 }}
    {{- with .Values.serviceMonitor.additionalLabels }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
spec:
  selector:
    matchLabels:
      {{- include "mychart.selectorLabels" . | nindent 6 }}
  endpoints:
  - port: {{ .Values.serviceMonitor.portName | default "http" }}
    path: {{ .Values.serviceMonitor.path }}
    interval: {{ .Values.serviceMonitor.interval }}
    scrapeTimeout: {{ .Values.serviceMonitor.scrapeTimeout | default "10s" }}
{{- end }}
EOF

    print_success "servicemonitor.yaml created"
}

# ============================================================================
# NOTES.TXT
# ============================================================================
generate_notes_txt() {
    cat > ${CHART_NAME}/templates/NOTES.txt << 'EOF'
1. Get the application URL by running these commands:
{{- if .Values.ingress.enabled }}
{{- range $host := .Values.ingress.hosts }}
  {{- range .paths }}
  http{{ if $.Values.ingress.tls }}s{{ end }}://{{ $host.host }}{{ .path }}
  {{- end }}
{{- end }}
{{- else if contains "NodePort" .Values.service.type }}
  export NODE_PORT=$(kubectl get --namespace {{ .Release.Namespace }} -o jsonpath="{.spec.ports[0].nodePort}" services {{ include "mychart.fullname" . }})
  export NODE_IP=$(kubectl get nodes --namespace {{ .Release.Namespace }} -o jsonpath="{.items[0].status.addresses[0].address}")
  echo http://$NODE_IP:$NODE_PORT
{{- else if contains "LoadBalancer" .Values.service.type }}
     NOTE: It may take a few minutes for the LoadBalancer IP to be available.
           You can watch the status of by running 'kubectl get --namespace {{ .Release.Namespace }} svc -w {{ include "mychart.fullname" . }}'
  export SERVICE_IP=$(kubectl get svc --namespace {{ .Release.Namespace }} {{ include "mychart.fullname" . }} --template "{{"{{ range (index .status.loadBalancer.ingress 0) }}{{.}}{{ end }}"}}")
  echo http://$SERVICE_IP:{{ .Values.service.port }}
{{- else if contains "ClusterIP" .Values.service.type }}
  export POD_NAME=$(kubectl get pods --namespace {{ .Release.Namespace }} -l "app.kubernetes.io/name={{ include "mychart.name" . }},app.kubernetes.io/instance={{ .Release.Name }}" -o jsonpath="{.items[0].metadata.name}")
  export CONTAINER_PORT=$(kubectl get pod --namespace {{ .Release.Namespace }} $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}")
  echo "Visit http://127.0.0.1:8080 to use your application"
  kubectl --namespace {{ .Release.Namespace }} port-forward $POD_NAME 8080:$CONTAINER_PORT
{{- end }}

2. Check the deployment status:
  kubectl get pods -n {{ .Release.Namespace }} -l app.kubernetes.io/instance={{ .Release.Name }}

3. View logs:
  kubectl logs -n {{ .Release.Namespace }} -l app.kubernetes.io/instance={{ .Release.Name }} -f

{{- if .Values.postgresql.enabled }}

4. PostgreSQL database is enabled:
   Host: {{ include "mychart.postgresql.host" . }}
   Port: 5432
   Database: {{ .Values.postgresql.auth.database }}
   Username: {{ .Values.postgresql.auth.username }}
   
   Get password:
   kubectl get secret --namespace {{ .Release.Namespace }} {{ .Release.Name }}-postgresql -o jsonpath="{.data.password}" | base64 -d
{{- end }}

{{- if .Values.redis.enabled }}

5. Redis cache is enabled:
   Host: {{ include "mychart.redis.host" . }}
   Port: 6379
   
   Get password:
   kubectl get secret --namespace {{ .Release.Namespace }} {{ .Release.Name }}-redis -o jsonpath="{.data.redis-password}" | base64 -d
{{- end }}
EOF

    print_success "NOTES.txt created"
}

# ============================================================================
# .HELMIGNORE
# ============================================================================
generate_helmignore() {
    cat > ${CHART_NAME}/.helmignore << 'EOF'
# Patterns to ignore when building packages.
# This supports shell glob matching, relative path matching, and
# negation (prefixed with !). Only one pattern per line.
.DS_Store
# Common VCS dirs
.git/
.gitignore
.bzr/
.bzrignore
.hg/
.hgignore
.svn/
# Common backup files
*.swp
*.bak
*.tmp
*.orig
*~
# Various IDEs
.project
.idea/
*.tmproj
.vscode/
# CI/CD
.github/
.gitlab-ci.yml
# Documentation
README.md
CHANGELOG.md
EOF

    print_success ".helmignore created"
}

# ============================================================================
# README GENERATOR
# ============================================================================
generate_readme() {
    cat > ${CHART_NAME}/README.md << EOF
# ${CHART_NAME} Helm Chart

## Overview

This Helm chart deploys ${CHART_NAME} on a Kubernetes cluster.

## Prerequisites

- Kubernetes 1.24+
- Helm 3.10+
EOF

    if [ "$ENABLE_DATABASE" = true ]; then
        echo "- PostgreSQL (can be deployed as a dependency)" >> ${CHART_NAME}/README.md
    fi
    
    if [ "$ENABLE_REDIS" = true ]; then
        echo "- Redis (can be deployed as a dependency)" >> ${CHART_NAME}/README.md
    fi

    cat >> ${CHART_NAME}/README.md << 'EOF'

## Installing the Chart

### Install with default values

```bash
helm install my-release ./mychart
```

### Install with custom values

```bash
helm install my-release ./mychart -f custom-values.yaml
```

### Install for specific environment

```bash
# Development
helm install my-release ./mychart -f values/dev.yaml

# Staging
helm install my-release ./mychart -f values/staging.yaml

# Production
helm install my-release ./mychart -f values/prod.yaml
```

### Install with inline overrides

```bash
helm install my-release ./mychart \
  --set image.tag=v1.0.0 \
  --set replicaCount=5 \
  --set ingress.enabled=true
```

## Upgrading the Chart

```bash
# Upgrade with new values
helm upgrade my-release ./mychart -f values/prod.yaml

# Upgrade with specific image tag
helm upgrade my-release ./mychart --set image.tag=v1.1.0

# Force recreation of pods
helm upgrade my-release ./mychart --force

# Upgrade with wait for rollout
helm upgrade my-release ./mychart --wait --timeout 5m
```

## Uninstalling the Chart

```bash
# Uninstall release
helm uninstall my-release

# Uninstall and purge (remove all PVCs)
helm uninstall my-release --purge
```

## Configuration

### Common Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `replicaCount` | Number of replicas | `3` |
| `image.registry` | Image registry | `docker.io` |
| `image.repository` | Image repository | `mycompany/myapp` |
| `image.tag` | Image tag | `latest` |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `service.type` | Service type | `ClusterIP` |
| `service.port` | Service port | `80` |
| `resources.limits.cpu` | CPU limit | `500m` |
| `resources.limits.memory` | Memory limit | `512Mi` |
| `resources.requests.cpu` | CPU request | `100m` |
| `resources.requests.memory` | Memory request | `128Mi` |

### Ingress Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `ingress.enabled` | Enable ingress | `false` |
| `ingress.className` | Ingress class name | `nginx` |
| `ingress.hosts` | Ingress hosts | `[]` |
| `ingress.tls` | Ingress TLS configuration | `[]` |

### Autoscaling Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `autoscaling.enabled` | Enable HPA | `false` |
| `autoscaling.minReplicas` | Minimum replicas | `2` |
| `autoscaling.maxReplicas` | Maximum replicas | `10` |
| `autoscaling.targetCPUUtilizationPercentage` | Target CPU % | `80` |
| `autoscaling.targetMemoryUtilizationPercentage` | Target Memory % | `80` |

### Database Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `postgresql.enabled` | Enable PostgreSQL | `false` |
| `postgresql.auth.username` | Database username | `appuser` |
| `postgresql.auth.database` | Database name | `appdb` |

### Redis Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `redis.enabled` | Enable Redis | `false` |
| `redis.architecture` | Redis architecture | `standalone` |

## Examples

### Development Environment

\`\`\`yaml
# values/dev.yaml
replicaCount: 1

image:
  tag: dev
  pullPolicy: Always

resources:
  limits:
    cpu: 200m
    memory: 256Mi

ingress:
  enabled: true
  hosts:
    - host: dev.example.com
      paths:
        - path: /
          pathType: Prefix
\`\`\`

### Production Environment

\`\`\`yaml
# values/prod.yaml
replicaCount: 5

image:
  tag: v1.0.0
  pullPolicy: IfNotPresent

resources:
  limits:
    cpu: 1000m
    memory: 1Gi

autoscaling:
  enabled: true
  minReplicas: 3
  maxReplicas: 10

podDisruptionBudget:
  enabled: true
  minAvailable: 2

ingress:
  enabled: true
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-prod
  hosts:
    - host: app.example.com
      paths:
        - path: /
          pathType: Prefix
  tls:
    - secretName: app-tls
      hosts:
        - app.example.com
\`\`\`

## Rollback

```bash
# View revision history
helm history my-release

# Rollback to previous version
helm rollback my-release

# Rollback to specific revision
helm rollback my-release 2

# Rollback and wait
helm rollback my-release --wait
```

## Testing

```bash
# Dry run install
helm install my-release ./mychart --dry-run --debug

# Template rendering
helm template my-release ./mychart -f values/prod.yaml

# Lint chart
helm lint ./mychart

# Test release
helm test my-release
```

## Dependencies

Update chart dependencies:

```bash
# Update dependencies
helm dependency update ./mychart

# Build dependencies
helm dependency build ./mychart

# List dependencies
helm dependency list ./mychart
```

## Monitoring

If ServiceMonitor is enabled:

```bash
# Check ServiceMonitor
kubectl get servicemonitor -n <namespace>

# View Prometheus targets
# Access Prometheus UI and check targets
```

## Troubleshooting

### Check deployment status

\`\`\`bash
kubectl get pods -n <namespace> -l app.kubernetes.io/instance=my-release
kubectl describe deployment <deployment-name> -n <namespace>
\`\`\`

### View logs

\`\`\`bash
kubectl logs -n <namespace> -l app.kubernetes.io/instance=my-release -f
\`\`\`

### Debug pod issues

\`\`\`bash
kubectl describe pod <pod-name> -n <namespace>
kubectl get events -n <namespace> --sort-by='.lastTimestamp'
\`\`\`

### Helm issues

\`\`\`bash
# Check release status
helm status my-release

# Get all values for release
helm get values my-release

# Get manifest
helm get manifest my-release
\`\`\`

## Best Practices

1. **Use specific image tags** instead of `latest` in production
2. **Enable resource limits** to prevent resource exhaustion
3. **Enable PodDisruptionBudget** for high availability
4. **Use HPA** for automatic scaling
5. **Enable ingress with TLS** for secure external access
6. **Use secrets management** for sensitive data
7. **Configure health checks** properly
8. **Use affinity rules** for pod distribution
9. **Enable monitoring** with ServiceMonitor
10. **Test in staging** before production deployment

## Support

For issues or questions:
- GitHub: https://github.com/yourorg/${CHART_NAME}
- Documentation: https://docs.example.com
EOF

    print_success "README.md created"
}

# ============================================================================
# HELPER SCRIPTS GENERATOR
# ============================================================================
generate_helper_scripts() {
    mkdir -p scripts
    
    # Install script
    cat > scripts/install.sh << EOF
#!/bin/bash
# Install Helm chart

RELEASE_NAME=\${1:-${CHART_NAME}}
NAMESPACE=\${2:-default}
ENVIRONMENT=\${3:-prod}

echo "Installing \${RELEASE_NAME} in namespace \${NAMESPACE} (environment: \${ENVIRONMENT})..."

helm install \${RELEASE_NAME} ./${CHART_NAME} \\
  -f ${CHART_NAME}/values/\${ENVIRONMENT}.yaml \\
  --namespace \${NAMESPACE} \\
  --create-namespace \\
  --wait \\
  --timeout 5m

echo "Installation complete!"
echo ""
echo "Check status:"
echo "  helm status \${RELEASE_NAME} -n \${NAMESPACE}"
echo "  kubectl get pods -n \${NAMESPACE}"
EOF

    # Upgrade script
    cat > scripts/upgrade.sh << EOF
#!/bin/bash
# Upgrade Helm chart

RELEASE_NAME=\${1:-${CHART_NAME}}
NAMESPACE=\${2:-default}
ENVIRONMENT=\${3:-prod}
IMAGE_TAG=\${4}

echo "Upgrading \${RELEASE_NAME} in namespace \${NAMESPACE}..."

EXTRA_ARGS=""
if [ ! -z "\$IMAGE_TAG" ]; then
    EXTRA_ARGS="--set image.tag=\${IMAGE_TAG}"
fi

helm upgrade \${RELEASE_NAME} ./${CHART_NAME} \\
  -f ${CHART_NAME}/values/\${ENVIRONMENT}.yaml \\
  --namespace \${NAMESPACE} \\
  --wait \\
  --timeout 5m \\
  \${EXTRA_ARGS}

echo "Upgrade complete!"
EOF

    # Rollback script
    cat > scripts/rollback.sh << EOF
#!/bin/bash
# Rollback Helm release

RELEASE_NAME=\${1:-${CHART_NAME}}
NAMESPACE=\${2:-default}
REVISION=\${3}

echo "Rolling back \${RELEASE_NAME} in namespace \${NAMESPACE}..."

if [ -z "\$REVISION" ]; then
    helm rollback \${RELEASE_NAME} --namespace \${NAMESPACE} --wait
else
    helm rollback \${RELEASE_NAME} \${REVISION} --namespace \${NAMESPACE} --wait
fi

echo "Rollback complete!"
EOF

    # Uninstall script
    cat > scripts/uninstall.sh << EOF
#!/bin/bash
# Uninstall Helm chart

RELEASE_NAME=\${1:-${CHART_NAME}}
NAMESPACE=\${2:-default}

echo "⚠️  WARNING: This will uninstall \${RELEASE_NAME} from namespace \${NAMESPACE}"
read -p "Are you sure? (yes/no): " confirm

if [ "\$confirm" = "yes" ]; then
    helm uninstall \${RELEASE_NAME} --namespace \${NAMESPACE}
    echo "Uninstall complete!"
else
    echo "Uninstall cancelled"
fi
EOF

    # Template test script
    cat > scripts/test-template.sh << EOF
#!/bin/bash
# Test Helm template rendering

ENVIRONMENT=\${1:-prod}

echo "Testing template rendering for environment: \${ENVIRONMENT}..."

helm template test-release ./${CHART_NAME} \\
  -f ${CHART_NAME}/values/\${ENVIRONMENT}.yaml \\
  --debug

echo ""
echo "Template test complete!"
EOF

    chmod +x scripts/*.sh
    
    print_success "Helper scripts created"
}

# ============================================================================
# MAIN ORCHESTRATION
# ============================================================================
main() {
    display_header
    
    print_info "Starting Helm Chart Generator..."
    echo ""
    
    # Collect configurations
    collect_basic_info
    collect_image_info
    collect_service_config
    collect_optional_features
    
    echo ""
    print_info "Generating Helm chart..."
    echo ""
    
    # Create chart structure
    mkdir -p ${CHART_NAME}
    
    # Generate all files
    generate_chart_yaml
    generate_values_yaml
    generate_environment_values
    generate_templates
    generate_helmignore
    generate_readme
    generate_helper_scripts
    
    echo ""
    print_success "============================================================"
    print_success "   Helm Chart Generated Successfully!                      "
    print_success "============================================================"
    echo ""
    
    print_info "Generated structure:"
    tree -L 3 ${CHART_NAME}/ 2>/dev/null || find ${CHART_NAME}/ -type f | sed 's|^|  |'
    
    echo ""
    print_info "Quick start commands:"
    echo ""
    echo "  # Lint chart"
    echo "  helm lint ${CHART_NAME}"
    echo ""
    echo "  # Template test"
    echo "  helm template test-release ${CHART_NAME}"
    echo ""
    echo "  # Install (development)"
    echo "  helm install my-release ${CHART_NAME} -f ${CHART_NAME}/values/dev.yaml"
    echo ""
    echo "  # Install (production)"
    echo "  helm install my-release ${CHART_NAME} -f ${CHART_NAME}/values/prod.yaml"
    echo ""
    echo "  # Upgrade"
    echo "  helm upgrade my-release ${CHART_NAME} --set image.tag=v1.1.0"
    echo ""
    echo "  # Rollback"
    echo "  helm rollback my-release"
    echo ""
    
    if [ "$ENABLE_DATABASE" = true ] || [ "$ENABLE_REDIS" = true ]; then
        print_warning "Dependencies detected! Update them before installing:"
        echo "  helm dependency update ${CHART_NAME}"
        echo ""
    fi
    
    print_info "For detailed documentation, see: ${CHART_NAME}/README.md"
    echo ""
    
    print_success "🎉 Your Helm chart is ready to use!"
}

# Run main function
main
