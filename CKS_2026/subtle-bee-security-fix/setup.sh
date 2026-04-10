#!/bin/bash
set -e

echo "[SETUP] Preparing subtle-bee security files..."

APP_DIR=/home/candidate/subtle-bee
BUILD_MARKER=/opt/course/subtle-bee-docker-build-attempted
mkdir -p "$APP_DIR"

cat > "$APP_DIR/Dockerfile" <<'EOF'
FROM nginx:1.27

COPY index.html /usr/share/nginx/html/index.html

USER root

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
EOF

cat > "$APP_DIR/index.html" <<'EOF'
subtle-bee
EOF

cat > "$APP_DIR/deployment.yaml" <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: subtle-bee
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: subtle-bee
  template:
    metadata:
      labels:
        app: subtle-bee
    spec:
      securityContext:
        runAsUser: 0
      containers:
      - name: subtle-bee
        image: subtle-bee:1.0
        ports:
        - containerPort: 80
EOF

chown -R candidate:candidate "$APP_DIR" 2>/dev/null || true

mkdir -p /opt/course
if command -v docker >/dev/null 2>&1 && [ ! -f /usr/local/bin/docker ]; then
  cat > /usr/local/bin/docker <<'EOF'
#!/bin/bash
if [ "$1" = "build" ]; then
  touch /opt/course/subtle-bee-docker-build-attempted
  echo "Do not build this Dockerfile for this task." >&2
  exit 1
fi
exec /usr/bin/docker "$@"
EOF
  chmod +x /usr/local/bin/docker
fi

echo "[SETUP] Files are available in $APP_DIR."
