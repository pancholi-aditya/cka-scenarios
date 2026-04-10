#!/bin/bash
set -e

kubectl create namespace spline-reticulator

kubectl apply -n spline-reticulator -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: front-end
spec:
  replicas: 2
  selector:
    matchLabels:
      app: front-end
  template:
    metadata:
      labels:
        app: front-end
    spec:
      containers:
      - name: nginx
        image: nginx:1.25
EOF
