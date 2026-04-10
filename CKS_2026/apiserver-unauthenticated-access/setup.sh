#!/bin/bash
set -e

echo "[SETUP] Preparing insecure kube-apiserver configuration..."

MANIFEST=/etc/kubernetes/manifests/kube-apiserver.yaml
BACKUP=/etc/kubernetes/manifests/kube-apiserver.yaml.cks-q2.bak
VERIFY_KUBECONFIG=/opt/course/admin.conf

mkdir -p /opt/course

if [ ! -f "$BACKUP" ]; then
  cp "$MANIFEST" "$BACKUP"
fi

cp /etc/kubernetes/admin.conf "$VERIFY_KUBECONFIG"

python3 - <<'PY'
from pathlib import Path

path = Path("/etc/kubernetes/manifests/kube-apiserver.yaml")
lines = path.read_text().splitlines()

def update_or_add_flag(flag, value):
    prefix = f"- --{flag}="
    replacement = f"    - --{flag}={value}"
    for i, line in enumerate(lines):
        if line.strip().startswith(prefix.strip()):
            indent = line[: len(line) - len(line.lstrip())]
            lines[i] = f"{indent}- --{flag}={value}"
            return

    command_index = None
    for i, line in enumerate(lines):
        if line.strip() == "- kube-apiserver":
            command_index = i
            break

    if command_index is None:
        raise SystemExit("could not find kube-apiserver command block")

    lines.insert(command_index + 1, replacement)

update_or_add_flag("anonymous-auth", "true")
update_or_add_flag("authorization-mode", "AlwaysAllow")
update_or_add_flag("enable-admission-plugins", "NamespaceLifecycle,LimitRanger,ServiceAccount")

path.write_text("\n".join(lines) + "\n")
PY

echo "[SETUP] Restarting kubelet to apply insecure API server state..."
systemctl restart kubelet
sleep 10

echo "[SETUP] kube-apiserver is intentionally insecure for this exercise."
