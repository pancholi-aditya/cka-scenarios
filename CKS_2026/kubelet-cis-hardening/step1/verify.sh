#!/bin/bash
set -e

KUBELET_CONFIG=/var/lib/kubelet/config.yaml
PID_MARKER=/opt/course/kubelet-cis-insecure-mainpid

echo "[VERIFY] Checking anonymous authentication..."
python3 - <<'PY'
from pathlib import Path
import sys

text = Path("/var/lib/kubelet/config.yaml").read_text().splitlines()
section = None
inside_anonymous = False
for line in text:
    stripped = line.strip()
    if line and not line.startswith((" ", "\t")):
        section = stripped.rstrip(":")
        inside_anonymous = False
    if section == "authentication" and stripped == "anonymous:":
        inside_anonymous = True
        continue
    if section == "authentication" and inside_anonymous and stripped.startswith("enabled:"):
        if stripped != "enabled: false":
            print("anonymous authentication must be disabled")
            sys.exit(1)
        sys.exit(0)

print("anonymous authentication setting not found")
sys.exit(1)
PY

echo "[VERIFY] Checking webhook authentication..."
python3 - <<'PY'
from pathlib import Path
import sys

text = Path("/var/lib/kubelet/config.yaml").read_text().splitlines()
section = None
inside_webhook = False
for line in text:
    stripped = line.strip()
    if line and not line.startswith((" ", "\t")):
        section = stripped.rstrip(":")
        inside_webhook = False
    if section == "authentication" and stripped == "webhook:":
        inside_webhook = True
        continue
    if section == "authentication" and inside_webhook and stripped.startswith("enabled:"):
        if stripped != "enabled: true":
            print("webhook authentication must be enabled")
            sys.exit(1)
        sys.exit(0)

print("webhook authentication setting not found")
sys.exit(1)
PY

echo "[VERIFY] Checking authorization mode..."
python3 - <<'PY'
from pathlib import Path
import sys

text = Path("/var/lib/kubelet/config.yaml").read_text().splitlines()
section = None
for line in text:
    stripped = line.strip()
    if line and not line.startswith((" ", "\t")):
        section = stripped.rstrip(":")
    if section == "authorization" and stripped.startswith("mode:"):
        if stripped != "mode: Webhook":
            print("authorization mode must be Webhook")
            sys.exit(1)
        sys.exit(0)

print("authorization mode setting not found")
sys.exit(1)
PY

echo "[VERIFY] Checking kubelet restart..."
if [ -f "$PID_MARKER" ]; then
  OLD_PID=$(cat "$PID_MARKER")
  CURRENT_PID=$(systemctl show -p MainPID --value kubelet)
  if [ "$OLD_PID" = "$CURRENT_PID" ]; then
    echo "kubelet must be restarted after changing the configuration"
    exit 1
  fi
fi

echo "[VERIFY] Checking kubelet and cluster health..."
systemctl is-active --quiet kubelet
kubectl get nodes >/dev/null

echo "[VERIFY] kubelet CIS findings are remediated."
