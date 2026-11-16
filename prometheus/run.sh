#!/bin/sh
set -e

mkdir -p /share/prometheus/data

# Generate default scrape config targeting internal HA add-on hostname
if [ ! -f /share/prometheus/prometheus.yml ]; then
    cat << 'YAML' > /share/prometheus/prometheus.yml
global:
  scrape_interval: 5s

scrape_configs:
  - job_name: 'farm-proxy'
    static_configs:
      - targets: ['local-braiins-proxy:8080']
YAML
fi

# Ensure permissions for non-root Prometheus user (UID 65534)
chmod -R 777 /share/prometheus

exec /bin/prometheus \
  --config.file=/share/prometheus/prometheus.yml \
  --storage.tsdb.path=/share/prometheus/data \
  --web.listen-address=0.0.0.0:9090
