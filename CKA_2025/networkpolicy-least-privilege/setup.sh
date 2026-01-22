#!/bin/bash
set -e

echo "[SETUP] Installing Calico for NetworkPolicy enforcement..."
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

kubectl -n kube-system rollout status daemonset/calico-node --timeout=120s

echo "[SETUP] Creating namespaces..."
kubectl create namespace frontend || true
kubectl create namespace backend || true

echo "[SETUP] Labeling namespaces..."
kubectl label namespace frontend name=frontend --overwrite
kubectl label namespace backend name=backend --overwrite

echo "[SETUP] Creating frontend Deployment..."
kubectl -n frontend apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
spec:
  replicas: 1
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
    spec:
      containers:
      - name: nginx
        image: nginx
        ports:
        - containerPort: 80
EOF

echo "[SETUP] Creating backend Deployment..."
kubectl -n backend apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend
spec:
  replicas: 1
  selector:
    matchLabels:
      app: backend
  template:
    metadata:
      labels:
        app: backend
    spec:
      containers:
      - name: nginx
        image: nginx
        ports:
        - containerPort: 80
EOF

kubectl -n frontend rollout status deployment/frontend
kubectl -n backend rollout status deployment/backend

echo "[SETUP] Environment ready."
