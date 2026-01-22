#!/bin/bash
set -e

# Ensure cluster is reachable
kubectl get nodes >/dev/null

# Create known data that must survive restore
kubectl create namespace etcd-test || true
kubectl -n etcd-test create configmap etcd-marker \
  --from-literal=key=original \
  --dry-run=client -o yaml | kubectl apply -f -

# Remove any previous snapshot
rm -f /opt/etcd-backup.db
