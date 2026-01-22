#!/bin/bash
set -e

# Ensure cluster is reachable
kubectl get nodes >/dev/null

# Cleanup from previous runs
rm -f /root/ajeet.key /root/ajeet.csr /root/ajeet.csr.yaml

# Create a test namespace and pod for verification
kubectl create namespace rbac-test || true

kubectl -n rbac-test apply -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: test-pod
spec:
  containers:
  - name: nginx
    image: nginx
EOF
