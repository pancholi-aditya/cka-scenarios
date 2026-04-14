#!/bin/bash
set -e

NS=ollama
STATE_DIR=/opt/course/ollama-threat
TARGET=amd
OTHERS="cpu nvidia"

echo "[VERIFY] Checking target deployment scale..."
TARGET_REPLICAS=$(kubectl -n "$NS" get deployment "$TARGET" -o jsonpath='{.spec.replicas}')
[ "$TARGET_REPLICAS" = "0" ]

echo "[VERIFY] Checking other deployments remain at one replica..."
for dep in $OTHERS; do
  replicas=$(kubectl -n "$NS" get deployment "$dep" -o jsonpath='{.spec.replicas}')
  if [ "$replicas" != "1" ]; then
    echo "$dep replicas changed unexpectedly"
    exit 1
  fi
done

echo "[VERIFY] Checking no target pods remain..."
if kubectl -n "$NS" get pods -l app=ollama,component=amd --no-headers 2>/dev/null | grep -q .; then
  echo "amd pods are still running"
  exit 1
fi

echo "[VERIFY] Checking deployment templates were not modified..."
python3 - <<'PY'
from pathlib import Path
import json
import subprocess
import sys

ns = "ollama"
state_dir = Path("/opt/course/ollama-threat")

def load_saved(name):
    data = json.loads((state_dir / f"{name}.json").read_text())
    return {
        "selector": data["spec"]["selector"],
        "template": data["spec"]["template"],
        "strategy": data["spec"].get("strategy"),
    }

def load_live(name):
    raw = subprocess.check_output(
        ["kubectl", "-n", ns, "get", "deployment", name, "-o", "json"],
        text=True,
    )
    data = json.loads(raw)
    return {
        "selector": data["spec"]["selector"],
        "template": data["spec"]["template"],
        "strategy": data["spec"].get("strategy"),
    }

for name in ["cpu", "nvidia", "amd"]:
    if load_saved(name) != load_live(name):
        print(f"{name} was modified beyond scaling")
        sys.exit(1)
PY

echo "[VERIFY] Misbehaving deployment was isolated correctly."
