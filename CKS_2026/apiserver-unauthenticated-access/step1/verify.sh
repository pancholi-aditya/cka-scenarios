#!/bin/bash
set -e

MANIFEST=/etc/kubernetes/manifests/kube-apiserver.yaml
VERIFY_KUBECONFIG=/opt/course/admin.conf

echo "[VERIFY] Checking kube-apiserver flags..."
python3 - <<'PY'
from pathlib import Path
import sys

flags = {}
for raw_line in Path("/etc/kubernetes/manifests/kube-apiserver.yaml").read_text().splitlines():
    line = raw_line.strip()
    if line.startswith("- --") and "=" in line:
        key, value = line[4:].split("=", 1)
        flags[key] = value

if flags.get("anonymous-auth") != "false":
    print("--anonymous-auth must be set to false")
    sys.exit(1)

if flags.get("authorization-mode") != "Node,RBAC":
    print("--authorization-mode must be set to Node,RBAC")
    sys.exit(1)

admission_plugins = [
    plugin.strip()
    for plugin in flags.get("enable-admission-plugins", "").split(",")
    if plugin.strip()
]

if "NodeRestriction" not in admission_plugins:
    print("NodeRestriction must be enabled in --enable-admission-plugins")
    sys.exit(1)
PY

echo "[VERIFY] Checking API server health with admin kubeconfig..."
if [ ! -s "$VERIFY_KUBECONFIG" ]; then
  VERIFY_KUBECONFIG=/etc/kubernetes/admin.conf
fi

KUBECONFIG="$VERIFY_KUBECONFIG" kubectl get nodes >/dev/null
KUBECONFIG="$VERIFY_KUBECONFIG" kubectl -n kube-system get pods \
  -l component=kube-apiserver | grep Running >/dev/null

echo "[VERIFY] kube-apiserver access has been secured."
