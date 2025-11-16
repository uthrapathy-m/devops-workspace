# Complete Observability Stack Guide

## 📊 Overview

This comprehensive observability stack provides **complete visibility** into your infrastructure, applications, and business metrics through the three pillars of observability:

### The Three Pillars

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   METRICS   │     │    LOGS     │     │   TRACES    │
│             │     │             │     │             │
│ Prometheus  │────▶│   Loki/ELK  │◀────│   Jaeger    │
│   Grafana   │     │   Kibana    │     │   Tempo     │
└─────────────┘     └─────────────┘     └─────────────┘
       │                   │                    │
       └───────────────────┴────────────────────┘
                           │
                    ┌──────▼──────┐
                    │  Unified    │
                    │ Observ.     │
                    │ Platform    │
                    └─────────────┘
```

## 🚀 Quick Start

### Interactive Generation

```bash
# Make executable
chmod +x observability-generator.sh

# Run generator
./observability-generator.sh
```

### Interactive Setup Flow

```
============================================================
   Monitoring & Observability Stack Generator
   Complete Observability Infrastructure
============================================================

=== Select Observability Components ===

What would you like to deploy?
1) Complete Stack (Metrics + Logs + Traces)
2) Metrics Only (Prometheus + Grafana)
3) Logging Only (ELK/EFK/Loki)
4) Tracing Only (Jaeger/Tempo)
5) Custom (Choose components)
> 1

=== Deployment Method ===
1) Helm (Recommended)
2) Kubernetes Manifests
3) Docker Compose
> 1

=== Configuration ===
Namespace: monitoring
Storage size: 50Gi
Retention days: 30

✅ Observability Stack Generated!
```

## 📁 Generated Structure

```
observability/
├── helm/                           # Helm values files
│   ├── prometheus-values.yaml
│   ├── loki-values.yaml
│   ├── jaeger-values.yaml
│   └── tempo-values.yaml
├── k8s/                           # Kubernetes manifests
│   ├── namespace.yaml
│   ├── prometheus/
│   ├── grafana/
│   ├── loki/
│   └── jaeger/
├── docker-compose/                # Docker Compose setup
│   └── docker-compose.yml
├── configs/                       # Service configurations
│   ├── prometheus/
│   │   ├── prometheus.yml
│   │   └── alertmanager.yml
│   ├── grafana/
│   │   └── datasources.yml
│   ├── loki/
│   │   ├── loki.yaml
│   │   └── promtail.yaml
│   └── jaeger/
│       └── jaeger.yaml
├── dashboards/                    # Pre-built dashboards
│   ├── grafana/
│   │   ├── kubernetes-cluster.json
│   │   ├── application-performance.json
│   │   └── node-exporter.json
│   └── kibana/
├── alerts/                        # Alert rules
│   ├── prometheus/
│   │   ├── general-rules.yml
│   │   ├── kubernetes-rules.yml
│   │   └── application-rules.yml
│   └── elastalert/
├── deploy-helm.sh                 # Helm deployment script
├── deploy-k8s.sh                  # Kubernetes deployment
├── deploy-docker.sh               # Docker deployment
└── README.md                      # Complete documentation
```

## 🎯 Component Details

### 1. Prometheus (Metrics)

**What it monitors:**
- ✅ System metrics (CPU, Memory, Disk, Network)
- ✅ Kubernetes cluster state
- ✅ Application metrics
- ✅ Custom business metrics

**Configuration:**
```yaml
# prometheus.yml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  # Kubernetes API server
  - job_name: 'kubernetes-apiservers'
    kubernetes_sd_configs:
      - role: endpoints
    
  # Kubernetes nodes
  - job_name: 'kubernetes-nodes'
    kubernetes_sd_configs:
      - role: node
    
  # Kubernetes pods (auto-discovery)
  - job_name: 'kubernetes-pods'
    kubernetes_sd_configs:
      - role: pod
    relabel_configs:
      - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scrape]
        action: keep
        regex: true
```

**Key Features:**
- 🔍 Service discovery (Kubernetes, Consul, EC2, etc.)
- 📈 Time-series database
- 🔔 Alert rules and expressions
- 🎯 Label-based filtering
- 💾 Long-term storage support

### 2. Grafana (Visualization)

**Pre-configured Dashboards:**

#### Kubernetes Cluster Overview
```json
{
  "dashboard": {
    "title": "Kubernetes Cluster Overview",
    "panels": [
      {
        "title": "Cluster CPU Usage",
        "expr": "sum(rate(container_cpu_usage_seconds_total[5m])) by (node)"
      },
      {
        "title": "Cluster Memory Usage",
        "expr": "sum(container_memory_usage_bytes) by (node)"
      },
      {
        "title": "Pod Count",
        "expr": "count(kube_pod_info)"
      }
    ]
  }
}
```

#### Application Performance
- Request rate (RPS)
- Error rate (%)
- Latency (p50, p95, p99)
- Throughput

#### Node Exporter
- System metrics
- Disk I/O
- Network traffic
- Process statistics

**Key Features:**
- 📊 Multiple data sources
- 🎨 Custom dashboards
- 🔔 Alert annotations
- 📱 Mobile support
- 👥 Team management

### 3. Loki (Logging)

**Why Loki?**
- 💰 Cost-effective (indexes labels, not content)
- 🚀 Fast queries
- 🔗 Native Grafana integration
- 📦 S3/GCS/Azure storage

**Log Aggregation Flow:**
```
Application Logs
      │
      ▼
  Promtail (Agent)
      │
      ▼
  Loki (Storage)
      │
      ▼
  Grafana (Query)
```

**Configuration:**
```yaml
# loki.yaml
auth_enabled: false

server:
  http_listen_port: 3100

schema_config:
  configs:
    - from: 2020-10-24
      store: boltdb-shipper
      object_store: filesystem
      schema: v11

limits_config:
  retention_period: 30d
```

**Query Examples:**
```logql
# All logs from production namespace
{namespace="production"}

# Error logs only
{namespace="production"} |= "error"

# Specific pod logs
{namespace="production", pod=~"api-.*"}

# Rate of errors
rate({namespace="production"} |= "error" [5m])

# JSON log parsing
{app="api"} | json | level="error"

# Pattern matching
{app="api"} | pattern `<_> level=<level> msg=<msg>`
```

### 4. AlertManager (Alerting)

**Alert Routing:**
```yaml
route:
  receiver: 'default'
  routes:
    # Critical alerts → PagerDuty + Slack
    - match:
        severity: critical
      receiver: 'pagerduty'
      continue: true
    
    # Critical also to Slack
    - match:
        severity: critical
      receiver: 'slack-critical'
    
    # Warnings → Slack only
    - match:
        severity: warning
      receiver: 'slack-warning'
```

**Notification Channels:**
- 📧 Email
- 💬 Slack
- 📟 PagerDuty
- 📱 Telegram
- 🔔 Webhook
- 📞 VictorOps/Splunk On-Call

### 5. Jaeger/Tempo (Tracing)

**Distributed Tracing:**
```
User Request
    │
    ▼
API Gateway (span)
    │
    ├──▶ Auth Service (span)
    │     └──▶ Database (span)
    │
    ├──▶ Product Service (span)
    │     ├──▶ Cache (span)
    │     └──▶ Database (span)
    │
    └──▶ Payment Service (span)
          └──▶ External API (span)
```

**Jaeger Features:**
- 🔍 Full trace visualization
- 🎯 Service dependency graph
- 📊 Performance analysis
- 🐛 Error investigation

**Tempo Features:**
- 💾 S3/GCS/Azure backend
- 🔗 Grafana integration
- 💰 Cost-effective
- 🚀 High throughput

## 📈 Alert Rules

### General Infrastructure Alerts

**Instance Down:**
```yaml
- alert: InstanceDown
  expr: up == 0
  for: 5m
  labels:
    severity: critical
  annotations:
    summary: "Instance {{ $labels.instance }} down"
    description: "{{ $labels.instance }} has been down for 5+ minutes"
```

**High CPU Usage:**
```yaml
- alert: HighCPUUsage
  expr: 100 - (avg by (instance) (irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100) > 80
  for: 10m
  labels:
    severity: warning
  annotations:
    summary: "High CPU on {{ $labels.instance }}"
    description: "CPU usage is {{ $value }}%"
```

**High Memory Usage:**
```yaml
- alert: HighMemoryUsage
  expr: (1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100 > 85
  for: 10m
  labels:
    severity: warning
  annotations:
    summary: "High memory on {{ $labels.instance }}"
    description: "Memory usage is {{ $value }}%"
```

### Kubernetes Alerts

**Pod Crash Looping:**
```yaml
- alert: KubernetesPodCrashLooping
  expr: rate(kube_pod_container_status_restarts_total[15m]) > 0
  for: 5m
  labels:
    severity: critical
  annotations:
    summary: "Pod crash looping"
    description: "{{ $labels.namespace }}/{{ $labels.pod }} is restarting"
```

**Deployment Replicas Mismatch:**
```yaml
- alert: KubernetesDeploymentReplicasMismatch
  expr: kube_deployment_spec_replicas != kube_deployment_status_replicas_available
  for: 10m
  labels:
    severity: warning
  annotations:
    summary: "Deployment replicas mismatch"
    description: "{{ $labels.namespace }}/{{ $labels.deployment }}"
```

### Application Alerts

**High Error Rate:**
```yaml
- alert: HighErrorRate
  expr: rate(http_requests_total{status=~"5.."}[5m]) > 0.05
  for: 5m
  labels:
    severity: critical
  annotations:
    summary: "High error rate in {{ $labels.job }}"
    description: "Error rate is {{ $value | humanizePercentage }}"
```

**High Latency:**
```yaml
- alert: HighLatency
  expr: histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m])) > 1
  for: 10m
  labels:
    severity: warning
  annotations:
    summary: "High latency in {{ $labels.job }}"
    description: "p95 latency is {{ $value }}s"
```

## 🔧 Application Instrumentation

### Prometheus Metrics

#### Node.js (Express)
```javascript
const promClient = require('prom-client');
const express = require('express');

// Create a Registry
const register = new promClient.Registry();

// Add default metrics
promClient.collectDefaultMetrics({ register });

// Custom metrics
const httpRequestDuration = new promClient.Histogram({
  name: 'http_request_duration_seconds',
  help: 'Duration of HTTP requests in seconds',
  labelNames: ['method', 'route', 'status_code'],
  buckets: [0.1, 0.5, 1, 2, 5]
});

const httpRequestTotal = new promClient.Counter({
  name: 'http_requests_total',
  help: 'Total number of HTTP requests',
  labelNames: ['method', 'route', 'status_code']
});

register.registerMetric(httpRequestDuration);
register.registerMetric(httpRequestTotal);

// Middleware
app.use((req, res, next) => {
  const start = Date.now();
  
  res.on('finish', () => {
    const duration = (Date.now() - start) / 1000;
    
    httpRequestDuration.labels(
      req.method,
      req.route?.path || 'unknown',
      res.statusCode
    ).observe(duration);
    
    httpRequestTotal.labels(
      req.method,
      req.route?.path || 'unknown',
      res.statusCode
    ).inc();
  });
  
  next();
});

// Metrics endpoint
app.get('/metrics', async (req, res) => {
  res.set('Content-Type', register.contentType);
  res.end(await register.metrics());
});
```

#### Python (Flask)
```python
from prometheus_client import Counter, Histogram, generate_latest
from flask import Flask, Response
import time

app = Flask(__name__)

# Metrics
REQUEST_COUNT = Counter(
    'http_requests_total',
    'Total HTTP requests',
    ['method', 'endpoint', 'status']
)

REQUEST_DURATION = Histogram(
    'http_request_duration_seconds',
    'HTTP request duration',
    ['method', 'endpoint']
)

@app.before_request
def before_request():
    request.start_time = time.time()

@app.after_request
def after_request(response):
    duration = time.time() - request.start_time
    
    REQUEST_DURATION.labels(
        method=request.method,
        endpoint=request.endpoint
    ).observe(duration)
    
    REQUEST_COUNT.labels(
        method=request.method,
        endpoint=request.endpoint,
        status=response.status_code
    ).inc()
    
    return response

@app.route('/metrics')
def metrics():
    return Response(generate_latest(), mimetype='text/plain')
```

#### Go
```go
package main

import (
    "github.com/prometheus/client_golang/prometheus"
    "github.com/prometheus/client_golang/prometheus/promhttp"
    "net/http"
    "time"
)

var (
    httpRequestsTotal = prometheus.NewCounterVec(
        prometheus.CounterOpts{
            Name: "http_requests_total",
            Help: "Total number of HTTP requests",
        },
        []string{"method", "endpoint", "status"},
    )
    
    httpRequestDuration = prometheus.NewHistogramVec(
        prometheus.HistogramOpts{
            Name:    "http_request_duration_seconds",
            Help:    "HTTP request duration",
            Buckets: prometheus.DefBuckets,
        },
        []string{"method", "endpoint"},
    )
)

func init() {
    prometheus.MustRegister(httpRequestsTotal)
    prometheus.MustRegister(httpRequestDuration)
}

func metricsMiddleware(next http.Handler) http.Handler {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        start := time.Now()
        
        wrapped := &responseWriter{ResponseWriter: w, statusCode: 200}
        next.ServeHTTP(wrapped, r)
        
        duration := time.Since(start).Seconds()
        
        httpRequestDuration.WithLabelValues(
            r.Method,
            r.URL.Path,
        ).Observe(duration)
        
        httpRequestsTotal.WithLabelValues(
            r.Method,
            r.URL.Path,
            fmt.Sprintf("%d", wrapped.statusCode),
        ).Inc()
    })
}

func main() {
    http.Handle("/metrics", promhttp.Handler())
    http.ListenAndServe(":8080", metricsMiddleware(router))
}
```

### Distributed Tracing

#### OpenTelemetry (Node.js)
```javascript
const { NodeTracerProvider } = require('@opentelemetry/sdk-trace-node');
const { JaegerExporter } = require('@opentelemetry/exporter-jaeger');
const { registerInstrumentations } = require('@opentelemetry/instrumentation');
const { HttpInstrumentation } = require('@opentelemetry/instrumentation-http');
const { ExpressInstrumentation } = require('@opentelemetry/instrumentation-express');

// Configure Jaeger exporter
const exporter = new JaegerExporter({
  endpoint: 'http://jaeger-collector:14268/api/traces',
});

// Create tracer provider
const provider = new NodeTracerProvider();
provider.addSpanProcessor(new BatchSpanProcessor(exporter));
provider.register();

// Register instrumentations
registerInstrumentations({
  instrumentations: [
    new HttpInstrumentation(),
    new ExpressInstrumentation(),
  ],
});

// Use in code
const { trace } = require('@opentelemetry/api');

app.get('/api/users', async (req, res) => {
  const tracer = trace.getTracer('my-app');
  const span = tracer.startSpan('get-users');
  
  try {
    const users = await db.query('SELECT * FROM users');
    span.setStatus({ code: SpanStatusCode.OK });
    res.json(users);
  } catch (error) {
    span.setStatus({ 
      code: SpanStatusCode.ERROR,
      message: error.message 
    });
    res.status(500).json({ error: 'Internal server error' });
  } finally {
    span.end();
  }
});
```

#### OpenTelemetry (Python)
```python
from opentelemetry import trace
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor
from opentelemetry.exporter.jaeger.thrift import JaegerExporter

# Configure tracer
trace.set_tracer_provider(TracerProvider())
tracer = trace.get_tracer(__name__)

# Configure Jaeger exporter
jaeger_exporter = JaegerExporter(
    agent_host_name='jaeger-agent',
    agent_port=6831,
)

trace.get_tracer_provider().add_span_processor(
    BatchSpanProcessor(jaeger_exporter)
)

# Use in code
@app.route('/api/users')
def get_users():
    with tracer.start_as_current_span('get-users') as span:
        try:
            users = db.query('SELECT * FROM users')
            span.set_status(Status(StatusCode.OK))
            return jsonify(users)
        except Exception as e:
            span.set_status(Status(StatusCode.ERROR, str(e)))
            span.record_exception(e)
            return jsonify({'error': 'Internal server error'}), 500
```

### Structured Logging

#### JSON Logging (Node.js)
```javascript
const winston = require('winston');

const logger = winston.createLogger({
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.json()
  ),
  transports: [
    new winston.transports.Console()
  ]
});

// Usage
logger.info('User login', {
  userId: '12345',
  ip: req.ip,
  userAgent: req.headers['user-agent'],
  duration: 125,
  traceId: req.headers['x-trace-id']
});

// Output:
// {
//   "level": "info",
//   "message": "User login",
//   "timestamp": "2024-11-06T10:00:00.000Z",
//   "userId": "12345",
//   "ip": "192.168.1.1",
//   "duration": 125,
//   "traceId": "abc-123"
// }
```

#### Structured Logging (Python)
```python
import structlog

structlog.configure(
    processors=[
        structlog.stdlib.add_log_level,
        structlog.stdlib.add_logger_name,
        structlog.processors.TimeStamper(fmt="iso"),
        structlog.processors.JSONRenderer()
    ]
)

logger = structlog.get_logger()

# Usage
logger.info(
    "user_login",
    user_id="12345",
    ip=request.remote_addr,
    duration=125,
    trace_id=request.headers.get('X-Trace-Id')
)
```

## 📊 Dashboard Examples

### SRE Golden Signals

**Latency:**
```promql
# p50 latency
histogram_quantile(0.50, rate(http_request_duration_seconds_bucket[5m]))

# p95 latency
histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))

# p99 latency
histogram_quantile(0.99, rate(http_request_duration_seconds_bucket[5m]))
```

**Traffic:**
```promql
# Request rate
rate(http_requests_total[5m])

# Requests per second
sum(rate(http_requests_total[5m]))
```

**Errors:**
```promql
# Error rate
rate(http_requests_total{status=~"5.."}[5m])

# Error percentage
(
  sum(rate(http_requests_total{status=~"5.."}[5m]))
  /
  sum(rate(http_requests_total[5m]))
) * 100
```

**Saturation:**
```promql
# CPU saturation
100 - (avg(irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)

# Memory saturation
(1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100

# Disk saturation
(1 - (node_filesystem_avail_bytes / node_filesystem_size_bytes)) * 100
```

### RED Method (Rate, Errors, Duration)

**Rate:**
```promql
sum(rate(http_requests_total[5m])) by (service)
```

**Errors:**
```promql
sum(rate(http_requests_total{status=~"5.."}[5m])) by (service)
```

**Duration:**
```promql
histogram_quantile(0.95, 
  sum(rate(http_request_duration_seconds_bucket[5m])) by (service, le)
)
```

### USE Method (Utilization, Saturation, Errors)

**Utilization:**
```promql
# CPU utilization
100 - (avg by (instance) (irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)

# Memory utilization
(node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) / node_memory_MemTotal_bytes * 100
```

**Saturation:**
```promql
# Load average
node_load15

# Context switches
rate(node_context_switches_total[5m])
```

**Errors:**
```promql
# Network errors
rate(node_network_transmit_errs_total[5m])

# Disk errors
rate(node_disk_io_errors_total[5m])
```

## 🎯 Best Practices

### 1. Metric Naming

**Good:**
```
http_requests_total
http_request_duration_seconds
database_queries_total
cache_hit_ratio
```

**Bad:**
```
requests
latency
db
hits
```

### 2. Label Cardinality

**Good (Low cardinality):**
```
http_requests_total{method="GET", status="200", endpoint="/api/users"}
```

**Bad (High cardinality):**
```
http_requests_total{user_id="12345", session_id="abc", ip="1.2.3.4"}
# Don't use user IDs, IPs, or session IDs as labels!
```

### 3. Alert Fatigue Prevention

```yaml
# Group similar alerts
group_by: ['alertname', 'cluster', 'service']
group_wait: 30s
group_interval: 5m

# Inhibit lower-severity alerts
inhibit_rules:
  - source_match:
      severity: 'critical'
    target_match:
      severity: 'warning'
    equal: ['alertname']
```

### 4. Log Levels

```
TRACE - Very detailed, high volume
DEBUG - Detailed diagnostic info
INFO  - General informational messages
WARN  - Warning messages
ERROR - Error events
FATAL - Critical errors
```

### 5. Dashboard Organization

```
1. Overview Dashboard (Executive view)
   ├── Key metrics
   ├── SLA status
   └── Incident count

2. Service Dashboards (Per service)
   ├── RED metrics
   ├── Resource usage
   └── Dependencies

3. Infrastructure Dashboards
   ├── Node metrics
   ├── Cluster health
   └── Storage

4. Business Metrics
   ├── Transactions
   ├── Revenue
   └── User activity
```

## 🔐 Security

### Secure Prometheus

```yaml
# Basic auth
web:
  basicAuth:
    users:
      admin: $2y$10$hashed_password

# TLS
web:
  tlsConfig:
    cert: /etc/prometheus/tls/cert.pem
    key: /etc/prometheus/tls/key.pem
```

### Secure Grafana

```ini
[security]
admin_user = admin
admin_password = $__env{GF_SECURITY_ADMIN_PASSWORD}

[auth.anonymous]
enabled = false

[auth.ldap]
enabled = true
config_file = /etc/grafana/ldap.toml
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
  - Egress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: grafana
    ports:
    - protocol: TCP
      port: 9090
```

## 📚 Additional Resources

### Official Documentation
- [Prometheus](https://prometheus.io/docs/)
- [Grafana](https://grafana.com/docs/)
- [Loki](https://grafana.com/docs/loki/)
- [Jaeger](https://www.jaegertracing.io/docs/)
- [OpenTelemetry](https://opentelemetry.io/docs/)

### Community
- Prometheus Community: prometheus.io/community
- CNCF Slack: #prometheus, #loki, #jaeger
- Stack Overflow: prometheus, grafana, loki tags

### Training
- Prometheus Training: prometheus.io/docs/introduction/training
- Grafana Tutorials: grafana.com/tutorials
- OpenTelemetry Courses: opentelemetry.io/docs/demo

## 🎉 You're Ready!

Your observability stack is now configured with:

✅ **Metrics Collection** - Prometheus with auto-discovery
✅ **Visualization** - Grafana with pre-built dashboards  
✅ **Log Aggregation** - Loki/ELK with structured logging
✅ **Distributed Tracing** - Jaeger/Tempo with OpenTelemetry
✅ **Alerting** - AlertManager with multi-channel routing
✅ **Best Practices** - Production-ready configurations

Deploy your stack and gain complete visibility into your systems! 🚀
