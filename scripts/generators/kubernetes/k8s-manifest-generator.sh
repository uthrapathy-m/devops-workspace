#!/bin/bash

# Kubernetes Manifest Generator for Production Deployments
# Generates complete K8s manifests with best practices
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
APP_NAME=""
NAMESPACE="default"
APP_TYPE=""
REPLICAS=3
IMAGE_NAME=""
IMAGE_TAG="latest"
CONTAINER_PORT=8080
SERVICE_TYPE="ClusterIP"
ENABLE_INGRESS=false
ENABLE_HPA=false
ENABLE_PVC=false
ENABLE_CONFIGMAP=true
ENABLE_SECRET=true
ENABLE_RBAC=false
RESOURCE_LIMITS=true
HEALTH_CHECKS=true
INGRESS_HOST=""
TLS_ENABLED=false
DATABASE_TYPE="none"
ENVIRONMENT="production"

# Resource defaults
CPU_REQUEST="100m"
CPU_LIMIT="500m"
MEMORY_REQUEST="128Mi"
MEMORY_LIMIT="512Mi"

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
    echo "   Kubernetes Manifest Generator for Production            "
    echo "   Production-Ready K8s Configurations                      "
    echo "============================================================"
    echo ""
}

# Function to collect basic information
collect_basic_info() {
    print_header "=== Basic Application Information ==="
    echo ""
    
    read -p "Application name (e.g., my-app): " app_name
    APP_NAME=${app_name:-my-app}
    
    read -p "Namespace (default: default): " namespace
    NAMESPACE=${namespace:-default}
    
    read -p "Docker image name (e.g., myrepo/myapp): " image_name
    IMAGE_NAME=${image_name:-myrepo/myapp}
    
    read -p "Image tag (default: latest): " image_tag
    IMAGE_TAG=${image_tag:-latest}
    
    read -p "Container port (default: 8080): " container_port
    CONTAINER_PORT=${container_port:-8080}
    
    read -p "Number of replicas (default: 3): " replicas
    REPLICAS=${replicas:-3}
    
    print_success "Basic info collected"
}

# Function to select application type
select_app_type() {
    echo ""
    print_header "=== Select Application Type ==="
    echo "1) Stateless Web Application (REST API, Microservice)"
    echo "2) Frontend Application (React, Vue, Angular)"
    echo "3) Backend Application with Database"
    echo "4) Worker/Job Application (Celery, Queue Consumer)"
    echo "5) CronJob Application"
    echo "6) StatefulSet Application (Database, Kafka)"
    echo ""
    read -p "Enter your choice (1-6): " app_choice
    
    case $app_choice in
        1) APP_TYPE="stateless-api" ;;
        2) APP_TYPE="frontend" ;;
        3) APP_TYPE="backend-db" ;;
        4) APP_TYPE="worker" ;;
        5) APP_TYPE="cronjob" ;;
        6) APP_TYPE="statefulset" ;;
        *) print_error "Invalid choice"; exit 1 ;;
    esac
    
    print_success "Selected: $APP_TYPE"
}

# Function to collect service configuration
collect_service_config() {
    echo ""
    print_header "=== Service Configuration ==="
    
    if [[ "$APP_TYPE" != "cronjob" ]]; then
        echo "Service type:"
        echo "1) ClusterIP (internal only)"
        echo "2) NodePort (external access via node port)"
        echo "3) LoadBalancer (cloud load balancer)"
        read -p "Enter choice (1-3, default: 1): " service_choice
        
        case ${service_choice:-1} in
            1) SERVICE_TYPE="ClusterIP" ;;
            2) SERVICE_TYPE="NodePort" ;;
            3) SERVICE_TYPE="LoadBalancer" ;;
        esac
        
        print_info "Service type: $SERVICE_TYPE"
    fi
}

# Function to collect ingress configuration
collect_ingress_config() {
    if [[ "$APP_TYPE" == "frontend" || "$APP_TYPE" == "stateless-api" || "$APP_TYPE" == "backend-db" ]]; then
        echo ""
        read -p "Enable Ingress? (y/n): " ingress_choice
        if [[ $ingress_choice == "y" || $ingress_choice == "Y" ]]; then
            ENABLE_INGRESS=true
            read -p "Ingress hostname (e.g., myapp.example.com): " ingress_host
            INGRESS_HOST=${ingress_host:-myapp.example.com}
            
            read -p "Enable TLS/HTTPS? (y/n): " tls_choice
            if [[ $tls_choice == "y" || $tls_choice == "Y" ]]; then
                TLS_ENABLED=true
            fi
            print_success "Ingress enabled for $INGRESS_HOST"
        fi
    fi
}

# Function to collect scaling configuration
collect_scaling_config() {
    if [[ "$APP_TYPE" != "cronjob" && "$APP_TYPE" != "statefulset" ]]; then
        echo ""
        read -p "Enable Horizontal Pod Autoscaler (HPA)? (y/n): " hpa_choice
        if [[ $hpa_choice == "y" || $hpa_choice == "Y" ]]; then
            ENABLE_HPA=true
            print_success "HPA enabled"
        fi
    fi
}

# Function to collect storage configuration
collect_storage_config() {
    if [[ "$APP_TYPE" == "backend-db" || "$APP_TYPE" == "statefulset" || "$APP_TYPE" == "worker" ]]; then
        echo ""
        read -p "Need persistent storage (PVC)? (y/n): " pvc_choice
        if [[ $pvc_choice == "y" || $pvc_choice == "Y" ]]; then
            ENABLE_PVC=true
            print_success "PVC enabled"
        fi
    fi
}

# Function to collect database configuration
collect_database_config() {
    if [[ "$APP_TYPE" == "backend-db" ]]; then
        echo ""
        print_header "=== Database Configuration ==="
        echo "1) PostgreSQL"
        echo "2) MySQL"
        echo "3) MongoDB"
        echo "4) Redis"
        echo "5) None (external database)"
        read -p "Enter choice (1-5): " db_choice
        
        case $db_choice in
            1) DATABASE_TYPE="postgresql" ;;
            2) DATABASE_TYPE="mysql" ;;
            3) DATABASE_TYPE="mongodb" ;;
            4) DATABASE_TYPE="redis" ;;
            5) DATABASE_TYPE="none" ;;
        esac
        
        print_info "Database: $DATABASE_TYPE"
    fi
}

# Function to collect resource requirements
collect_resource_config() {
    echo ""
    print_header "=== Resource Configuration ==="
    
    echo "Select resource profile:"
    echo "1) Small (CPU: 100m-500m, Memory: 128Mi-512Mi)"
    echo "2) Medium (CPU: 200m-1000m, Memory: 256Mi-1Gi)"
    echo "3) Large (CPU: 500m-2000m, Memory: 512Mi-2Gi)"
    echo "4) Custom"
    read -p "Enter choice (1-4, default: 1): " resource_choice
    
    case ${resource_choice:-1} in
        1)
            CPU_REQUEST="100m"
            CPU_LIMIT="500m"
            MEMORY_REQUEST="128Mi"
            MEMORY_LIMIT="512Mi"
            ;;
        2)
            CPU_REQUEST="200m"
            CPU_LIMIT="1000m"
            MEMORY_REQUEST="256Mi"
            MEMORY_LIMIT="1Gi"
            ;;
        3)
            CPU_REQUEST="500m"
            CPU_LIMIT="2000m"
            MEMORY_REQUEST="512Mi"
            MEMORY_LIMIT="2Gi"
            ;;
        4)
            read -p "CPU request (e.g., 100m): " cpu_req
            CPU_REQUEST=${cpu_req:-100m}
            read -p "CPU limit (e.g., 500m): " cpu_lim
            CPU_LIMIT=${cpu_lim:-500m}
            read -p "Memory request (e.g., 128Mi): " mem_req
            MEMORY_REQUEST=${mem_req:-128Mi}
            read -p "Memory limit (e.g., 512Mi): " mem_lim
            MEMORY_LIMIT=${mem_lim:-512Mi}
            ;;
    esac
    
    print_info "Resources: CPU($CPU_REQUEST-$CPU_LIMIT) Memory($MEMORY_REQUEST-$MEMORY_LIMIT)"
}

# Function to collect additional options
collect_additional_options() {
    echo ""
    print_header "=== Additional Options ==="
    
    read -p "Enable RBAC (ServiceAccount)? (y/n): " rbac_choice
    ENABLE_RBAC=$([[ $rbac_choice == "y" || $rbac_choice == "Y" ]] && echo true || echo false)
    
    print_info "Configuration complete!"
}

# ============================================================================
# NAMESPACE GENERATOR
# ============================================================================
generate_namespace() {
    if [[ "$NAMESPACE" != "default" ]]; then
        cat > k8s/00-namespace.yaml << EOF
apiVersion: v1
kind: Namespace
metadata:
  name: ${NAMESPACE}
  labels:
    name: ${NAMESPACE}
    environment: ${ENVIRONMENT}
EOF
        print_success "Namespace manifest created"
    fi
}

# ============================================================================
# CONFIGMAP GENERATOR
# ============================================================================
generate_configmap() {
    cat > k8s/01-configmap.yaml << EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: ${APP_NAME}-config
  namespace: ${NAMESPACE}
  labels:
    app: ${APP_NAME}
data:
  # Application configuration
  APP_NAME: "${APP_NAME}"
  ENVIRONMENT: "${ENVIRONMENT}"
  LOG_LEVEL: "info"
  
  # Add your application-specific config here
  # DATABASE_HOST: "postgres-service"
  # REDIS_HOST: "redis-service"
EOF

    if [[ "$DATABASE_TYPE" != "none" ]]; then
        cat >> k8s/01-configmap.yaml << EOF
  DATABASE_HOST: "${DATABASE_TYPE}-service"
  DATABASE_PORT: "$( [[ "$DATABASE_TYPE" == "postgresql" ]] && echo "5432" || [[ "$DATABASE_TYPE" == "mysql" ]] && echo "3306" || [[ "$DATABASE_TYPE" == "mongodb" ]] && echo "27017" || echo "6379" )"
EOF
    fi

    print_success "ConfigMap created"
}

# ============================================================================
# SECRET GENERATOR
# ============================================================================
generate_secret() {
    cat > k8s/02-secret.yaml << EOF
apiVersion: v1
kind: Secret
metadata:
  name: ${APP_NAME}-secret
  namespace: ${NAMESPACE}
  labels:
    app: ${APP_NAME}
type: Opaque
stringData:
  # IMPORTANT: Replace these with actual values or use external secret management
  # Consider using tools like: Sealed Secrets, External Secrets Operator, or Vault
  
  # Database credentials (base64 encoded in production)
  DATABASE_USER: "appuser"
  DATABASE_PASSWORD: "changeme123"
  
  # API Keys
  API_KEY: "your-api-key-here"
  SECRET_KEY: "your-secret-key-here"
  
  # Add your sensitive data here
EOF

    print_success "Secret template created (UPDATE WITH REAL VALUES!)"
    print_warning "Remember to update secret values before deploying!"
}

# ============================================================================
# DEPLOYMENT GENERATOR
# ============================================================================
generate_deployment() {
    cat > k8s/03-deployment.yaml << EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ${APP_NAME}
  namespace: ${NAMESPACE}
  labels:
    app: ${APP_NAME}
    version: v1
spec:
  replicas: ${REPLICAS}
  selector:
    matchLabels:
      app: ${APP_NAME}
  template:
    metadata:
      labels:
        app: ${APP_NAME}
        version: v1
      annotations:
        prometheus.io/scrape: "true"
        prometheus.io/port: "${CONTAINER_PORT}"
        prometheus.io/path: "/metrics"
    spec:
EOF

    if [ "$ENABLE_RBAC" = true ]; then
        cat >> k8s/03-deployment.yaml << EOF
      serviceAccountName: ${APP_NAME}-sa
EOF
    fi

    cat >> k8s/03-deployment.yaml << EOF
      securityContext:
        runAsNonRoot: true
        runAsUser: 1000
        fsGroup: 1000
        seccompProfile:
          type: RuntimeDefault
      containers:
      - name: ${APP_NAME}
        image: ${IMAGE_NAME}:${IMAGE_TAG}
        imagePullPolicy: Always
        ports:
        - name: http
          containerPort: ${CONTAINER_PORT}
          protocol: TCP
EOF

    if [ "$HEALTH_CHECKS" = true ]; then
        cat >> k8s/03-deployment.yaml << EOF
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
EOF
    fi

    if [ "$RESOURCE_LIMITS" = true ]; then
        cat >> k8s/03-deployment.yaml << EOF
        resources:
          requests:
            memory: "${MEMORY_REQUEST}"
            cpu: "${CPU_REQUEST}"
          limits:
            memory: "${MEMORY_LIMIT}"
            cpu: "${CPU_LIMIT}"
EOF
    fi

    cat >> k8s/03-deployment.yaml << EOF
        env:
        - name: PORT
          value: "${CONTAINER_PORT}"
        envFrom:
        - configMapRef:
            name: ${APP_NAME}-config
        - secretRef:
            name: ${APP_NAME}-secret
        securityContext:
          allowPrivilegeEscalation: false
          capabilities:
            drop:
            - ALL
          readOnlyRootFilesystem: true
EOF

    if [ "$ENABLE_PVC" = true ]; then
        cat >> k8s/03-deployment.yaml << EOF
        volumeMounts:
        - name: data
          mountPath: /app/data
        - name: tmp
          mountPath: /tmp
      volumes:
      - name: data
        persistentVolumeClaim:
          claimName: ${APP_NAME}-pvc
      - name: tmp
        emptyDir: {}
EOF
    else
        cat >> k8s/03-deployment.yaml << EOF
        volumeMounts:
        - name: tmp
          mountPath: /tmp
      volumes:
      - name: tmp
        emptyDir: {}
EOF
    fi

    cat >> k8s/03-deployment.yaml << EOF
      affinity:
        podAntiAffinity:
          preferredDuringSchedulingIgnoredDuringExecution:
          - weight: 100
            podAffinityTerm:
              labelSelector:
                matchExpressions:
                - key: app
                  operator: In
                  values:
                  - ${APP_NAME}
              topologyKey: kubernetes.io/hostname
EOF

    print_success "Deployment manifest created"
}

# ============================================================================
# SERVICE GENERATOR
# ============================================================================
generate_service() {
    if [[ "$APP_TYPE" != "cronjob" ]]; then
        cat > k8s/04-service.yaml << EOF
apiVersion: v1
kind: Service
metadata:
  name: ${APP_NAME}-service
  namespace: ${NAMESPACE}
  labels:
    app: ${APP_NAME}
  annotations:
    service.beta.kubernetes.io/aws-load-balancer-type: "nlb"  # For AWS
spec:
  type: ${SERVICE_TYPE}
  selector:
    app: ${APP_NAME}
  ports:
  - name: http
    port: 80
    targetPort: ${CONTAINER_PORT}
    protocol: TCP
EOF

        if [[ "$SERVICE_TYPE" == "NodePort" ]]; then
            cat >> k8s/04-service.yaml << EOF
    nodePort: 30080
EOF
        fi

        cat >> k8s/04-service.yaml << EOF
  sessionAffinity: ClientIP
  sessionAffinityConfig:
    clientIP:
      timeoutSeconds: 10800
EOF

        print_success "Service manifest created"
    fi
}

# ============================================================================
# INGRESS GENERATOR
# ============================================================================
generate_ingress() {
    if [ "$ENABLE_INGRESS" = true ]; then
        cat > k8s/05-ingress.yaml << EOF
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ${APP_NAME}-ingress
  namespace: ${NAMESPACE}
  labels:
    app: ${APP_NAME}
  annotations:
    # Nginx Ingress Controller
    nginx.ingress.kubernetes.io/rewrite-target: /
    nginx.ingress.kubernetes.io/ssl-redirect: "$( [ "$TLS_ENABLED" = true ] && echo "true" || echo "false" )"
    
    # Rate limiting
    nginx.ingress.kubernetes.io/limit-rps: "100"
    
    # CORS (if needed)
    # nginx.ingress.kubernetes.io/enable-cors: "true"
    # nginx.ingress.kubernetes.io/cors-allow-origin: "*"
    
    # SSL Configuration
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
    
    # Timeouts
    nginx.ingress.kubernetes.io/proxy-connect-timeout: "60"
    nginx.ingress.kubernetes.io/proxy-send-timeout: "60"
    nginx.ingress.kubernetes.io/proxy-read-timeout: "60"
spec:
  ingressClassName: nginx
EOF

        if [ "$TLS_ENABLED" = true ]; then
            cat >> k8s/05-ingress.yaml << EOF
  tls:
  - hosts:
    - ${INGRESS_HOST}
    secretName: ${APP_NAME}-tls
EOF
        fi

        cat >> k8s/05-ingress.yaml << EOF
  rules:
  - host: ${INGRESS_HOST}
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: ${APP_NAME}-service
            port:
              number: 80
EOF

        print_success "Ingress manifest created"
    fi
}

# ============================================================================
# HPA GENERATOR
# ============================================================================
generate_hpa() {
    if [ "$ENABLE_HPA" = true ]; then
        cat > k8s/06-hpa.yaml << EOF
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: ${APP_NAME}-hpa
  namespace: ${NAMESPACE}
  labels:
    app: ${APP_NAME}
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: ${APP_NAME}
  minReplicas: ${REPLICAS}
  maxReplicas: $((REPLICAS * 3))
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 80
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

        print_success "HPA manifest created"
    fi
}

# ============================================================================
# PVC GENERATOR
# ============================================================================
generate_pvc() {
    if [ "$ENABLE_PVC" = true ]; then
        cat > k8s/07-pvc.yaml << EOF
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: ${APP_NAME}-pvc
  namespace: ${NAMESPACE}
  labels:
    app: ${APP_NAME}
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
  storageClassName: standard  # Change based on your cloud provider
  # For AWS EBS: gp2, gp3
  # For GCP PD: standard, pd-ssd
  # For Azure: managed-premium
EOF

        print_success "PVC manifest created"
    fi
}

# ============================================================================
# RBAC GENERATOR
# ============================================================================
generate_rbac() {
    if [ "$ENABLE_RBAC" = true ]; then
        cat > k8s/08-rbac.yaml << EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: ${APP_NAME}-sa
  namespace: ${NAMESPACE}
  labels:
    app: ${APP_NAME}
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: ${APP_NAME}-role
  namespace: ${NAMESPACE}
  labels:
    app: ${APP_NAME}
rules:
# Add specific permissions your app needs
- apiGroups: [""]
  resources: ["configmaps", "secrets"]
  verbs: ["get", "list", "watch"]
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "list"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: ${APP_NAME}-rolebinding
  namespace: ${NAMESPACE}
  labels:
    app: ${APP_NAME}
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: ${APP_NAME}-role
subjects:
- kind: ServiceAccount
  name: ${APP_NAME}-sa
  namespace: ${NAMESPACE}
EOF

        print_success "RBAC manifests created"
    fi
}

# ============================================================================
# POD DISRUPTION BUDGET GENERATOR
# ============================================================================
generate_pdb() {
    if [[ "$APP_TYPE" != "cronjob" && "$REPLICAS" -gt 1 ]]; then
        cat > k8s/09-pdb.yaml << EOF
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: ${APP_NAME}-pdb
  namespace: ${NAMESPACE}
  labels:
    app: ${APP_NAME}
spec:
  minAvailable: 1
  selector:
    matchLabels:
      app: ${APP_NAME}
EOF

        print_success "PodDisruptionBudget created"
    fi
}

# ============================================================================
# NETWORK POLICY GENERATOR
# ============================================================================
generate_network_policy() {
    cat > k8s/10-network-policy.yaml << EOF
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: ${APP_NAME}-network-policy
  namespace: ${NAMESPACE}
  labels:
    app: ${APP_NAME}
spec:
  podSelector:
    matchLabels:
      app: ${APP_NAME}
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          name: ${NAMESPACE}
    - podSelector:
        matchLabels:
          app: ${APP_NAME}
    ports:
    - protocol: TCP
      port: ${CONTAINER_PORT}
  egress:
  # Allow DNS
  - to:
    - namespaceSelector:
        matchLabels:
          name: kube-system
    ports:
    - protocol: UDP
      port: 53
  # Allow all egress (restrict in production)
  - to:
    - namespaceSelector: {}
    ports:
    - protocol: TCP
      port: 443
    - protocol: TCP
      port: 80
EOF

    if [[ "$DATABASE_TYPE" != "none" ]]; then
        DB_PORT=$( [[ "$DATABASE_TYPE" == "postgresql" ]] && echo "5432" || [[ "$DATABASE_TYPE" == "mysql" ]] && echo "3306" || [[ "$DATABASE_TYPE" == "mongodb" ]] && echo "27017" || echo "6379" )
        cat >> k8s/10-network-policy.yaml << EOF
    - protocol: TCP
      port: ${DB_PORT}
EOF
    fi

    print_success "NetworkPolicy created"
}

# ============================================================================
# DATABASE DEPLOYMENT GENERATOR
# ============================================================================
generate_database() {
    if [[ "$DATABASE_TYPE" != "none" ]]; then
        case $DATABASE_TYPE in
            postgresql)
                generate_postgresql
                ;;
            mysql)
                generate_mysql
                ;;
            mongodb)
                generate_mongodb
                ;;
            redis)
                generate_redis
                ;;
        esac
    fi
}

generate_postgresql() {
    cat > k8s/11-postgresql.yaml << EOF
apiVersion: v1
kind: Secret
metadata:
  name: postgresql-secret
  namespace: ${NAMESPACE}
type: Opaque
stringData:
  POSTGRES_PASSWORD: "changeme123"
  POSTGRES_USER: "appuser"
  POSTGRES_DB: "appdb"
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: postgresql-pvc
  namespace: ${NAMESPACE}
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 20Gi
  storageClassName: standard
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: postgresql
  namespace: ${NAMESPACE}
spec:
  serviceName: postgresql-service
  replicas: 1
  selector:
    matchLabels:
      app: postgresql
  template:
    metadata:
      labels:
        app: postgresql
    spec:
      containers:
      - name: postgresql
        image: postgres:15-alpine
        ports:
        - containerPort: 5432
          name: postgres
        envFrom:
        - secretRef:
            name: postgresql-secret
        volumeMounts:
        - name: postgresql-storage
          mountPath: /var/lib/postgresql/data
        resources:
          requests:
            memory: "256Mi"
            cpu: "250m"
          limits:
            memory: "512Mi"
            cpu: "500m"
      volumes:
      - name: postgresql-storage
        persistentVolumeClaim:
          claimName: postgresql-pvc
---
apiVersion: v1
kind: Service
metadata:
  name: postgresql-service
  namespace: ${NAMESPACE}
spec:
  ports:
  - port: 5432
    targetPort: 5432
  selector:
    app: postgresql
  clusterIP: None
EOF
    print_success "PostgreSQL manifests created"
}

generate_mysql() {
    cat > k8s/11-mysql.yaml << EOF
apiVersion: v1
kind: Secret
metadata:
  name: mysql-secret
  namespace: ${NAMESPACE}
type: Opaque
stringData:
  MYSQL_ROOT_PASSWORD: "rootpassword123"
  MYSQL_PASSWORD: "changeme123"
  MYSQL_USER: "appuser"
  MYSQL_DATABASE: "appdb"
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mysql-pvc
  namespace: ${NAMESPACE}
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 20Gi
  storageClassName: standard
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: mysql
  namespace: ${NAMESPACE}
spec:
  serviceName: mysql-service
  replicas: 1
  selector:
    matchLabels:
      app: mysql
  template:
    metadata:
      labels:
        app: mysql
    spec:
      containers:
      - name: mysql
        image: mysql:8.0
        ports:
        - containerPort: 3306
          name: mysql
        envFrom:
        - secretRef:
            name: mysql-secret
        volumeMounts:
        - name: mysql-storage
          mountPath: /var/lib/mysql
        resources:
          requests:
            memory: "256Mi"
            cpu: "250m"
          limits:
            memory: "512Mi"
            cpu: "500m"
      volumes:
      - name: mysql-storage
        persistentVolumeClaim:
          claimName: mysql-pvc
---
apiVersion: v1
kind: Service
metadata:
  name: mysql-service
  namespace: ${NAMESPACE}
spec:
  ports:
  - port: 3306
    targetPort: 3306
  selector:
    app: mysql
  clusterIP: None
EOF
    print_success "MySQL manifests created"
}

generate_mongodb() {
    cat > k8s/11-mongodb.yaml << EOF
apiVersion: v1
kind: Secret
metadata:
  name: mongodb-secret
  namespace: ${NAMESPACE}
type: Opaque
stringData:
  MONGO_INITDB_ROOT_USERNAME: "admin"
  MONGO_INITDB_ROOT_PASSWORD: "changeme123"
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mongodb-pvc
  namespace: ${NAMESPACE}
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 20Gi
  storageClassName: standard
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: mongodb
  namespace: ${NAMESPACE}
spec:
  serviceName: mongodb-service
  replicas: 1
  selector:
    matchLabels:
      app: mongodb
  template:
    metadata:
      labels:
        app: mongodb
    spec:
      containers:
      - name: mongodb
        image: mongo:6
        ports:
        - containerPort: 27017
          name: mongodb
        envFrom:
        - secretRef:
            name: mongodb-secret
        volumeMounts:
        - name: mongodb-storage
          mountPath: /data/db
        resources:
          requests:
            memory: "256Mi"
            cpu: "250m"
          limits:
            memory: "512Mi"
            cpu: "500m"
      volumes:
      - name: mongodb-storage
        persistentVolumeClaim:
          claimName: mongodb-pvc
---
apiVersion: v1
kind: Service
metadata:
  name: mongodb-service
  namespace: ${NAMESPACE}
spec:
  ports:
  - port: 27017
    targetPort: 27017
  selector:
    app: mongodb
  clusterIP: None
EOF
    print_success "MongoDB manifests created"
}

generate_redis() {
    cat > k8s/11-redis.yaml << EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: redis-config
  namespace: ${NAMESPACE}
data:
  redis.conf: |
    maxmemory 256mb
    maxmemory-policy allkeys-lru
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: redis
  namespace: ${NAMESPACE}
spec:
  serviceName: redis-service
  replicas: 1
  selector:
    matchLabels:
      app: redis
  template:
    metadata:
      labels:
        app: redis
    spec:
      containers:
      - name: redis
        image: redis:7-alpine
        ports:
        - containerPort: 6379
          name: redis
        command:
        - redis-server
        - "/etc/redis/redis.conf"
        volumeMounts:
        - name: redis-config
          mountPath: /etc/redis
        resources:
          requests:
            memory: "128Mi"
            cpu: "100m"
          limits:
            memory: "256Mi"
            cpu: "250m"
      volumes:
      - name: redis-config
        configMap:
          name: redis-config
---
apiVersion: v1
kind: Service
metadata:
  name: redis-service
  namespace: ${NAMESPACE}
spec:
  ports:
  - port: 6379
    targetPort: 6379
  selector:
    app: redis
  clusterIP: None
EOF
    print_success "Redis manifests created"
}

# ============================================================================
# CRONJOB GENERATOR (if applicable)
# ============================================================================
generate_cronjob() {
    if [[ "$APP_TYPE" == "cronjob" ]]; then
        cat > k8s/12-cronjob.yaml << EOF
apiVersion: batch/v1
kind: CronJob
metadata:
  name: ${APP_NAME}-cronjob
  namespace: ${NAMESPACE}
  labels:
    app: ${APP_NAME}
spec:
  schedule: "0 * * * *"  # Every hour - adjust as needed
  concurrencyPolicy: Forbid
  successfulJobsHistoryLimit: 3
  failedJobsHistoryLimit: 3
  jobTemplate:
    spec:
      template:
        metadata:
          labels:
            app: ${APP_NAME}
        spec:
          restartPolicy: OnFailure
          containers:
          - name: ${APP_NAME}
            image: ${IMAGE_NAME}:${IMAGE_TAG}
            imagePullPolicy: Always
            envFrom:
            - configMapRef:
                name: ${APP_NAME}-config
            - secretRef:
                name: ${APP_NAME}-secret
            resources:
              requests:
                memory: "${MEMORY_REQUEST}"
                cpu: "${CPU_REQUEST}"
              limits:
                memory: "${MEMORY_LIMIT}"
                cpu: "${CPU_LIMIT}"
EOF
        print_success "CronJob manifest created"
    fi
}

# ============================================================================
# README GENERATOR
# ============================================================================
generate_readme() {
    cat > k8s/README.md << EOF
# Kubernetes Deployment Guide

## Application: ${APP_NAME}

### Generated Configuration
- **Application Type**: ${APP_TYPE}
- **Namespace**: ${NAMESPACE}
- **Replicas**: ${REPLICAS}
- **Image**: ${IMAGE_NAME}:${IMAGE_TAG}
- **Container Port**: ${CONTAINER_PORT}
- **Service Type**: ${SERVICE_TYPE}
- **Ingress**: ${ENABLE_INGRESS}
- **HPA**: ${ENABLE_HPA}
- **Database**: ${DATABASE_TYPE}

## Prerequisites

1. **Kubernetes Cluster**: v1.24+ recommended
2. **kubectl**: Configured to connect to your cluster
3. **Container Registry**: Docker image pushed to registry
4. **Ingress Controller**: (if using Ingress)
   \`\`\`bash
   kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.1/deploy/static/provider/cloud/deploy.yaml
   \`\`\`

## Deployment Steps

### 1. Review and Update Configuration

**IMPORTANT: Update these files before deploying:**

- \`02-secret.yaml\`: Replace with real credentials
- \`01-configmap.yaml\`: Update configuration values
EOF

    if [[ "$DATABASE_TYPE" != "none" ]]; then
        cat >> k8s/README.md << EOF
- \`11-${DATABASE_TYPE}.yaml\`: Update database credentials
EOF
    fi

    cat >> k8s/README.md << EOF

### 2. Create Namespace
\`\`\`bash
kubectl apply -f 00-namespace.yaml
\`\`\`

### 3. Deploy Configuration
\`\`\`bash
kubectl apply -f 01-configmap.yaml
kubectl apply -f 02-secret.yaml
\`\`\`

### 4. Deploy RBAC (if enabled)
\`\`\`bash
kubectl apply -f 08-rbac.yaml
\`\`\`

### 5. Deploy Storage (if enabled)
\`\`\`bash
kubectl apply -f 07-pvc.yaml
\`\`\`

### 6. Deploy Database (if included)
\`\`\`bash
EOF

    if [[ "$DATABASE_TYPE" != "none" ]]; then
        cat >> k8s/README.md << EOF
kubectl apply -f 11-${DATABASE_TYPE}.yaml

# Wait for database to be ready
kubectl wait --for=condition=ready pod -l app=${DATABASE_TYPE} -n ${NAMESPACE} --timeout=300s
EOF
    fi

    cat >> k8s/README.md << EOF

### 7. Deploy Application
\`\`\`bash
kubectl apply -f 03-deployment.yaml
kubectl apply -f 04-service.yaml
\`\`\`

### 8. Deploy Ingress (if enabled)
\`\`\`bash
kubectl apply -f 05-ingress.yaml
\`\`\`

### 9. Deploy HPA (if enabled)
\`\`\`bash
kubectl apply -f 06-hpa.yaml
\`\`\`

### 10. Deploy Network Policy
\`\`\`bash
kubectl apply -f 10-network-policy.yaml
\`\`\`

### 11. Deploy Pod Disruption Budget
\`\`\`bash
kubectl apply -f 09-pdb.yaml
\`\`\`

## Quick Deploy (All at once)
\`\`\`bash
# Deploy everything in order
kubectl apply -f k8s/ --recursive

# Or use specific order
for f in k8s/*.yaml; do kubectl apply -f "\$f"; done
\`\`\`

## Verification

### Check Deployment Status
\`\`\`bash
kubectl get all -n ${NAMESPACE}
kubectl get pods -n ${NAMESPACE}
kubectl get svc -n ${NAMESPACE}
kubectl get ingress -n ${NAMESPACE}
\`\`\`

### Check Pod Logs
\`\`\`bash
kubectl logs -f deployment/${APP_NAME} -n ${NAMESPACE}
\`\`\`

### Check Pod Details
\`\`\`bash
kubectl describe pod <pod-name> -n ${NAMESPACE}
\`\`\`

### Check Events
\`\`\`bash
kubectl get events -n ${NAMESPACE} --sort-by='.lastTimestamp'
\`\`\`

## Accessing the Application

EOF

    if [ "$ENABLE_INGRESS" = true ]; then
        cat >> k8s/README.md << EOF
### Via Ingress
\`\`\`
$( [ "$TLS_ENABLED" = true ] && echo "https" || echo "http" )://${INGRESS_HOST}
\`\`\`

EOF
    fi

    if [[ "$SERVICE_TYPE" == "LoadBalancer" ]]; then
        cat >> k8s/README.md << EOF
### Via LoadBalancer
\`\`\`bash
kubectl get svc ${APP_NAME}-service -n ${NAMESPACE}
# Use EXTERNAL-IP
\`\`\`

EOF
    fi

    cat >> k8s/README.md << EOF
### Port Forward (for testing)
\`\`\`bash
kubectl port-forward svc/${APP_NAME}-service -n ${NAMESPACE} 8080:80
# Access at http://localhost:8080
\`\`\`

## Scaling

### Manual Scaling
\`\`\`bash
kubectl scale deployment/${APP_NAME} --replicas=5 -n ${NAMESPACE}
\`\`\`

EOF

    if [ "$ENABLE_HPA" = true ]; then
        cat >> k8s/README.md << EOF
### Auto Scaling (HPA)
\`\`\`bash
kubectl get hpa -n ${NAMESPACE}
kubectl describe hpa ${APP_NAME}-hpa -n ${NAMESPACE}
\`\`\`

EOF
    fi

    cat >> k8s/README.md << EOF
## Updates and Rollbacks

### Update Image
\`\`\`bash
kubectl set image deployment/${APP_NAME} ${APP_NAME}=${IMAGE_NAME}:new-tag -n ${NAMESPACE}
\`\`\`

### Check Rollout Status
\`\`\`bash
kubectl rollout status deployment/${APP_NAME} -n ${NAMESPACE}
\`\`\`

### Rollout History
\`\`\`bash
kubectl rollout history deployment/${APP_NAME} -n ${NAMESPACE}
\`\`\`

### Rollback
\`\`\`bash
kubectl rollout undo deployment/${APP_NAME} -n ${NAMESPACE}
# Or to specific revision
kubectl rollout undo deployment/${APP_NAME} --to-revision=2 -n ${NAMESPACE}
\`\`\`

## Monitoring

### Resource Usage
\`\`\`bash
kubectl top pods -n ${NAMESPACE}
kubectl top nodes
\`\`\`

### Watch Pods
\`\`\`bash
kubectl get pods -n ${NAMESPACE} -w
\`\`\`

## Troubleshooting

### Pod Not Starting
\`\`\`bash
# Check pod status
kubectl get pods -n ${NAMESPACE}

# Describe pod for events
kubectl describe pod <pod-name> -n ${NAMESPACE}

# Check logs
kubectl logs <pod-name> -n ${NAMESPACE}

# Previous logs (if pod restarted)
kubectl logs <pod-name> -n ${NAMESPACE} --previous
\`\`\`

### Service Not Accessible
\`\`\`bash
# Check service
kubectl get svc ${APP_NAME}-service -n ${NAMESPACE}

# Check endpoints
kubectl get endpoints ${APP_NAME}-service -n ${NAMESPACE}

# Test from another pod
kubectl run test --image=busybox -it --rm -- wget -qO- http://${APP_NAME}-service
\`\`\`

### Ingress Issues
\`\`\`bash
# Check ingress
kubectl describe ingress ${APP_NAME}-ingress -n ${NAMESPACE}

# Check ingress controller logs
kubectl logs -n ingress-nginx deployment/ingress-nginx-controller
\`\`\`

## Cleanup

### Delete Application
\`\`\`bash
kubectl delete -f k8s/
\`\`\`

### Delete Namespace (removes everything)
\`\`\`bash
kubectl delete namespace ${NAMESPACE}
\`\`\`

## Production Best Practices

### Security
- [ ] Update all default passwords in secrets
- [ ] Enable RBAC and principle of least privilege
- [ ] Use NetworkPolicies to restrict traffic
- [ ] Scan images for vulnerabilities
- [ ] Use private container registries
- [ ] Enable Pod Security Standards

### Reliability
- [ ] Set appropriate resource requests and limits
- [ ] Configure health checks (liveness, readiness, startup)
- [ ] Use PodDisruptionBudgets for high availability
- [ ] Configure anti-affinity rules
- [ ] Enable HPA for automatic scaling
- [ ] Set up proper monitoring and alerting

### Performance
- [ ] Optimize resource allocation
- [ ] Use appropriate storage classes
- [ ] Configure caching where applicable
- [ ] Implement CDN for static content
- [ ] Use connection pooling for databases

### Observability
- [ ] Centralized logging (ELK, Loki, etc.)
- [ ] Metrics collection (Prometheus)
- [ ] Distributed tracing (Jaeger, Tempo)
- [ ] Application Performance Monitoring (APM)

## Additional Resources

- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
- [Production Best Practices](https://kubernetes.io/docs/concepts/configuration/overview/)

## Support

For issues or questions:
1. Check pod logs: \`kubectl logs <pod-name> -n ${NAMESPACE}\`
2. Check events: \`kubectl get events -n ${NAMESPACE}\`
3. Describe resources: \`kubectl describe <resource> <name> -n ${NAMESPACE}\`
EOF

    print_success "README.md created with comprehensive deployment guide"
}

# ============================================================================
# KUSTOMIZATION GENERATOR
# ============================================================================
generate_kustomization() {
    cat > k8s/kustomization.yaml << EOF
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

namespace: ${NAMESPACE}

resources:
EOF

    if [[ "$NAMESPACE" != "default" ]]; then
        echo "- 00-namespace.yaml" >> k8s/kustomization.yaml
    fi

    cat >> k8s/kustomization.yaml << EOF
- 01-configmap.yaml
- 02-secret.yaml
- 03-deployment.yaml
EOF

    if [[ "$APP_TYPE" != "cronjob" ]]; then
        echo "- 04-service.yaml" >> k8s/kustomization.yaml
    fi

    if [ "$ENABLE_INGRESS" = true ]; then
        echo "- 05-ingress.yaml" >> k8s/kustomization.yaml
    fi

    if [ "$ENABLE_HPA" = true ]; then
        echo "- 06-hpa.yaml" >> k8s/kustomization.yaml
    fi

    if [ "$ENABLE_PVC" = true ]; then
        echo "- 07-pvc.yaml" >> k8s/kustomization.yaml
    fi

    if [ "$ENABLE_RBAC" = true ]; then
        echo "- 08-rbac.yaml" >> k8s/kustomization.yaml
    fi

    if [[ "$APP_TYPE" != "cronjob" && "$REPLICAS" -gt 1 ]]; then
        echo "- 09-pdb.yaml" >> k8s/kustomization.yaml
    fi

    echo "- 10-network-policy.yaml" >> k8s/kustomization.yaml

    if [[ "$DATABASE_TYPE" != "none" ]]; then
        echo "- 11-${DATABASE_TYPE}.yaml" >> k8s/kustomization.yaml
    fi

    if [[ "$APP_TYPE" == "cronjob" ]]; then
        echo "- 12-cronjob.yaml" >> k8s/kustomization.yaml
    fi

    cat >> k8s/kustomization.yaml << EOF

commonLabels:
  app: ${APP_NAME}
  managed-by: kustomize

images:
- name: ${IMAGE_NAME}
  newTag: ${IMAGE_TAG}
EOF

    print_success "kustomization.yaml created"
}

# ============================================================================
# MAIN ORCHESTRATION
# ============================================================================
main() {
    display_header
    
    print_info "Starting Kubernetes manifest generation..."
    echo ""
    
    # Collect all configurations
    collect_basic_info
    select_app_type
    collect_service_config
    collect_ingress_config
    collect_scaling_config
    collect_storage_config
    collect_database_config
    collect_resource_config
    collect_additional_options
    
    echo ""
    print_info "Generating Kubernetes manifests..."
    echo ""
    
    # Create k8s directory
    mkdir -p k8s
    
    # Generate all manifests
    generate_namespace
    generate_configmap
    generate_secret
    
    if [[ "$APP_TYPE" == "cronjob" ]]; then
        generate_cronjob
    else
        generate_deployment
    fi
    
    generate_service
    generate_ingress
    generate_hpa
    generate_pvc
    generate_rbac
    generate_pdb
    generate_network_policy
    generate_database
    generate_kustomization
    generate_readme
    
    echo ""
    print_success "============================================================"
    print_success "   Kubernetes Manifests Generated Successfully!            "
    print_success "============================================================"
    echo ""
    
    print_info "Generated manifests in k8s/ directory:"
    ls -1 k8s/ | sed 's/^/  ✓ /'
    
    echo ""
    print_warning "IMPORTANT: Before deploying to production:"
    echo "  1. Update secret values in k8s/02-secret.yaml"
    echo "  2. Review resource limits in k8s/03-deployment.yaml"
    echo "  3. Configure proper ingress hostname and TLS"
    if [[ "$DATABASE_TYPE" != "none" ]]; then
        echo "  4. Update database credentials in k8s/11-${DATABASE_TYPE}.yaml"
    fi
    echo ""
    
    print_info "Quick deployment command:"
    echo "  kubectl apply -f k8s/"
    echo ""
    print_info "For detailed instructions, see: k8s/README.md"
    echo ""
    
    print_success "Done! Review the generated files and deploy when ready."
}

# Run main function
main
