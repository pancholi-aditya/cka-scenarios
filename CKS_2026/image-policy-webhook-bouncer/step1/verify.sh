#!/bin/bash
set -e

MANIFEST=/etc/kubernetes/manifests/kube-apiserver.yaml
ADMISSION_CONFIG=/etc/kubernetes/bouncer/admission-config.yaml
BACKEND_CONFIG=/etc/kubernetes/bouncer/backend-kubeconfig.yaml
SCANNER_LOG=/var/log/smooth-yak-scanner.log
TEST_MANIFEST=/home/candidate/vulnerable.yaml

echo "[VERIFY] Checking kube-apiserver admission flags..."
python3 - <<'PY'
from pathlib import Path
import sys

flags = {}
for raw_line in Path("/etc/kubernetes/manifests/kube-apiserver.yaml").read_text().splitlines():
    line = raw_line.strip()
    if line.startswith("- --") and "=" in line:
        key, value = line[4:].split("=", 1)
        flags[key] = value

if flags.get("admission-control-config-file") != "/etc/kubernetes/bouncer/admission-config.yaml":
    print("--admission-control-config-file must point to /etc/kubernetes/bouncer/admission-config.yaml")
    sys.exit(1)

plugins = [
    plugin.strip()
    for plugin in flags.get("enable-admission-plugins", "").split(",")
    if plugin.strip()
]

if "ImagePolicyWebhook" not in plugins:
    print("ImagePolicyWebhook must be enabled in --enable-admission-plugins")
    sys.exit(1)
PY

echo "[VERIFY] Checking ImagePolicyWebhook configuration..."
grep -q "defaultAllow: false" "$ADMISSION_CONFIG"

echo "[VERIFY] Checking backend scanner endpoint..."
grep -q "server: https://smooth-yak.local/review" "$BACKEND_CONFIG"
grep -q "certificate-authority: /etc/kubernetes/bouncer/ca.crt" "$BACKEND_CONFIG"

echo "[VERIFY] Checking scanner service..."
systemctl is-active --quiet smooth-yak-scanner.service

echo "[VERIFY] Checking API server health..."
kubectl get --raw=/readyz >/dev/null

echo "[VERIFY] Checking vulnerable image denial..."
set +e
OUTPUT=$(kubectl apply -f "$TEST_MANIFEST" 2>&1)
STATUS=$?
set -e

if [ "$STATUS" -eq 0 ]; then
  echo "The vulnerable image was admitted, but it should be denied."
  echo "$OUTPUT"
  kubectl delete -f "$TEST_MANIFEST" --ignore-not-found >/dev/null 2>&1 || true
  exit 1
fi

echo "$OUTPUT" | grep -Eiq "denied|image policy|smooth-yak|not allowed|admission"
grep -q "vulnerable/app:1.0" "$SCANNER_LOG"

echo "[VERIFY] ImagePolicyWebhook scanner integration is working."
