# Observability Quick Reference Cheatsheet

## 🚀 Quick Commands

### Deployment

```bash
# Helm (Recommended)
./observability/deploy-helm.sh

# Kubernetes
./observability/deploy-k8s.sh

# Docker Compose
./observability/deploy-docker.sh
```

### Port Forwarding

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

## 📊 PromQL Cheatsheet

### Basic Queries

```promql
# Current value
http_requests_total

# Rate over 5 minutes
rate(http_requests_total[5m])

# Sum by label
sum(http_requests_total) by (status)

# Filter by label
http_requests_total{status="200"}

# Multiple labels
http_requests_total{status="200", method="GET"}

# Regex matching
http_requests_total{status=~"2.."}

# Negative matching
http_requests_total{status!="200"}
```

### Aggregations

```promql
# Sum
sum(http_requests_total)

# Average
avg(http_requests_total)

# Min/Max
min(http_requests_total)
max(http_requests_total)

# Count
count(http_requests_total)

# Top K
topk(5, http_requests_total)

# Bottom K
bottomk(5, http_requests_total)
```

### Calculations

```promql
# Percentage
(metric_a / metric_b) * 100

# Difference
metric_a - metric_b

# Multiplication
metric_a * 1024  # Bytes to KB

# Division
metric_a / 1000  # ms to seconds
```

### Time Functions

```promql
# Rate (per-second average)
rate(http_requests_total[5m])

# Increase (absolute increase)
increase(http_requests_total[5m])

# irate (instant rate)
irate(http_requests_total[5m])

# delta (difference)
delta(cpu_temp[1h])

# deriv (derivative)
deriv(cpu_temp[1h])
```

### Percentiles

```promql
# p50
histogram_quantile(0.50, rate(http_request_duration_seconds_bucket[5m]))

# p95
histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))

# p99
histogram_quantile(0.99, rate(http_request_duration_seconds_bucket[5m]))
```

### Useful Patterns

```promql
# Error rate
rate(http_requests_total{status=~"5.."}[5m])

# Error percentage
(
  sum(rate(http_requests_total{status=~"5.."}[5m]))
  /
  sum(rate(http_requests_total[5m]))
) * 100

# Requests per second
sum(rate(http_requests_total[5m]))

# Average response time
rate(http_request_duration_seconds_sum[5m])
/
rate(http_request_duration_seconds_count[5m])

# CPU usage
100 - (avg(irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)

# Memory usage
(1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100

# Disk usage
(1 - (node_filesystem_avail_bytes / node_filesystem_size_bytes)) * 100
```

## 📝 LogQL Cheatsheet (Loki)

### Basic Queries

```logql
# All logs from app
{app="api"}

# Logs from namespace
{namespace="production"}

# Multiple labels
{namespace="production", app="api"}

# Regex matching
{app=~"api.*"}

# Negative matching
{app!="api"}
```

### Log Filtering

```logql
# Contains text
{app="api"} |= "error"

# Not contains
{app="api"} != "error"

# Regex filter
{app="api"} |~ "error|fatal"

# Negative regex
{app="api"} !~ "debug|trace"

# Case insensitive
{app="api"} |~ "(?i)error"
```

### JSON Parsing

```logql
# Parse JSON and filter
{app="api"} | json | level="error"

# Extract fields
{app="api"} | json | line_format "{{.message}}"

# Filter by nested field
{app="api"} | json | user_id="12345"
```

### Pattern Extraction

```logql
# Pattern matching
{app="api"} | pattern `<_> level=<level> msg=<msg>`

# Use extracted fields
{app="api"} | pattern `<_> level=<level>` | level="error"
```

### Aggregations

```logql
# Count logs
count_over_time({app="api"}[5m])

# Rate of logs
rate({app="api"}[5m])

# Bytes over time
bytes_over_time({app="api"}[5m])

# Count by level
sum by (level) (count_over_time({app="api"} | json [5m]))
```

### Common Patterns

```logql
# Error logs
{app="api"} |= "error"

# Errors per minute
rate({app="api"} |= "error" [1m])

# Top 5 error messages
topk(5, sum by (msg) (count_over_time({app="api"} | json | level="error" [1h])))

# Slow requests
{app="api"} | json | duration > 1000

# Failed authentications
{app="api"} |~ "authentication failed|unauthorized"

# 5xx errors
{app="nginx"} | json | status =~ "5.."
```

## 🔍 Jaeger Queries

### UI Searches

```
Service: api-service
Operation: GET /users
Tags: http.status_code=500
Min Duration: 1s
Max Duration: 10s
```

### Common Investigations

**Find slow requests:**
```
Operation: *
Min Duration: 2s
Limit: 50
```

**Find errors:**
```
Service: api-service
Tags: error=true
```

**Trace dependencies:**
```
Service: api-service
Tags: span.kind=client
```

## 🎯 Common Scenarios

### Debugging High Latency

```bash
# 1. Check p95/p99 latency
histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))

# 2. Check error rate
rate(http_requests_total{status=~"5.."}[5m])

# 3. Check resource usage
node_cpu_usage
node_memory_usage

# 4. Check logs
{app="api"} |= "slow" or "timeout"

# 5. Check traces
# Search Jaeger for slow traces
```

### Debugging High Error Rate

```bash
# 1. Error rate
rate(http_requests_total{status=~"5.."}[5m])

# 2. Error types
topk(5, sum by (status) (rate(http_requests_total{status=~"5.."}[5m])))

# 3. Error logs
{app="api"} |= "error" | json

# 4. Failed endpoints
topk(5, sum by (endpoint) (rate(http_requests_total{status=~"5.."}[5m])))

# 5. Error traces
# Search Jaeger for error=true
```

### Debugging Resource Issues

```bash
# CPU usage by pod
topk(10, sum by (pod) (rate(container_cpu_usage_seconds_total[5m])))

# Memory usage by pod
topk(10, sum by (pod) (container_memory_usage_bytes))

# Disk I/O
rate(node_disk_read_bytes_total[5m])
rate(node_disk_written_bytes_total[5m])

# Network traffic
rate(node_network_receive_bytes_total[5m])
rate(node_network_transmit_bytes_total[5m])
```

### Finding Memory Leaks

```bash
# Memory growth over 24h
delta(container_memory_usage_bytes[24h])

# Memory by pod (ascending)
sort(sum by (pod) (container_memory_usage_bytes))

# Restart count (indication of OOM)
kube_pod_container_status_restarts_total
```

## 🔔 Alert Rule Templates

### High Error Rate

```yaml
- alert: HighErrorRate
  expr: |
    (
      sum(rate(http_requests_total{status=~"5.."}[5m]))
      /
      sum(rate(http_requests_total[5m]))
    ) * 100 > 5
  for: 5m
  labels:
    severity: critical
  annotations:
    summary: "High error rate: {{ $value }}%"
```

### Pod Crash Looping

```yaml
- alert: PodCrashLooping
  expr: rate(kube_pod_container_status_restarts_total[15m]) > 0
  for: 5m
  labels:
    severity: critical
  annotations:
    summary: "Pod {{ $labels.pod }} crash looping"
```

### High Memory Usage

```yaml
- alert: HighMemoryUsage
  expr: |
    (
      container_memory_usage_bytes
      /
      container_spec_memory_limit_bytes
    ) * 100 > 90
  for: 10m
  labels:
    severity: warning
  annotations:
    summary: "Pod {{ $labels.pod }} high memory"
```

## 📱 Access URLs

### Local (Docker Compose)

```
Prometheus:    http://localhost:9090
Grafana:       http://localhost:3000
AlertManager:  http://localhost:9093
Loki:          http://localhost:3100
Jaeger:        http://localhost:16686
```

### Kubernetes (Port Forward)

```bash
# Run these in separate terminals
kubectl port-forward -n monitoring svc/prometheus 9090:9090
kubectl port-forward -n monitoring svc/grafana 3000:3000
kubectl port-forward -n monitoring svc/alertmanager 9093:9093
kubectl port-forward -n monitoring svc/loki 3100:3100
kubectl port-forward -n monitoring svc/jaeger-query 16686:16686
```

Then access at localhost URLs above.

## 🛠️ Troubleshooting

### Prometheus Not Scraping

```bash
# Check targets
curl http://localhost:9090/api/v1/targets | jq '.data.activeTargets[] | select(.health != "up")'

# Check service discovery
curl http://localhost:9090/api/v1/targets | jq '.data.activeTargets[] | .labels'

# Verify pod annotations
kubectl get pod -n production -o yaml | grep prometheus.io
```

### Grafana No Data

```bash
# Test datasource
curl -X POST http://localhost:3000/api/datasources/proxy/1/api/v1/query \
  -d 'query=up' \
  -u admin:admin

# Check datasource config
curl http://localhost:3000/api/datasources -u admin:admin
```

### Loki Not Receiving Logs

```bash
# Test Loki
curl -X POST http://localhost:3100/loki/api/v1/push \
  -H "Content-Type: application/json" \
  -d '{"streams":[{"stream":{"job":"test"},"values":[["1234567890000000000","test"]]}]}'

# Check Promtail logs
kubectl logs -n monitoring daemonset/promtail
```

## 📊 Dashboard IDs (Grafana.com)

Import these pre-built dashboards:

```
315   - Kubernetes Cluster Monitoring
1860  - Node Exporter Full
12019 - Kubernetes API Server
7249  - Kubernetes Cluster
8588  - Kubernetes Deployment
13332 - Kubernetes Monitoring
```

Import via: Dashboard → Import → Enter ID

## 🔑 Default Credentials

```
Grafana:       admin / admin (change on first login)
AlertManager:  No auth by default
Prometheus:    No auth by default
Kibana:        elastic / changeme
Jaeger:        No auth by default
```

## 🎯 Performance Tips

### Prometheus

```yaml
# Reduce retention
--storage.tsdb.retention.time=15d

# Increase scrape interval
scrape_interval: 30s

# Reduce cardinality
metric_relabel_configs:
  - source_labels: [__name__]
    regex: 'expensive_metric.*'
    action: drop
```

### Loki

```yaml
# Compress chunks
chunk_encoding: gzip

# Reduce retention
retention_period: 7d

# Limit ingestion rate
ingestion_rate_mb: 10
```

### Grafana

```
# Use query caching
# Reduce refresh intervals
# Use time range variables
# Limit data points returned
```

## 📚 Learning Resources

**PromQL:**
- https://prometheus.io/docs/prometheus/latest/querying/basics/
- https://promlabs.com/promql-cheat-sheet/

**LogQL:**
- https://grafana.com/docs/loki/latest/logql/

**OpenTelemetry:**
- https://opentelemetry.io/docs/

**Best Practices:**
- https://prometheus.io/docs/practices/naming/
- https://grafana.com/docs/grafana/latest/best-practices/

---

**Quick Start:**
```bash
./observability-generator.sh
cd observability
./deploy-helm.sh
```

**Access:**
```bash
kubectl port-forward -n monitoring svc/grafana 3000:3000
# Visit http://localhost:3000
```

🎉 **Happy Monitoring!**
