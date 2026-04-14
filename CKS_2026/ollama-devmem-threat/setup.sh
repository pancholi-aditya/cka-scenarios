#!/bin/bash
set -e

echo "[SETUP] Preparing ollama threat scenario..."

NS=ollama
STATE_DIR=/opt/course/ollama-threat
OLLAMA_IMAGE=ollama:custom
IMAGE_DIR=/tmp/ollama-custom-image
FALCO_LOG=/var/log/falco.log
FALCO_MONITOR=/usr/local/bin/ollama-falco-monitor.sh
FALCO_SERVICE=/etc/systemd/system/ollama-falco-monitor.service
mkdir -p "$STATE_DIR" "$IMAGE_DIR"

kubectl create namespace "$NS" 2>/dev/null || true

cat > "$IMAGE_DIR/Dockerfile" <<'EOF'
FROM busybox:1.36
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
EOF

cat > "$IMAGE_DIR/entrypoint.sh" <<'EOF'
#!/bin/sh
set -eu

role="${HOSTNAME##*-}"

echo "ollama container for ${role} is healthy"
sleep 25

while true; do
  if [ "$role" = "amd" ]; then
    echo "SECURITY ALERT: probing /dev/mem"
    dd if=/dev/mem of=/dev/null bs=1 count=1 2>&1 || true
  else
    echo "${role} healthy"
  fi
  sleep 20
done
EOF

docker build -t "$OLLAMA_IMAGE" "$IMAGE_DIR" >/dev/null

kubectl -n "$NS" apply -f - <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: cpu
spec:
  replicas: 1
  selector:
    matchLabels:
      app: ollama
      component: cpu
  template:
    metadata:
      labels:
        app: ollama
        component: cpu
    spec:
      containers:
      - name: ollama
        image: ollama:custom
        imagePullPolicy: Never
        securityContext:
          privileged: true
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nvidia
spec:
  replicas: 1
  selector:
    matchLabels:
      app: ollama
      component: nvidia
  template:
    metadata:
      labels:
        app: ollama
        component: nvidia
    spec:
      containers:
      - name: ollama
        image: ollama:custom
        imagePullPolicy: Never
        securityContext:
          privileged: true
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: amd
spec:
  replicas: 1
  selector:
    matchLabels:
      app: ollama
      component: amd
  template:
    metadata:
      labels:
        app: ollama
        component: amd
    spec:
      containers:
      - name: ollama
        image: ollama:custom
        imagePullPolicy: Never
        securityContext:
          privileged: true
EOF

sleep 10

: > "$FALCO_LOG"
cat > "$FALCO_MONITOR" <<'EOF'
#!/bin/bash
set -euo pipefail

LOG_FILE=/var/log/falco.log
NS=ollama

until [ "$(kubectl -n "$NS" get pods --no-headers 2>/dev/null | awk '$3=="Running"{count++} END{print count+0}')" -ge 3 ]; do
  sleep 5
done

# Start Falco-style monitoring only after all pods are healthy and settled.
sleep 35

while true; do
  while read -r cid name; do
    [ -n "${cid:-}" ] || continue
    recent=$(docker logs --since 30s "$cid" 2>&1 || true)
    if echo "$recent" | grep -q "SECURITY ALERT: probing /dev/mem"; then
      timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
      echo "${timestamp} Falco: Warning Sensitive file opened for reading by container name=${name} file=/dev/mem" >> "$LOG_FILE"
    fi
  done < <(docker ps --format '{{.ID}} {{.Names}}' | grep 'k8s_ollama_')
  sleep 10
done
EOF

chmod +x "$FALCO_MONITOR"
cat > "$FALCO_SERVICE" <<EOF
[Unit]
Description=Ollama Falco-style monitor
After=docker.service kubelet.service

[Service]
ExecStart=$FALCO_MONITOR
Restart=always
RestartSec=2

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now ollama-falco-monitor.service >/dev/null 2>&1

for dep in cpu nvidia amd; do
  kubectl -n "$NS" get deployment "$dep" -o json > "$STATE_DIR/$dep.json"
done

echo "[SETUP] Scenario ready in namespace $NS."
echo "[SETUP] Falco messages will appear in $FALCO_LOG after startup settles."
