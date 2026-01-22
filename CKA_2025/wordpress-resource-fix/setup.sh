#!/bin/bash
set -e

kubectl create namespace wordpress 2>/dev/null || true

# WordPress Deployment with excessive resource requests (Pods won't schedule)
kubectl apply -n wordpress -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: wordpress
spec:
  replicas: 3
  selector:
    matchLabels:
      app: wordpress
  template:
    metadata:
      labels:
        app: wordpress
    spec:
      initContainers:
      - name: init-db
        image: busybox
        command: ["sh", "-c", "sleep 5"]
        resources:
          requests:
            cpu: "1000m"
            memory: "1Gi"
      containers:
      - name: wordpress
        image: wordpress:latest
        ports:
        - containerPort: 80
        resources:
          requests:
            cpu: "1000m"
            memory: "1Gi"
EOF
