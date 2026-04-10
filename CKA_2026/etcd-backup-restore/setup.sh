#!/bin/bash
set -euo pipefail

echo "[INFO] Verifying Kubernetes cluster access..."
kubectl get nodes >/dev/null

echo "[INFO] Checking for etcdutl..."
if ! command -v etcdutl >/dev/null 2>&1; then
  echo "[WARN] etcdutl not found. Installing static etcd v3.6 tools..."

  TMP_DIR=$(mktemp -d)
  ETCD_VER="v3.6.0"

  curl -fsSL \
    "https://github.com/etcd-io/etcd/releases/download/${ETCD_VER}/etcd-${ETCD_VER}-linux-amd64.tar.gz" \
    -o "${TMP_DIR}/etcd.tar.gz"

  tar -xzf "${TMP_DIR}/etcd.tar.gz" -C "${TMP_DIR}"
  sudo cp "${TMP_DIR}/etcd-${ETCD_VER}-linux-amd64/etcdutl" /usr/local/bin/
  sudo chmod +x /usr/local/bin/etcdutl

  rm -rf "${TMP_DIR}"

  echo "[INFO] etcdutl installed successfully."
else
  echo "[INFO] etcdutl already present."
fi

echo "[INFO] Environment ready."
