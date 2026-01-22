#!/bin/bash
set -e

# Ensure cluster is reachable
kubectl get nodes >/dev/null

# Clean up from previous runs
kubectl delete deployment appychip --ignore-not-found

# Create broken Deployment
kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: appychip
  namespace: default
spec:
  replicas: 2
  selector:
    matchLabels:
      app: appychip
  template:
    metadata:
      labels:
        app: appychip
    spec:
      containers:
      - name: nginx
        image: nginx
        command: ["nginx"]
        args: ["-g", "daemon off;invalid"]
        ports:
        - containerPort: 80
EOF
