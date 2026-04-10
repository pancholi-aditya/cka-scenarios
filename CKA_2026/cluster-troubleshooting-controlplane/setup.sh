#!/bin/bash
set -e

echo "[SETUP] Simulating post-migration control plane failure..."

MANIFEST_DIR=/etc/kubernetes/manifests
APISERVER_MANIFEST=${MANIFEST_DIR}/kube-apiserver.yaml

# Backup original manifest
cp ${APISERVER_MANIFEST} ${APISERVER_MANIFEST}.bak

echo "[SETUP] Injecting wrong advertise-address into kube-apiserver..."

sed -i 's/--advertise-address=.*/--advertise-address=10.255.255.1/' \
  ${APISERVER_MANIFEST}

echo "[SETUP] Restarting kubelet to apply broken state..."
systemctl restart kubelet

sleep 5

echo "[SETUP] Cluster is now in a broken state."
echo "[SETUP] kube-apiserver will not start correctly."
