#!/bin/bash
set -e

# Create namespace
kubectl create namespace auto-scale --dry-run=client -o yaml | kubectl apply -f -

# Create Deployment
kubectl -n auto-scale apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: apache-server
spec:
  replicas: 1
  selector:
    matchLabels:
      app: apache
  template:
    metadata:
      labels:
        app: apache
    spec:
      containers:
      - name: apache
        image: httpd:2.4
        ports:
        - containerPort: 80
        resources:
          requests:
            cpu: "100m"
          limits:
            cpu: "200m"
EOF

# Ensure metrics-server is available (usually pre-installed)
kubectl wait --for=condition=Available deployment/metrics-server \
  -n kube-system --timeout=120s || true

