#!/bin/bash
set -e

echo "[SETUP] Creating namespace..."
kubectl create namespace tls-nginx || true

echo "[SETUP] Generating TLS certificate..."
openssl req -x509 -nodes -days 365 \
  -newkey rsa:2048 \
  -keyout /tmp/tls.key \
  -out /tmp/tls.crt \
  -subj "/CN=nginx.local"

kubectl -n tls-nginx create secret tls nginx-tls \
  --cert=/tmp/tls.crt \
  --key=/tmp/tls.key \
  --dry-run=client -o yaml | kubectl apply -f -

echo "[SETUP] Creating NGINX TLS ConfigMap (TLS 1.2 + 1.3 enabled)..."

kubectl -n tls-nginx apply -f - <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: nginx-tls-config
data:
  nginx.conf: |
    events {}
    http {
      server {
        listen 443 ssl;
        ssl_certificate /etc/tls/tls.crt;
        ssl_certificate_key /etc/tls/tls.key;
        ssl_protocols TLSv1.2 TLSv1.3;
        location / {
          return 200 'NGINX TLS OK';
        }
      }
    }
EOF

echo "[SETUP] Deploying NGINX..."

kubectl -n tls-nginx apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:stable
        ports:
        - containerPort: 443
        volumeMounts:
        - name: config
          mountPath: /etc/nginx/nginx.conf
          subPath: nginx.conf
        - name: tls
          mountPath: /etc/tls
      volumes:
      - name: config
        configMap:
          name: nginx-tls-config
      - name: tls
        secret:
          secretName: nginx-tls
EOF

kubectl -n tls-nginx rollout status deployment/nginx

echo "[SETUP] Exposing NGINX service..."

kubectl -n tls-nginx expose deployment nginx \
  --name=nginx-svc \
  --port=443 \
  --target-port=443 \
  --type=NodePort

echo "[SETUP] Environment ready."
