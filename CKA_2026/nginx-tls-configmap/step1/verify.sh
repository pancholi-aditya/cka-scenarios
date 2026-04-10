#!/bin/bash
set -e

NS=tls-nginx
SVC=nginx-svc
NODE_PORT=$(kubectl -n $NS get svc $SVC -o jsonpath='{.spec.ports[0].nodePort}')
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')

echo "[VERIFY] Checking TLS 1.3 connection (should succeed)..."

if ! echo | openssl s_client -connect ${NODE_IP}:${NODE_PORT} -tls1_3 2>/dev/null | grep -q "TLSv1.3"; then
  echo "❌ TLS 1.3 connection failed"
  exit 1
fi

echo "[VERIFY] Checking TLS 1.2 connection (should fail)..."

if echo | openssl s_client -connect ${NODE_IP}:${NODE_PORT} -tls1_2 2>/dev/null | grep -q "TLSv1.2"; then
  echo "❌ TLS 1.2 is still enabled"
  exit 1
fi

echo "✅ TLS configuration is correct: only TLS 1.3 is allowed."
