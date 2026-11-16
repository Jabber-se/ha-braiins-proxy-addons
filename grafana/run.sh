#!/bin/sh
set -e

mkdir -p /share/braiins_grafana/data

# Copy bundled dashboards and provisioning config on first run
if [ ! -d /share/braiins_grafana/monitoring ]; then
    cp -r /opt/braiins_monitoring /share/braiins_grafana/monitoring
fi

# Ensure permissions for non-root Grafana user (UID 472)
chmod -R 777 /share/braiins_grafana

export GF_PATHS_DATA=/share/braiins_grafana/data
export GF_PATHS_PROVISIONING=/share/braiins_grafana/monitoring/grafana/provisioning
export GF_PATHS_CONFIG=/share/braiins_grafana/monitoring/grafana/provisioning/grafana.ini
export GF_SECURITY_ALLOW_EMBEDDING=true
export GF_AUTH_ANONYMOUS_ENABLED=true
export GF_AUTH_ANONYMOUS_ORG_ROLE=Viewer
export GF_DASHBOARDS_DEFAULT_HOME_DASHBOARD_PATH=/share/braiins_grafana/monitoring/grafana/provisioning/default_dashboards/farm-proxy/client_dashboard.json

exec /run.sh
