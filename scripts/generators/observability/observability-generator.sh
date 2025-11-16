#!/bin/bash

# Monitoring & Observability Stack Generator
# Generates complete observability infrastructure
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
STACK_TYPE=""
DEPLOYMENT_METHOD=""
NAMESPACE="monitoring"
ENABLE_PROMETHEUS=false
ENABLE_GRAFANA=false
ENABLE_LOGGING=false
LOGGING_STACK="elk"
ENABLE_TRACING=false
TRACING_STACK="jaeger"
ENABLE_ALERTMANAGER=false
ENABLE_LOKI=false
STORAGE_SIZE="50Gi"
RETENTION_DAYS=30

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
    echo "   Monitoring & Observability Stack Generator              "
    echo "   Complete Observability Infrastructure                   "
    echo "============================================================"
    echo ""
}

# Function to select stack components
select_stack_components() {
    print_header "=== Select Observability Components ==="
    echo ""
    echo "What would you like to deploy?"
    echo "1) Complete Stack (Metrics + Logs + Traces)"
    echo "2) Metrics Only (Prometheus + Grafana)"
    echo "3) Logging Only (ELK/EFK/Loki)"
    echo "4) Tracing Only (Jaeger/Tempo)"
    echo "5) Custom (Choose components)"
    read -p "Enter choice (1-5): " stack_choice
    
    case $stack_choice in
        1)
            STACK_TYPE="complete"
            ENABLE_PROMETHEUS=true
            ENABLE_GRAFANA=true
            ENABLE_LOGGING=true
            ENABLE_TRACING=true
            ENABLE_ALERTMANAGER=true
            ;;
        2)
            STACK_TYPE="metrics"
            ENABLE_PROMETHEUS=true
            ENABLE_GRAFANA=true
            ENABLE_ALERTMANAGER=true
            ;;
        3)
            STACK_TYPE="logging"
            ENABLE_LOGGING=true
            select_logging_stack
            ;;
        4)
            STACK_TYPE="tracing"
            ENABLE_TRACING=true
            select_tracing_stack
            ;;
        5)
            STACK_TYPE="custom"
            select_custom_components
            ;;
        *)
            print_error "Invalid choice"
            exit 1
            ;;
    esac
    
    print_success "Stack type: $STACK_TYPE"
}

# Function to select logging stack
select_logging_stack() {
    echo ""
    echo "Select Logging Stack:"
    echo "1) ELK (Elasticsearch, Logstash, Kibana)"
    echo "2) EFK (Elasticsearch, Fluentd, Kibana)"
    echo "3) Loki (Grafana Loki)"
    read -p "Enter choice (1-3, default: 3): " log_choice
    
    case ${log_choice:-3} in
        1) LOGGING_STACK="elk" ;;
        2) LOGGING_STACK="efk" ;;
        3) LOGGING_STACK="loki"; ENABLE_LOKI=true ;;
        *) LOGGING_STACK="loki"; ENABLE_LOKI=true ;;
    esac
}

# Function to select tracing stack
select_tracing_stack() {
    echo ""
    echo "Select Tracing Stack:"
    echo "1) Jaeger"
    echo "2) Tempo"
    read -p "Enter choice (1-2, default: 1): " trace_choice
    
    case ${trace_choice:-1} in
        1) TRACING_STACK="jaeger" ;;
        2) TRACING_STACK="tempo" ;;
        *) TRACING_STACK="jaeger" ;;
    esac
}

# Function to select custom components
select_custom_components() {
    echo ""
    read -p "Enable Prometheus? (y/n): " prom
    ENABLE_PROMETHEUS=$([[ $prom == "y" || $prom == "Y" ]] && echo true || echo false)
    
    if [ "$ENABLE_PROMETHEUS" = true ]; then
        read -p "Enable AlertManager? (y/n): " alert
        ENABLE_ALERTMANAGER=$([[ $alert == "y" || $alert == "Y" ]] && echo true || echo false)
    fi
    
    read -p "Enable Grafana? (y/n): " graf
    ENABLE_GRAFANA=$([[ $graf == "y" || $graf == "Y" ]] && echo true || echo false)
    
    read -p "Enable Logging? (y/n): " log
    ENABLE_LOGGING=$([[ $log == "y" || $log == "Y" ]] && echo true || echo false)
    
    if [ "$ENABLE_LOGGING" = true ]; then
        select_logging_stack
    fi
    
    read -p "Enable Tracing? (y/n): " trace
    ENABLE_TRACING=$([[ $trace == "y" || $trace == "Y" ]] && echo true || echo false)
    
    if [ "$ENABLE_TRACING" = true ]; then
        select_tracing_stack
    fi
}

# Function to select deployment method
select_deployment_method() {
    echo ""
    print_header "=== Deployment Method ==="
    echo "1) Helm (Recommended)"
    echo "2) Kubernetes Manifests"
    echo "3) Docker Compose"
    read -p "Enter choice (1-3, default: 1): " deploy_choice
    
    case ${deploy_choice:-1} in
        1) DEPLOYMENT_METHOD="helm" ;;
        2) DEPLOYMENT_METHOD="k8s" ;;
        3) DEPLOYMENT_METHOD="docker-compose" ;;
        *) DEPLOYMENT_METHOD="helm" ;;
    esac
}

# Function to collect configuration
collect_configuration() {
    echo ""
    print_header "=== Configuration ==="
    
    read -p "Namespace (default: monitoring): " ns
    NAMESPACE=${ns:-monitoring}
    
    read -p "Storage size (default: 50Gi): " storage
    STORAGE_SIZE=${storage:-50Gi}
    
    read -p "Retention days (default: 30): " retention
    RETENTION_DAYS=${retention:-30}
    
    print_success "Configuration collected"
}

# ============================================================================
# DIRECTORY STRUCTURE
# ============================================================================
create_directory_structure() {
    mkdir -p observability/{helm,k8s,docker-compose,dashboards,alerts,configs}
    mkdir -p observability/dashboards/{prometheus,grafana,kibana}
    mkdir -p observability/alerts/{prometheus,elastalert}
    
    if [ "$ENABLE_PROMETHEUS" = true ]; then
        mkdir -p observability/k8s/prometheus
        mkdir -p observability/configs/prometheus
    fi
    
    if [ "$ENABLE_GRAFANA" = true ]; then
        mkdir -p observability/k8s/grafana
        mkdir -p observability/configs/grafana
    fi
    
    if [ "$ENABLE_LOGGING" = true ]; then
        mkdir -p observability/k8s/${LOGGING_STACK}
        mkdir -p observability/configs/${LOGGING_STACK}
    fi
    
    if [ "$ENABLE_TRACING" = true ]; then
        mkdir -p observability/k8s/${TRACING_STACK}
        mkdir -p observability/configs/${TRACING_STACK}
    fi
}

# ============================================================================
# PROMETHEUS CONFIGURATION
# ============================================================================
generate_prometheus_config() {
    cat > observability/configs/prometheus/prometheus.yml << 'EOF'
# Prometheus Configuration
global:
  scrape_interval: 15s
  scrape_timeout: 10s
  evaluation_interval: 15s
  external_labels:
    cluster: 'production'
    region: 'us-east-1'

# Alertmanager configuration
alerting:
  alertmanagers:
    - static_configs:
        - targets:
            - alertmanager:9093

# Load rules once and periodically evaluate them
rule_files:
  - "/etc/prometheus/rules/*.yml"

# Scrape configurations
scrape_configs:
  # Prometheus itself
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  # Kubernetes API server
  - job_name: 'kubernetes-apiservers'
    kubernetes_sd_configs:
      - role: endpoints
    scheme: https
    tls_config:
      ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
    bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
    relabel_configs:
      - source_labels: [__meta_kubernetes_namespace, __meta_kubernetes_service_name, __meta_kubernetes_endpoint_port_name]
        action: keep
        regex: default;kubernetes;https

  # Kubernetes nodes
  - job_name: 'kubernetes-nodes'
    kubernetes_sd_configs:
      - role: node
    scheme: https
    tls_config:
      ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
    bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
    relabel_configs:
      - action: labelmap
        regex: __meta_kubernetes_node_label_(.+)

  # Kubernetes pods
  - job_name: 'kubernetes-pods'
    kubernetes_sd_configs:
      - role: pod
    relabel_configs:
      - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scrape]
        action: keep
        regex: true
      - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_path]
        action: replace
        target_label: __metrics_path__
        regex: (.+)
      - source_labels: [__address__, __meta_kubernetes_pod_annotation_prometheus_io_port]
        action: replace
        regex: ([^:]+)(?::\d+)?;(\d+)
        replacement: $1:$2
        target_label: __address__
      - action: labelmap
        regex: __meta_kubernetes_pod_label_(.+)
      - source_labels: [__meta_kubernetes_namespace]
        action: replace
        target_label: kubernetes_namespace
      - source_labels: [__meta_kubernetes_pod_name]
        action: replace
        target_label: kubernetes_pod_name

  # Kubernetes services
  - job_name: 'kubernetes-services'
    kubernetes_sd_configs:
      - role: service
    metrics_path: /probe
    params:
      module: [http_2xx]
    relabel_configs:
      - source_labels: [__meta_kubernetes_service_annotation_prometheus_io_probe]
        action: keep
        regex: true
      - source_labels: [__address__]
        target_label: __param_target
      - target_label: __address__
        replacement: blackbox-exporter:9115
      - source_labels: [__param_target]
        target_label: instance
      - action: labelmap
        regex: __meta_kubernetes_service_label_(.+)
      - source_labels: [__meta_kubernetes_namespace]
        target_label: kubernetes_namespace
      - source_labels: [__meta_kubernetes_service_name]
        target_label: kubernetes_name

  # Node Exporter
  - job_name: 'node-exporter'
    kubernetes_sd_configs:
      - role: endpoints
    relabel_configs:
      - source_labels: [__meta_kubernetes_endpoints_name]
        regex: 'node-exporter'
        action: keep

  # Kube State Metrics
  - job_name: 'kube-state-metrics'
    static_configs:
      - targets: ['kube-state-metrics:8080']

  # cAdvisor
  - job_name: 'kubernetes-cadvisor'
    kubernetes_sd_configs:
      - role: node
    scheme: https
    tls_config:
      ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
    bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
    relabel_configs:
      - action: labelmap
        regex: __meta_kubernetes_node_label_(.+)
      - target_label: __address__
        replacement: kubernetes.default.svc:443
      - source_labels: [__meta_kubernetes_node_name]
        regex: (.+)
        target_label: __metrics_path__
        replacement: /api/v1/nodes/${1}/proxy/metrics/cadvisor
EOF

    print_success "Prometheus config created"
}

# ============================================================================
# PROMETHEUS ALERT RULES
# ============================================================================
generate_prometheus_alerts() {
    # General alerts
    cat > observability/alerts/prometheus/general-rules.yml << 'EOF'
groups:
  - name: general
    interval: 30s
    rules:
      - alert: InstanceDown
        expr: up == 0
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "Instance {{ $labels.instance }} down"
          description: "{{ $labels.instance }} of job {{ $labels.job }} has been down for more than 5 minutes."

      - alert: HighCPUUsage
        expr: 100 - (avg by (instance) (irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100) > 80
        for: 10m
        labels:
          severity: warning
        annotations:
          summary: "High CPU usage on {{ $labels.instance }}"
          description: "CPU usage is above 80% (current value: {{ $value }}%)"

      - alert: HighMemoryUsage
        expr: (1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100 > 85
        for: 10m
        labels:
          severity: warning
        annotations:
          summary: "High memory usage on {{ $labels.instance }}"
          description: "Memory usage is above 85% (current value: {{ $value }}%)"

      - alert: DiskSpaceLow
        expr: (node_filesystem_avail_bytes / node_filesystem_size_bytes) * 100 < 15
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "Disk space low on {{ $labels.instance }}"
          description: "Disk space is below 15% (current value: {{ $value }}%)"

      - alert: DiskSpaceCritical
        expr: (node_filesystem_avail_bytes / node_filesystem_size_bytes) * 100 < 10
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "Disk space critical on {{ $labels.instance }}"
          description: "Disk space is below 10% (current value: {{ $value }}%)"
EOF

    # Kubernetes alerts
    cat > observability/alerts/prometheus/kubernetes-rules.yml << 'EOF'
groups:
  - name: kubernetes
    interval: 30s
    rules:
      - alert: KubernetesPodCrashLooping
        expr: rate(kube_pod_container_status_restarts_total[15m]) > 0
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "Pod {{ $labels.namespace }}/{{ $labels.pod }} is crash looping"
          description: "Pod {{ $labels.namespace }}/{{ $labels.pod }} is restarting frequently"

      - alert: KubernetesPodNotReady
        expr: sum by (namespace, pod) (kube_pod_status_phase{phase=~"Pending|Unknown|Failed"}) > 0
        for: 15m
        labels:
          severity: warning
        annotations:
          summary: "Pod {{ $labels.namespace }}/{{ $labels.pod }} not ready"
          description: "Pod has been in a non-ready state for more than 15 minutes"

      - alert: KubernetesDeploymentReplicasMismatch
        expr: kube_deployment_spec_replicas != kube_deployment_status_replicas_available
        for: 10m
        labels:
          severity: warning
        annotations:
          summary: "Deployment {{ $labels.namespace }}/{{ $labels.deployment }} replicas mismatch"
          description: "Deployment replicas do not match the desired count"

      - alert: KubernetesStatefulSetReplicasMismatch
        expr: kube_statefulset_status_replicas_ready != kube_statefulset_status_replicas
        for: 10m
        labels:
          severity: warning
        annotations:
          summary: "StatefulSet {{ $labels.namespace }}/{{ $labels.statefulset }} replicas mismatch"
          description: "StatefulSet replicas do not match the desired count"

      - alert: KubernetesNodeNotReady
        expr: kube_node_status_condition{condition="Ready",status="true"} == 0
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "Node {{ $labels.node }} not ready"
          description: "Node has been unready for more than 5 minutes"

      - alert: KubernetesNodeMemoryPressure
        expr: kube_node_status_condition{condition="MemoryPressure",status="true"} == 1
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "Node {{ $labels.node }} under memory pressure"
          description: "Node is experiencing memory pressure"

      - alert: KubernetesNodeDiskPressure
        expr: kube_node_status_condition{condition="DiskPressure",status="true"} == 1
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "Node {{ $labels.node }} under disk pressure"
          description: "Node is experiencing disk pressure"

      - alert: KubernetesPersistentVolumeFillingUp
        expr: kubelet_volume_stats_available_bytes / kubelet_volume_stats_capacity_bytes * 100 < 15
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "PV {{ $labels.persistentvolumeclaim }} filling up"
          description: "PV is {{ $value }}% full"
EOF

    # Application alerts
    cat > observability/alerts/prometheus/application-rules.yml << 'EOF'
groups:
  - name: application
    interval: 30s
    rules:
      - alert: HighErrorRate
        expr: rate(http_requests_total{status=~"5.."}[5m]) > 0.05
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "High error rate in {{ $labels.job }}"
          description: "Error rate is above 5% (current value: {{ $value }})"

      - alert: HighLatency
        expr: histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m])) > 1
        for: 10m
        labels:
          severity: warning
        annotations:
          summary: "High latency in {{ $labels.job }}"
          description: "95th percentile latency is above 1s (current value: {{ $value }}s)"

      - alert: APIHighLatency
        expr: histogram_quantile(0.99, rate(http_request_duration_seconds_bucket[5m])) > 2
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "API high latency in {{ $labels.job }}"
          description: "99th percentile latency is above 2s (current value: {{ $value }}s)"

      - alert: HighRequestRate
        expr: rate(http_requests_total[5m]) > 1000
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High request rate in {{ $labels.job }}"
          description: "Request rate is unusually high (current value: {{ $value }} req/s)"
EOF

    print_success "Prometheus alert rules created"
}

# ============================================================================
# ALERTMANAGER CONFIGURATION
# ============================================================================
generate_alertmanager_config() {
    cat > observability/configs/prometheus/alertmanager.yml << 'EOF'
# AlertManager Configuration
global:
  resolve_timeout: 5m
  slack_api_url: 'https://hooks.slack.com/services/YOUR/SLACK/WEBHOOK'
  pagerduty_url: 'https://events.pagerduty.com/v2/enqueue'

# Templates
templates:
  - '/etc/alertmanager/templates/*.tmpl'

# Route configuration
route:
  group_by: ['alertname', 'cluster', 'service']
  group_wait: 10s
  group_interval: 10s
  repeat_interval: 12h
  receiver: 'default'
  
  routes:
    - match:
        severity: critical
      receiver: 'pagerduty'
      continue: true
    
    - match:
        severity: critical
      receiver: 'slack-critical'
      continue: true
    
    - match:
        severity: warning
      receiver: 'slack-warning'
    
    - match_re:
        alertname: ^(InstanceDown|KubernetesPodCrashLooping)$
      receiver: 'pagerduty'
      continue: true

# Inhibition rules
inhibit_rules:
  - source_match:
      severity: 'critical'
    target_match:
      severity: 'warning'
    equal: ['alertname', 'cluster', 'service']

# Receivers
receivers:
  - name: 'default'
    email_configs:
      - to: 'team@example.com'
        from: 'alertmanager@example.com'
        smarthost: 'smtp.gmail.com:587'
        auth_username: 'alerts@example.com'
        auth_password: 'your-password'
        headers:
          Subject: '{{ .GroupLabels.alertname }} - {{ .Status }}'

  - name: 'slack-critical'
    slack_configs:
      - channel: '#alerts-critical'
        title: '{{ .GroupLabels.alertname }}'
        text: '{{ range .Alerts }}{{ .Annotations.description }}{{ end }}'
        color: 'danger'
        send_resolved: true

  - name: 'slack-warning'
    slack_configs:
      - channel: '#alerts-warning'
        title: '{{ .GroupLabels.alertname }}'
        text: '{{ range .Alerts }}{{ .Annotations.description }}{{ end }}'
        color: 'warning'
        send_resolved: true

  - name: 'pagerduty'
    pagerduty_configs:
      - service_key: 'YOUR_PAGERDUTY_SERVICE_KEY'
        description: '{{ .GroupLabels.alertname }}'
EOF

    print_success "AlertManager config created"
}

# ============================================================================
# GRAFANA DASHBOARDS
# ============================================================================
generate_grafana_dashboards() {
    # Kubernetes Cluster Dashboard
    cat > observability/dashboards/grafana/kubernetes-cluster.json << 'EOF'
{
  "dashboard": {
    "title": "Kubernetes Cluster Overview",
    "tags": ["kubernetes", "cluster"],
    "timezone": "browser",
    "panels": [
      {
        "title": "Cluster CPU Usage",
        "type": "graph",
        "targets": [
          {
            "expr": "sum(rate(container_cpu_usage_seconds_total[5m])) by (node)",
            "legendFormat": "{{node}}"
          }
        ]
      },
      {
        "title": "Cluster Memory Usage",
        "type": "graph",
        "targets": [
          {
            "expr": "sum(container_memory_usage_bytes) by (node)",
            "legendFormat": "{{node}}"
          }
        ]
      },
      {
        "title": "Pod Count",
        "type": "stat",
        "targets": [
          {
            "expr": "count(kube_pod_info)"
          }
        ]
      },
      {
        "title": "Node Count",
        "type": "stat",
        "targets": [
          {
            "expr": "count(kube_node_info)"
          }
        ]
      }
    ]
  }
}
EOF

    # Application Performance Dashboard
    cat > observability/dashboards/grafana/application-performance.json << 'EOF'
{
  "dashboard": {
    "title": "Application Performance",
    "tags": ["application", "performance"],
    "panels": [
      {
        "title": "Request Rate",
        "type": "graph",
        "targets": [
          {
            "expr": "rate(http_requests_total[5m])",
            "legendFormat": "{{job}}"
          }
        ]
      },
      {
        "title": "Error Rate",
        "type": "graph",
        "targets": [
          {
            "expr": "rate(http_requests_total{status=~\"5..\"}[5m])",
            "legendFormat": "{{job}} - {{status}}"
          }
        ]
      },
      {
        "title": "Latency (p95)",
        "type": "graph",
        "targets": [
          {
            "expr": "histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))",
            "legendFormat": "{{job}}"
          }
        ]
      },
      {
        "title": "Latency (p99)",
        "type": "graph",
        "targets": [
          {
            "expr": "histogram_quantile(0.99, rate(http_request_duration_seconds_bucket[5m]))",
            "legendFormat": "{{job}}"
          }
        ]
      }
    ]
  }
}
EOF

    # Node Exporter Dashboard
    cat > observability/dashboards/grafana/node-exporter.json << 'EOF'
{
  "dashboard": {
    "title": "Node Exporter Full",
    "tags": ["node-exporter", "infrastructure"],
    "panels": [
      {
        "title": "CPU Usage",
        "type": "graph",
        "targets": [
          {
            "expr": "100 - (avg by (instance) (irate(node_cpu_seconds_total{mode=\"idle\"}[5m])) * 100)",
            "legendFormat": "{{instance}}"
          }
        ]
      },
      {
        "title": "Memory Usage",
        "type": "graph",
        "targets": [
          {
            "expr": "(1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100",
            "legendFormat": "{{instance}}"
          }
        ]
      },
      {
        "title": "Disk I/O",
        "type": "graph",
        "targets": [
          {
            "expr": "rate(node_disk_read_bytes_total[5m])",
            "legendFormat": "{{instance}} read"
          },
          {
            "expr": "rate(node_disk_written_bytes_total[5m])",
            "legendFormat": "{{instance}} write"
          }
        ]
      },
      {
        "title": "Network Traffic",
        "type": "graph",
        "targets": [
          {
            "expr": "rate(node_network_receive_bytes_total[5m])",
            "legendFormat": "{{instance}} receive"
          },
          {
            "expr": "rate(node_network_transmit_bytes_total[5m])",
            "legendFormat": "{{instance}} transmit"
          }
        ]
      }
    ]
  }
}
EOF

    print_success "Grafana dashboards created"
}

# ============================================================================
# GRAFANA DATASOURCES
# ============================================================================
generate_grafana_datasources() {
    cat > observability/configs/grafana/datasources.yml << 'EOF'
apiVersion: 1

datasources:
  - name: Prometheus
    type: prometheus
    access: proxy
    url: http://prometheus:9090
    isDefault: true
    editable: true
    jsonData:
      timeInterval: 15s

  - name: Loki
    type: loki
    access: proxy
    url: http://loki:3100
    editable: true

  - name: Jaeger
    type: jaeger
    access: proxy
    url: http://jaeger-query:16686
    editable: true

  - name: Tempo
    type: tempo
    access: proxy
    url: http://tempo:3200
    editable: true

  - name: Elasticsearch
    type: elasticsearch
    access: proxy
    url: http://elasticsearch:9200
    database: "[logs-]YYYY.MM.DD"
    jsonData:
      interval: Daily
      timeField: "@timestamp"
      esVersion: "7.10.0"
      logMessageField: message
      logLevelField: level
EOF

    print_success "Grafana datasources created"
}

# ============================================================================
# LOKI CONFIGURATION
# ============================================================================
generate_loki_config() {
    cat > observability/configs/loki/loki.yaml << EOF
auth_enabled: false

server:
  http_listen_port: 3100
  grpc_listen_port: 9096

common:
  path_prefix: /loki
  storage:
    filesystem:
      chunks_directory: /loki/chunks
      rules_directory: /loki/rules
  replication_factor: 1
  ring:
    kvstore:
      store: inmemory

schema_config:
  configs:
    - from: 2020-10-24
      store: boltdb-shipper
      object_store: filesystem
      schema: v11
      index:
        prefix: index_
        period: 24h

ruler:
  alertmanager_url: http://alertmanager:9093

# Retention
limits_config:
  retention_period: ${RETENTION_DAYS}d
  ingestion_rate_mb: 10
  ingestion_burst_size_mb: 20

chunk_store_config:
  max_look_back_period: ${RETENTION_DAYS}d

table_manager:
  retention_deletes_enabled: true
  retention_period: ${RETENTION_DAYS}d
EOF

    print_success "Loki config created"
}

# ============================================================================
# PROMTAIL CONFIGURATION
# ============================================================================
generate_promtail_config() {
    cat > observability/configs/loki/promtail.yaml << 'EOF'
server:
  http_listen_port: 9080
  grpc_listen_port: 0

positions:
  filename: /tmp/positions.yaml

clients:
  - url: http://loki:3100/loki/api/v1/push

scrape_configs:
  - job_name: kubernetes-pods
    kubernetes_sd_configs:
      - role: pod
    relabel_configs:
      - source_labels:
          - __meta_kubernetes_pod_label_app
        target_label: app
      - source_labels:
          - __meta_kubernetes_pod_label_component
        target_label: component
      - source_labels:
          - __meta_kubernetes_namespace
        target_label: namespace
      - source_labels:
          - __meta_kubernetes_pod_name
        target_label: pod
      - source_labels:
          - __meta_kubernetes_pod_container_name
        target_label: container
      - replacement: /var/log/pods/*$1/*.log
        separator: /
        source_labels:
          - __meta_kubernetes_pod_uid
          - __meta_kubernetes_pod_container_name
        target_label: __path__
EOF

    print_success "Promtail config created"
}

# ============================================================================
# JAEGER CONFIGURATION
# ============================================================================
generate_jaeger_config() {
    cat > observability/configs/jaeger/jaeger.yaml << 'EOF'
apiVersion: v1
kind: ConfigMap
metadata:
  name: jaeger-configuration
data:
  collector: |
    collector:
      zipkin:
        http-port: 9411
    es:
      server-urls: http://elasticsearch:9200
      num-shards: 3
      num-replicas: 1
  
  query: |
    es:
      server-urls: http://elasticsearch:9200
      max-span-age: 72h
  
  agent: |
    reporter:
      type: grpc
      grpc:
        host-port: jaeger-collector:14250
EOF

    print_success "Jaeger config created"
}

# ============================================================================
# TEMPO CONFIGURATION
# ============================================================================
generate_tempo_config() {
    cat > observability/configs/tempo/tempo.yaml << 'EOF'
server:
  http_listen_port: 3200

distributor:
  receivers:
    jaeger:
      protocols:
        thrift_http:
          endpoint: 0.0.0.0:14268
        grpc:
          endpoint: 0.0.0.0:14250
    zipkin:
      endpoint: 0.0.0.0:9411
    otlp:
      protocols:
        http:
          endpoint: 0.0.0.0:4318
        grpc:
          endpoint: 0.0.0.0:4317

ingester:
  trace_idle_period: 10s
  max_block_bytes: 1_000_000
  max_block_duration: 5m

compactor:
  compaction:
    block_retention: 1h

storage:
  trace:
    backend: local
    local:
      path: /tmp/tempo/blocks
    wal:
      path: /tmp/tempo/wal
    pool:
      max_workers: 100
      queue_depth: 10000
EOF

    print_success "Tempo config created"
}

# ============================================================================
# HELM VALUES GENERATOR
# ============================================================================
generate_helm_values() {
    if [ "$ENABLE_PROMETHEUS" = true ]; then
        cat > observability/helm/prometheus-values.yaml << EOF
# Prometheus Helm Values
prometheus:
  prometheusSpec:
    retention: ${RETENTION_DAYS}d
    storageSpec:
      volumeClaimTemplate:
        spec:
          accessModes: ["ReadWriteOnce"]
          resources:
            requests:
              storage: ${STORAGE_SIZE}
    
    resources:
      requests:
        cpu: 500m
        memory: 2Gi
      limits:
        cpu: 2000m
        memory: 4Gi
    
    additionalScrapeConfigs:
      - job_name: 'application-metrics'
        kubernetes_sd_configs:
          - role: pod
        relabel_configs:
          - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scrape]
            action: keep
            regex: true

alertmanager:
  enabled: ${ENABLE_ALERTMANAGER}
  alertmanagerSpec:
    storage:
      volumeClaimTemplate:
        spec:
          accessModes: ["ReadWriteOnce"]
          resources:
            requests:
              storage: 10Gi

grafana:
  enabled: ${ENABLE_GRAFANA}
  adminPassword: "admin"
  persistence:
    enabled: true
    size: 10Gi
  
  datasources:
    datasources.yaml:
      apiVersion: 1
      datasources:
        - name: Prometheus
          type: prometheus
          url: http://prometheus-server
          isDefault: true

prometheus-node-exporter:
  enabled: true

kube-state-metrics:
  enabled: true
EOF
    fi

    if [ "$ENABLE_LOKI" = true ]; then
        cat > observability/helm/loki-values.yaml << EOF
# Loki Helm Values
loki:
  auth_enabled: false
  persistence:
    enabled: true
    size: ${STORAGE_SIZE}
  
  config:
    limits_config:
      retention_period: ${RETENTION_DAYS}d

promtail:
  enabled: true
  config:
    clients:
      - url: http://loki:3100/loki/api/v1/push
EOF
    fi

    if [ "$ENABLE_TRACING" = true ]; then
        if [ "$TRACING_STACK" = "jaeger" ]; then
            cat > observability/helm/jaeger-values.yaml << EOF
# Jaeger Helm Values
storage:
  type: elasticsearch
  
elasticsearch:
  enabled: true
  replicas: 1
  minimumMasterNodes: 1
  
collector:
  replicaCount: 1
  resources:
    limits:
      cpu: 1
      memory: 1Gi

query:
  replicaCount: 1
  
agent:
  enabled: true
EOF
        else
            cat > observability/helm/tempo-values.yaml << EOF
# Tempo Helm Values
tempo:
  retention: ${RETENTION_DAYS}d
  
  storage:
    trace:
      backend: local
  
  resources:
    limits:
      cpu: 1
      memory: 2Gi
    requests:
      cpu: 500m
      memory: 1Gi

persistence:
  enabled: true
  size: ${STORAGE_SIZE}
EOF
        fi
    fi

    print_success "Helm values created"
}

# ============================================================================
# KUBERNETES MANIFESTS GENERATOR
# ============================================================================
generate_k8s_manifests() {
    # Namespace
    cat > observability/k8s/namespace.yaml << EOF
apiVersion: v1
kind: Namespace
metadata:
  name: ${NAMESPACE}
  labels:
    name: ${NAMESPACE}
    purpose: monitoring
EOF

    if [ "$ENABLE_PROMETHEUS" = true ]; then
        generate_prometheus_k8s
    fi

    if [ "$ENABLE_GRAFANA" = true ]; then
        generate_grafana_k8s
    fi

    if [ "$ENABLE_LOKI" = true ]; then
        generate_loki_k8s
    fi

    print_success "Kubernetes manifests created"
}

generate_prometheus_k8s() {
    cat > observability/k8s/prometheus/deployment.yaml << EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: prometheus
  namespace: ${NAMESPACE}
spec:
  replicas: 1
  selector:
    matchLabels:
      app: prometheus
  template:
    metadata:
      labels:
        app: prometheus
    spec:
      serviceAccountName: prometheus
      containers:
      - name: prometheus
        image: prom/prometheus:latest
        args:
          - '--config.file=/etc/prometheus/prometheus.yml'
          - '--storage.tsdb.path=/prometheus'
          - '--storage.tsdb.retention.time=${RETENTION_DAYS}d'
        ports:
        - containerPort: 9090
        volumeMounts:
        - name: config
          mountPath: /etc/prometheus
        - name: storage
          mountPath: /prometheus
        resources:
          requests:
            cpu: 500m
            memory: 2Gi
          limits:
            cpu: 2000m
            memory: 4Gi
      volumes:
      - name: config
        configMap:
          name: prometheus-config
      - name: storage
        persistentVolumeClaim:
          claimName: prometheus-storage
---
apiVersion: v1
kind: Service
metadata:
  name: prometheus
  namespace: ${NAMESPACE}
spec:
  selector:
    app: prometheus
  ports:
  - port: 9090
    targetPort: 9090
  type: ClusterIP
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: prometheus-storage
  namespace: ${NAMESPACE}
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: ${STORAGE_SIZE}
EOF
}

generate_grafana_k8s() {
    cat > observability/k8s/grafana/deployment.yaml << EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: grafana
  namespace: ${NAMESPACE}
spec:
  replicas: 1
  selector:
    matchLabels:
      app: grafana
  template:
    metadata:
      labels:
        app: grafana
    spec:
      containers:
      - name: grafana
        image: grafana/grafana:latest
        ports:
        - containerPort: 3000
        env:
        - name: GF_SECURITY_ADMIN_PASSWORD
          value: "admin"
        volumeMounts:
        - name: storage
          mountPath: /var/lib/grafana
        - name: datasources
          mountPath: /etc/grafana/provisioning/datasources
        resources:
          requests:
            cpu: 250m
            memory: 512Mi
          limits:
            cpu: 500m
            memory: 1Gi
      volumes:
      - name: storage
        persistentVolumeClaim:
          claimName: grafana-storage
      - name: datasources
        configMap:
          name: grafana-datasources
---
apiVersion: v1
kind: Service
metadata:
  name: grafana
  namespace: ${NAMESPACE}
spec:
  selector:
    app: grafana
  ports:
  - port: 3000
    targetPort: 3000
  type: LoadBalancer
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: grafana-storage
  namespace: ${NAMESPACE}
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
EOF
}

generate_loki_k8s() {
    cat > observability/k8s/loki/statefulset.yaml << EOF
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: loki
  namespace: ${NAMESPACE}
spec:
  serviceName: loki
  replicas: 1
  selector:
    matchLabels:
      app: loki
  template:
    metadata:
      labels:
        app: loki
    spec:
      containers:
      - name: loki
        image: grafana/loki:latest
        args:
          - -config.file=/etc/loki/loki.yaml
        ports:
        - containerPort: 3100
          name: http
        volumeMounts:
        - name: config
          mountPath: /etc/loki
        - name: storage
          mountPath: /loki
        resources:
          requests:
            cpu: 200m
            memory: 512Mi
          limits:
            cpu: 1000m
            memory: 2Gi
      volumes:
      - name: config
        configMap:
          name: loki-config
  volumeClaimTemplates:
  - metadata:
      name: storage
    spec:
      accessModes: [ "ReadWriteOnce" ]
      resources:
        requests:
          storage: ${STORAGE_SIZE}
---
apiVersion: v1
kind: Service
metadata:
  name: loki
  namespace: ${NAMESPACE}
spec:
  selector:
    app: loki
  ports:
  - port: 3100
    targetPort: 3100
  clusterIP: None
EOF
}

# ============================================================================
# DOCKER COMPOSE GENERATOR
# ============================================================================
generate_docker_compose() {
    cat > observability/docker-compose/docker-compose.yml << EOF
version: '3.8'

services:
EOF

    if [ "$ENABLE_PROMETHEUS" = true ]; then
        cat >> observability/docker-compose/docker-compose.yml << 'EOF'
  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    ports:
      - "9090:9090"
    volumes:
      - ../configs/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml
      - ../alerts/prometheus:/etc/prometheus/rules
      - prometheus-data:/prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'
      - '--web.enable-lifecycle'
    restart: unless-stopped
    networks:
      - monitoring

EOF
    fi

    if [ "$ENABLE_ALERTMANAGER" = true ]; then
        cat >> observability/docker-compose/docker-compose.yml << 'EOF'
  alertmanager:
    image: prom/alertmanager:latest
    container_name: alertmanager
    ports:
      - "9093:9093"
    volumes:
      - ../configs/prometheus/alertmanager.yml:/etc/alertmanager/alertmanager.yml
      - alertmanager-data:/alertmanager
    command:
      - '--config.file=/etc/alertmanager/alertmanager.yml'
    restart: unless-stopped
    networks:
      - monitoring

EOF
    fi

    if [ "$ENABLE_GRAFANA" = true ]; then
        cat >> observability/docker-compose/docker-compose.yml << 'EOF'
  grafana:
    image: grafana/grafana:latest
    container_name: grafana
    ports:
      - "3000:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin
    volumes:
      - ../configs/grafana/datasources.yml:/etc/grafana/provisioning/datasources/datasources.yml
      - grafana-data:/var/lib/grafana
    restart: unless-stopped
    networks:
      - monitoring

EOF
    fi

    if [ "$ENABLE_LOKI" = true ]; then
        cat >> observability/docker-compose/docker-compose.yml << 'EOF'
  loki:
    image: grafana/loki:latest
    container_name: loki
    ports:
      - "3100:3100"
    volumes:
      - ../configs/loki/loki.yaml:/etc/loki/local-config.yaml
      - loki-data:/loki
    command: -config.file=/etc/loki/local-config.yaml
    restart: unless-stopped
    networks:
      - monitoring

  promtail:
    image: grafana/promtail:latest
    container_name: promtail
    volumes:
      - ../configs/loki/promtail.yaml:/etc/promtail/config.yml
      - /var/log:/var/log
    command: -config.file=/etc/promtail/config.yml
    restart: unless-stopped
    networks:
      - monitoring

EOF
    fi

    if [ "$ENABLE_TRACING" = true ] && [ "$TRACING_STACK" = "jaeger" ]; then
        cat >> observability/docker-compose/docker-compose.yml << 'EOF'
  jaeger:
    image: jaegertracing/all-in-one:latest
    container_name: jaeger
    ports:
      - "5775:5775/udp"
      - "6831:6831/udp"
      - "6832:6832/udp"
      - "5778:5778"
      - "16686:16686"
      - "14268:14268"
      - "14250:14250"
      - "9411:9411"
    environment:
      - COLLECTOR_ZIPKIN_HOST_PORT=:9411
    restart: unless-stopped
    networks:
      - monitoring

EOF
    fi

    cat >> observability/docker-compose/docker-compose.yml << 'EOF'
  node-exporter:
    image: prom/node-exporter:latest
    container_name: node-exporter
    ports:
      - "9100:9100"
    command:
      - '--path.rootfs=/host'
    volumes:
      - '/:/host:ro,rslave'
    restart: unless-stopped
    networks:
      - monitoring

  cadvisor:
    image: gcr.io/cadvisor/cadvisor:latest
    container_name: cadvisor
    ports:
      - "8080:8080"
    volumes:
      - /:/rootfs:ro
      - /var/run:/var/run:ro
      - /sys:/sys:ro
      - /var/lib/docker/:/var/lib/docker:ro
    restart: unless-stopped
    networks:
      - monitoring

volumes:
EOF

    if [ "$ENABLE_PROMETHEUS" = true ]; then
        echo "  prometheus-data:" >> observability/docker-compose/docker-compose.yml
    fi
    
    if [ "$ENABLE_ALERTMANAGER" = true ]; then
        echo "  alertmanager-data:" >> observability/docker-compose/docker-compose.yml
    fi
    
    if [ "$ENABLE_GRAFANA" = true ]; then
        echo "  grafana-data:" >> observability/docker-compose/docker-compose.yml
    fi
    
    if [ "$ENABLE_LOKI" = true ]; then
        echo "  loki-data:" >> observability/docker-compose/docker-compose.yml
    fi

    cat >> observability/docker-compose/docker-compose.yml << 'EOF'

networks:
  monitoring:
    driver: bridge
EOF

    print_success "Docker Compose configuration created"
}

# ============================================================================
# DEPLOYMENT SCRIPTS
# ============================================================================
generate_deployment_scripts() {
    # Helm deployment script
    cat > observability/deploy-helm.sh << 'EOF'
#!/bin/bash
set -e

NAMESPACE="monitoring"

echo "🚀 Deploying Observability Stack with Helm..."

# Create namespace
kubectl create namespace ${NAMESPACE} --dry-run=client -o yaml | kubectl apply -f -

# Add Helm repositories
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo add jaegertracing https://jaegertracing.github.io/helm-charts
helm repo update

EOF

    if [ "$ENABLE_PROMETHEUS" = true ]; then
        cat >> observability/deploy-helm.sh << 'EOF'
# Deploy Prometheus Stack
echo "📊 Installing Prometheus Stack..."
helm upgrade --install prometheus prometheus-community/kube-prometheus-stack \
  -n ${NAMESPACE} \
  -f helm/prometheus-values.yaml \
  --wait

EOF
    fi

    if [ "$ENABLE_LOKI" = true ]; then
        cat >> observability/deploy-helm.sh << 'EOF'
# Deploy Loki Stack
echo "📝 Installing Loki Stack..."
helm upgrade --install loki grafana/loki-stack \
  -n ${NAMESPACE} \
  -f helm/loki-values.yaml \
  --wait

EOF
    fi

    if [ "$ENABLE_TRACING" = true ]; then
        if [ "$TRACING_STACK" = "jaeger" ]; then
            cat >> observability/deploy-helm.sh << 'EOF'
# Deploy Jaeger
echo "🔍 Installing Jaeger..."
helm upgrade --install jaeger jaegertracing/jaeger \
  -n ${NAMESPACE} \
  -f helm/jaeger-values.yaml \
  --wait

EOF
        else
            cat >> observability/deploy-helm.sh << 'EOF'
# Deploy Tempo
echo "🔍 Installing Tempo..."
helm upgrade --install tempo grafana/tempo \
  -n ${NAMESPACE} \
  -f helm/tempo-values.yaml \
  --wait

EOF
        fi
    fi

    cat >> observability/deploy-helm.sh << 'EOF'
echo "✅ Deployment complete!"
echo ""
echo "Access URLs:"
EOF

    if [ "$ENABLE_PROMETHEUS" = true ]; then
        cat >> observability/deploy-helm.sh << 'EOF'
echo "  Prometheus: kubectl port-forward -n ${NAMESPACE} svc/prometheus-kube-prometheus-prometheus 9090:9090"
EOF
    fi

    if [ "$ENABLE_GRAFANA" = true ]; then
        cat >> observability/deploy-helm.sh << 'EOF'
echo "  Grafana: kubectl port-forward -n ${NAMESPACE} svc/prometheus-grafana 3000:80"
echo "  Grafana default credentials: admin/prom-operator"
EOF
    fi

    if [ "$ENABLE_TRACING" = true ]; then
        cat >> observability/deploy-helm.sh << 'EOF'
echo "  Jaeger: kubectl port-forward -n ${NAMESPACE} svc/jaeger-query 16686:16686"
EOF
    fi

    chmod +x observability/deploy-helm.sh

    # Kubernetes deployment script
    cat > observability/deploy-k8s.sh << EOF
#!/bin/bash
set -e

NAMESPACE="${NAMESPACE}"

echo "🚀 Deploying Observability Stack with Kubernetes manifests..."

# Create namespace
kubectl apply -f k8s/namespace.yaml

# Create ConfigMaps
kubectl create configmap prometheus-config \\
  --from-file=configs/prometheus/prometheus.yml \\
  -n \${NAMESPACE} --dry-run=client -o yaml | kubectl apply -f -

kubectl create configmap grafana-datasources \\
  --from-file=configs/grafana/datasources.yml \\
  -n \${NAMESPACE} --dry-run=client -o yaml | kubectl apply -f -

EOF

    if [ "$ENABLE_PROMETHEUS" = true ]; then
        cat >> observability/deploy-k8s.sh << 'EOF'
# Deploy Prometheus
echo "📊 Deploying Prometheus..."
kubectl apply -f k8s/prometheus/

EOF
    fi

    if [ "$ENABLE_GRAFANA" = true ]; then
        cat >> observability/deploy-k8s.sh << 'EOF'
# Deploy Grafana
echo "📊 Deploying Grafana..."
kubectl apply -f k8s/grafana/

EOF
    fi

    if [ "$ENABLE_LOKI" = true ]; then
        cat >> observability/deploy-k8s.sh << 'EOF'
# Deploy Loki
echo "📝 Deploying Loki..."
kubectl apply -f k8s/loki/

EOF
    fi

    cat >> observability/deploy-k8s.sh << 'EOF'
echo "✅ Deployment complete!"
echo ""
echo "Check status:"
echo "  kubectl get pods -n ${NAMESPACE}"
EOF

    chmod +x observability/deploy-k8s.sh

    # Docker Compose deployment script
    cat > observability/deploy-docker.sh << 'EOF'
#!/bin/bash
set -e

echo "🚀 Deploying Observability Stack with Docker Compose..."

cd docker-compose
docker-compose up -d

echo "✅ Deployment complete!"
echo ""
echo "Access URLs:"
echo "  Prometheus: http://localhost:9090"
echo "  Grafana: http://localhost:3000 (admin/admin)"
echo "  AlertManager: http://localhost:9093"
echo "  Jaeger: http://localhost:16686"
EOF

    chmod +x observability/deploy-docker.sh

    print_success "Deployment scripts created"
}

# ============================================================================
# README GENERATOR
# ============================================================================
generate_readme() {
    cat > observability/README.md << EOF
# Observability Stack

## Overview

Complete observability stack for monitoring, logging, and tracing.

### Components

EOF

    if [ "$ENABLE_PROMETHEUS" = true ]; then
        cat >> observability/README.md << 'EOF'
#### Prometheus
- **Purpose**: Metrics collection and alerting
- **Port**: 9090
- **Data Retention**: Configurable (default: 30 days)

EOF
    fi

    if [ "$ENABLE_GRAFANA" = true ]; then
        cat >> observability/README.md << 'EOF'
#### Grafana
- **Purpose**: Metrics visualization and dashboards
- **Port**: 3000
- **Default Credentials**: admin/admin

EOF
    fi

    if [ "$ENABLE_ALERTMANAGER" = true ]; then
        cat >> observability/README.md << 'EOF'
#### AlertManager
- **Purpose**: Alert routing and management
- **Port**: 9093

EOF
    fi

    if [ "$ENABLE_LOKI" = true ]; then
        cat >> observability/README.md << 'EOF'
#### Loki
- **Purpose**: Log aggregation
- **Port**: 3100

#### Promtail
- **Purpose**: Log collection agent
- **Port**: 9080

EOF
    fi

    if [ "$ENABLE_TRACING" = true ]; then
        cat >> observability/README.md << EOF
#### ${TRACING_STACK^}
- **Purpose**: Distributed tracing
- **Ports**: Multiple (see documentation)

EOF
    fi

    cat >> observability/README.md << 'EOF'
## Quick Start

### Helm Deployment (Recommended)

```bash
# Deploy everything
./deploy-helm.sh

# Or step by step
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

helm install prometheus prometheus-community/kube-prometheus-stack \
  -n monitoring \
  -f helm/prometheus-values.yaml
```

### Kubernetes Manifests

```bash
# Deploy with kubectl
./deploy-k8s.sh

# Or manually
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/prometheus/
kubectl apply -f k8s/grafana/
```

### Docker Compose

```bash
# Deploy locally
./deploy-docker.sh

# Or manually
cd docker-compose
docker-compose up -d
```

## Accessing Services

### Port Forwarding (Kubernetes)

```bash
# Prometheus
kubectl port-forward -n monitoring svc/prometheus 9090:9090

# Grafana
kubectl port-forward -n monitoring svc/grafana 3000:3000

# AlertManager
kubectl port-forward -n monitoring svc/alertmanager 9093:9093

# Loki
kubectl port-forward -n monitoring svc/loki 3100:3100

# Jaeger
kubectl port-forward -n monitoring svc/jaeger-query 16686:16686
```

### Direct Access (Docker Compose)

- Prometheus: http://localhost:9090
- Grafana: http://localhost:3000
- AlertManager: http://localhost:9093
- Loki: http://localhost:3100
- Jaeger: http://localhost:16686

## Configuration

### Prometheus

**Scrape Configs**: `configs/prometheus/prometheus.yml`
**Alert Rules**: `alerts/prometheus/*.yml`

Add custom scrape configs:

```yaml
scrape_configs:
  - job_name: 'my-app'
    static_configs:
      - targets: ['my-app:8080']
```

### Grafana

**Datasources**: `configs/grafana/datasources.yml`
**Dashboards**: `dashboards/grafana/*.json`

Import dashboards via UI or:

```bash
kubectl create configmap grafana-dashboards \
  --from-file=dashboards/grafana/ \
  -n monitoring
```

### AlertManager

**Configuration**: `configs/prometheus/alertmanager.yml`

Update notification channels:

```yaml
receivers:
  - name: 'slack'
    slack_configs:
      - api_url: 'YOUR_WEBHOOK_URL'
        channel: '#alerts'
```

### Loki

**Configuration**: `configs/loki/loki.yaml`
**Promtail**: `configs/loki/promtail.yaml`

## Dashboards

### Pre-configured Dashboards

1. **Kubernetes Cluster Overview**
   - Node metrics
   - Pod status
   - Resource usage

2. **Application Performance**
   - Request rate
   - Error rate
   - Latency (p95, p99)

3. **Node Exporter Full**
   - CPU, Memory, Disk
   - Network traffic
   - System metrics

### Importing Dashboards

```bash
# From Grafana.com
1. Go to Grafana UI
2. Click '+' > Import
3. Enter dashboard ID:
   - 315: Kubernetes Cluster Monitoring
   - 1860: Node Exporter Full
   - 12019: Kubernetes API Server

# From JSON files
kubectl create configmap grafana-dashboards \
  --from-file=dashboards/grafana/ \
  -n monitoring
```

## Alert Rules

### Available Alerts

**Infrastructure**:
- InstanceDown
- HighCPUUsage
- HighMemoryUsage
- DiskSpaceLow

**Kubernetes**:
- KubernetesPodCrashLooping
- KubernetesPodNotReady
- KubernetesNodeNotReady
- KubernetesDeploymentReplicasMismatch

**Application**:
- HighErrorRate
- HighLatency
- APIHighLatency

### Adding Custom Alerts

Create new alert file:

```yaml
# alerts/prometheus/custom-rules.yml
groups:
  - name: custom
    rules:
      - alert: MyCustomAlert
        expr: my_metric > 100
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "Custom alert triggered"
```

Apply:

```bash
kubectl create configmap prometheus-rules \
  --from-file=alerts/prometheus/ \
  -n monitoring
```

## Logging

### Query Logs with Loki

```bash
# Via LogCLI
logcli query '{namespace="default"}'

# Via Grafana Explore
1. Go to Grafana
2. Click Explore
3. Select Loki datasource
4. Enter query: {namespace="default"}
```

### Common Log Queries

```logql
# All logs from namespace
{namespace="production"}

# Logs with error level
{namespace="production"} |= "error"

# Logs from specific pod
{namespace="production", pod="my-app-xxxxx"}

# Rate of errors
rate({namespace="production"} |= "error" [5m])
```

## Tracing

### Instrument Your Application

**Java (OpenTelemetry)**:

```java
Tracer tracer = GlobalOpenTelemetry.getTracer("my-app");
Span span = tracer.spanBuilder("my-operation").startSpan();
try {
    // Your code
} finally {
    span.end();
}
```

**Node.js (OpenTelemetry)**:

```javascript
const { trace } = require('@opentelemetry/api');
const tracer = trace.getTracer('my-app');

const span = tracer.startSpan('my-operation');
// Your code
span.end();
```

**Python (OpenTelemetry)**:

```python
from opentelemetry import trace

tracer = trace.get_tracer(__name__)

with tracer.start_as_current_span("my-operation"):
    # Your code
    pass
```

## Monitoring Best Practices

1. **Set Up Alerts**
   - Configure critical alerts first
   - Set appropriate thresholds
   - Test alert routing

2. **Create Dashboards**
   - Start with overview dashboards
   - Add drill-down dashboards
   - Include SLI/SLO metrics

3. **Log Everything**
   - Structured logging
   - Include correlation IDs
   - Set log levels appropriately

4. **Instrument Code**
   - Add custom metrics
   - Implement distributed tracing
   - Track business metrics

5. **Regular Maintenance**
   - Review alert rules
   - Update dashboards
   - Check storage usage
   - Rotate logs

## Troubleshooting

### Prometheus Not Scraping Targets

```bash
# Check targets
kubectl port-forward -n monitoring svc/prometheus 9090:9090
# Visit http://localhost:9090/targets

# Check logs
kubectl logs -n monitoring deployment/prometheus
```

### Grafana Can't Connect to Datasources

```bash
# Check datasource config
kubectl get configmap grafana-datasources -n monitoring -o yaml

# Test connectivity
kubectl exec -it deployment/grafana -n monitoring -- curl http://prometheus:9090
```

### Loki Not Receiving Logs

```bash
# Check Promtail logs
kubectl logs -n monitoring daemonset/promtail

# Check Loki logs
kubectl logs -n monitoring statefulset/loki

# Test log ingestion
curl -X POST http://localhost:3100/loki/api/v1/push \
  -H "Content-Type: application/json" \
  -d '{"streams":[{"stream":{"job":"test"},"values":[["1234567890000000000","test message"]]}]}'
```

### High Memory Usage

```bash
# Reduce retention
# In prometheus-values.yaml:
retention: 15d  # Reduce from 30d

# Reduce scrape interval
# In prometheus.yml:
scrape_interval: 30s  # Increase from 15s
```

## Scaling

### Horizontal Scaling

```bash
# Scale Prometheus
kubectl scale statefulset prometheus -n monitoring --replicas=3

# Scale Grafana
kubectl scale deployment grafana -n monitoring --replicas=2
```

### Vertical Scaling

Update resource limits in values files:

```yaml
resources:
  requests:
    cpu: 1000m
    memory: 4Gi
  limits:
    cpu: 2000m
    memory: 8Gi
```

## Backup and Recovery

### Backup Prometheus Data

```bash
# Create snapshot
kubectl exec -n monitoring prometheus-0 -- \
  curl -XPOST http://localhost:9090/api/v1/admin/tsdb/snapshot

# Copy snapshot
kubectl cp monitoring/prometheus-0:/prometheus/snapshots/SNAPSHOT_NAME ./backup/
```

### Backup Grafana

```bash
# Export dashboards
for dashboard in $(curl -s http://admin:admin@localhost:3000/api/search | jq -r '.[].uid'); do
  curl -s http://admin:admin@localhost:3000/api/dashboards/uid/$dashboard | jq . > backup/dashboard-$dashboard.json
done
```

## Security

### Enable Authentication

**Prometheus**:

```yaml
# Add basic auth
web:
  basicAuth:
    users:
      admin: hashed_password
```

**Grafana**:

```yaml
# Use LDAP/OAuth
auth.ldap:
  enabled: true
  config_file: /etc/grafana/ldap.toml
```

### Network Policies

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: prometheus-network-policy
spec:
  podSelector:
    matchLabels:
      app: prometheus
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: grafana
```

## Support

For issues or questions:
- Check logs: `kubectl logs -n monitoring <pod-name>`
- Review metrics: http://localhost:9090
- Community: Prometheus, Grafana, Loki communities

## Additional Resources

- [Prometheus Documentation](https://prometheus.io/docs/)
- [Grafana Documentation](https://grafana.com/docs/)
- [Loki Documentation](https://grafana.com/docs/loki/)
- [Jaeger Documentation](https://www.jaegertracing.io/docs/)
- [OpenTelemetry Documentation](https://opentelemetry.io/docs/)
EOF

    print_success "README.md created"
}

# ============================================================================
# MAIN ORCHESTRATION
# ============================================================================
main() {
    display_header
    
    print_info "Starting Observability Stack Generator..."
    echo ""
    
    # Collect configurations
    select_stack_components
    select_deployment_method
    collect_configuration
    
    echo ""
    print_info "Generating observability stack..."
    echo ""
    
    # Create directory structure
    create_directory_structure
    
    # Generate configurations
    if [ "$ENABLE_PROMETHEUS" = true ]; then
        generate_prometheus_config
        generate_prometheus_alerts
    fi
    
    if [ "$ENABLE_ALERTMANAGER" = true ]; then
        generate_alertmanager_config
    fi
    
    if [ "$ENABLE_GRAFANA" = true ]; then
        generate_grafana_dashboards
        generate_grafana_datasources
    fi
    
    if [ "$ENABLE_LOKI" = true ]; then
        generate_loki_config
        generate_promtail_config
    fi
    
    if [ "$ENABLE_TRACING" = true ]; then
        if [ "$TRACING_STACK" = "jaeger" ]; then
            generate_jaeger_config
        else
            generate_tempo_config
        fi
    fi
    
    # Generate deployment files
    case $DEPLOYMENT_METHOD in
        helm)
            generate_helm_values
            ;;
        k8s)
            generate_k8s_manifests
            ;;
        docker-compose)
            generate_docker_compose
            ;;
    esac
    
    # Generate deployment scripts and README
    generate_deployment_scripts
    generate_readme
    
    echo ""
    print_success "============================================================"
    print_success "   Observability Stack Generated Successfully!             "
    print_success "============================================================"
    echo ""
    
    print_info "Generated structure:"
    tree -L 3 observability/ 2>/dev/null || find observability/ -type d | sed 's|^|  |'
    
    echo ""
    print_info "Components enabled:"
    [ "$ENABLE_PROMETHEUS" = true ] && echo "  ✓ Prometheus (metrics)"
    [ "$ENABLE_GRAFANA" = true ] && echo "  ✓ Grafana (dashboards)"
    [ "$ENABLE_ALERTMANAGER" = true ] && echo "  ✓ AlertManager (alerts)"
    [ "$ENABLE_LOKI" = true ] && echo "  ✓ Loki (logging)"
    [ "$ENABLE_TRACING" = true ] && echo "  ✓ ${TRACING_STACK^} (tracing)"
    
    echo ""
    print_info "Quick start:"
    case $DEPLOYMENT_METHOD in
        helm)
            echo "  cd observability"
            echo "  ./deploy-helm.sh"
            ;;
        k8s)
            echo "  cd observability"
            echo "  ./deploy-k8s.sh"
            ;;
        docker-compose)
            echo "  cd observability"
            echo "  ./deploy-docker.sh"
            ;;
    esac
    
    echo ""
    print_info "For detailed instructions, see: observability/README.md"
    echo ""
    
    print_success "🎉 Your observability stack is ready!"
}

# Run main function
main
