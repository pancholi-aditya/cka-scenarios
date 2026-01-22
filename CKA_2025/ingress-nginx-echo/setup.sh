#!/bin/bash
set -e

echo "[SETUP] Installing NGINX Ingress Controller..."
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.11.1/deploy/static/provider/cloud/deploy.yaml

kubectl -n ingress-nginx rollout status deployment ingress-nginx-controller --timeout=180s

echo "[SETUP] Creating namespace..."
kubectl create namespace sound-repeater || true

echo "[SETUP] Creating echo server Deployment..."
kubectl -n sound-repeater apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: echoserver
spec:
  replicas: 1
  selector:
    matchLabels:
      app: echoserver
  template:
    metadata:
      labels:
        app: echoserver
    spec:
      containers:
      - name: echoserver
        image: ealen/echo-server
        ports:
        - containerPort: 8080
EOF

echo "[SETUP] Creating Service..."
kubectl -n sound-repeater apply -f - <<EOF
apiVersion: v1
kind: Service
metadata:
  name: echoserver-service
spec:
  selector:
    app: echoserver
  ports:
  - port: 8080
    targetPort: 8080
EOF

kubectl -n sound-repeater rollout status deployment echoserver

echo "[SETUP] Environment ready."
