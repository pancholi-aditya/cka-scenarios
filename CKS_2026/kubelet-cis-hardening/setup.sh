#!/bin/bash
set -e

echo "[SETUP] Preparing insecure kubelet configuration..."

KUBELET_CONFIG=/var/lib/kubelet/config.yaml
BACKUP_CONFIG=/var/lib/kubelet/config.yaml.cks-cis.bak
PID_MARKER=/opt/course/kubelet-cis-insecure-mainpid

mkdir -p /opt/course

if [ ! -f "$BACKUP_CONFIG" ]; then
  cp "$KUBELET_CONFIG" "$BACKUP_CONFIG"
fi

python3 - <<'PY'
from pathlib import Path

path = Path("/var/lib/kubelet/config.yaml")
text = path.read_text()
lines = text.splitlines()

section = None
inside_anonymous = False
for i, line in enumerate(lines):
    stripped = line.strip()

    if line and not line.startswith((" ", "\t")):
        section = stripped.rstrip(":")
        inside_anonymous = False

    if section == "authentication":
        if stripped == "anonymous:":
            inside_anonymous = True
            continue
        if inside_anonymous and stripped.startswith("enabled:"):
            indent = line[: len(line) - len(line.lstrip())]
            lines[i] = f"{indent}enabled: true"
            inside_anonymous = False

    if section == "authorization" and stripped.startswith("mode:"):
        indent = line[: len(line) - len(line.lstrip())]
        lines[i] = f"{indent}mode: AlwaysAllow"

path.write_text("\n".join(lines) + "\n")
PY

systemctl restart kubelet
sleep 5

systemctl show -p MainPID --value kubelet > "$PID_MARKER"

echo "[SETUP] kubelet now has insecure settings for this exercise."
