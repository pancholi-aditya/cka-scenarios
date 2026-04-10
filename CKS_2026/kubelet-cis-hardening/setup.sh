#!/bin/bash
set -e

echo "[SETUP] Preparing insecure kubelet configuration..."

KUBELET_CONFIG=/var/lib/kubelet/config.yaml
BACKUP_CONFIG=/var/lib/kubelet/config.yaml.cks-cis.bak
PID_MARKER=/opt/course/kubelet-cis-insecure-mainpid
INITIAL_REPORT=/opt/course/kube-bench-initial.txt
KUBE_BENCH_VERSION=0.14.0

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

install_local_kube_bench() {
  echo "[SETUP] Installing local kube-bench check helper."
  cat >/usr/local/bin/kube-bench <<'EOF'
#!/bin/bash
set -e

python3 - <<'PY'
from pathlib import Path

config = Path("/var/lib/kubelet/config.yaml").read_text().splitlines()

def nested_enabled(parent, child):
    section = None
    in_child = False
    for line in config:
        stripped = line.strip()
        if line and not line.startswith((" ", "\t")):
            section = stripped.rstrip(":")
            in_child = False
        if section == parent and stripped == f"{child}:":
            in_child = True
            continue
        if section == parent and in_child and stripped.startswith("enabled:"):
            return stripped.split(":", 1)[1].strip()
    return None

def authorization_mode():
    section = None
    for line in config:
        stripped = line.strip()
        if line and not line.startswith((" ", "\t")):
            section = stripped.rstrip(":")
        if section == "authorization" and stripped.startswith("mode:"):
            return stripped.split(":", 1)[1].strip()
    return None

anonymous = nested_enabled("authentication", "anonymous")
webhook = nested_enabled("authentication", "webhook")
mode = authorization_mode()

print("[INFO] 4 Worker Node Security Configuration")
print("[INFO] 4.2 Kubelet")

if anonymous == "false":
    print("[PASS] 4.2.1 Ensure that the --anonymous-auth argument is set to false")
else:
    print("[FAIL] 4.2.1 Ensure that the --anonymous-auth argument is set to false")

if mode == "Webhook":
    print("[PASS] 4.2.2 Ensure that the --authorization-mode argument is not set to AlwaysAllow")
else:
    print("[FAIL] 4.2.2 Ensure that the --authorization-mode argument is not set to AlwaysAllow")

if webhook == "true":
    print("[PASS] 4.2.3 Ensure that Webhook authentication is enabled")
else:
    print("[FAIL] 4.2.3 Ensure that Webhook authentication is enabled")
PY
EOF
  chmod +x /usr/local/bin/kube-bench
}

install_kube_bench() {
  if command -v kube-bench >/dev/null 2>&1; then
    return
  fi

  echo "[SETUP] Installing kube-bench..."
  local deb="/tmp/kube-bench_${KUBE_BENCH_VERSION}_linux_amd64.deb"
  if curl -fsSL \
    "https://github.com/aquasecurity/kube-bench/releases/download/v${KUBE_BENCH_VERSION}/kube-bench_${KUBE_BENCH_VERSION}_linux_amd64.deb" \
    -o "$deb"; then
    apt install -y "$deb" >/dev/null 2>&1 && return
  fi

  echo "[SETUP] kube-bench download failed."
  install_local_kube_bench
}

install_kube_bench

systemctl show -p MainPID --value kubelet > "$PID_MARKER"
kube-bench run --targets=node > "$INITIAL_REPORT" 2>&1 || true

if ! grep -q "anonymous-auth" "$INITIAL_REPORT" || ! grep -q "AlwaysAllow" "$INITIAL_REPORT"; then
  echo "[SETUP] kube-bench did not report the expected kubelet findings for this lab image."
  install_local_kube_bench
  kube-bench run --targets=node > "$INITIAL_REPORT" 2>&1 || true
fi

echo "[SETUP] kubelet now has insecure settings for this exercise."
echo "[SETUP] Initial kube-bench findings are available at $INITIAL_REPORT."
