#!/bin/sh
set -e

DATA_DIR="/share/braiins_proxy"
mkdir -p "$DATA_DIR/config" "$DATA_DIR/config_cache"

# Copy default configuration templates on first run
cp -rn /usr/src/app/default_config/* "$DATA_DIR/config/" 2>/dev/null || true

# Create initial starter profile if active_profile.toml does not exist
if [ ! -f "$DATA_DIR/config/active_profile.toml" ]; then
    cat << 'TOML' > "$DATA_DIR/config/main.toml"
[[server]]
name = "LocalStratumV1"
port = 3333

[[target]]
name = "MainPool"
url = "stratum+tcp://btc.viabtc.io:3333"
user_identity = "YOUR_WALLET.worker1"
identity_pass_through = true

[[routing]]
name = "DefaultRoute"
from = [ "LocalStratumV1" ]

[[routing.goal]]
name = "MainGoal"
hr_weight = 10

[[routing.goal.level]]
targets = [ "MainPool" ]
TOML
    cp "$DATA_DIR/config/main.toml" "$DATA_DIR/config/active_profile.toml"
fi

ln -sfn "$DATA_DIR/config" /usr/src/app/config

# Resolve internal IPv4 container address (filtering out IPv6)
CONTAINER_IP=$(hostname -i | tr ' ' '\n' | grep '\.' | head -n 1)

cat <<EOF > /usr/src/app/.env
HOST=0.0.0.0
PORT=7777
API_ENDPOINT=http://${CONTAINER_IP}:8080
FP_CONFIG_PROFILE=/usr/src/app/config/active_profile.toml
MINING_PORTS=3333-3339
PROMETHEUS_PORT=9090
GRAFANA_PORT=3000
DEFAULT_SERVER_NAME=LocalStratumV1
DEFAULT_SERVER_PORT=3333
DEFAULT_TARGET_NAME=MainPool
DEFAULT_ROUTING_GOAL_NAME=MainGoal
EOF

export CONFIG_FILE="$DATA_DIR/config_cache/last_used_config.toml"
export RUST_LOG=info

# 1. Start core farm-proxy engine
/usr/local/bin/farm-proxy run &
PROXY_PID=$!

# 2. Start live configuration watcher
sleep 2
HTTP_SOCKET_OVERRIDE=${CONTAINER_IP}:8080 CONFIG_FILE="$DATA_DIR/config/active_profile.toml" /usr/local/bin/farm-proxy configure --watch &

# 3. Start Web GUI server
cd /usr/src/app
node --env-file=.env build/server/server.cjs &

wait $PROXY_PID
