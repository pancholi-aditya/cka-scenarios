#!/bin/bash
set -e

echo "[SETUP] Preparing ImagePolicyWebhook scenario..."

BOUNCER_DIR=/etc/kubernetes/bouncer
MANIFEST=/etc/kubernetes/manifests/kube-apiserver.yaml
BACKUP=/etc/kubernetes/manifests/kube-apiserver.yaml.cks-image-policy.bak
SCANNER_SCRIPT=/usr/local/bin/smooth-yak-scanner.py
SCANNER_SERVICE=/etc/systemd/system/smooth-yak-scanner.service
SCANNER_LOG=/var/log/smooth-yak-scanner.log

mkdir -p "$BOUNCER_DIR" /home/candidate

if [ ! -f "$BACKUP" ]; then
  cp "$MANIFEST" "$BACKUP"
fi

echo "127.0.0.1 smooth-yak.local" >> /etc/hosts

openssl req -x509 -newkey rsa:2048 -nodes -days 365 \
  -subj "/CN=smooth-yak.local" \
  -addext "subjectAltName=DNS:smooth-yak.local" \
  -keyout "$BOUNCER_DIR/smooth-yak.key" \
  -out "$BOUNCER_DIR/ca.crt" >/dev/null 2>&1

cat > "$BOUNCER_DIR/admission-config.yaml" <<'EOF'
apiVersion: apiserver.config.k8s.io/v1
kind: AdmissionConfiguration
plugins:
- name: ImagePolicyWebhook
  configuration:
    imagePolicy:
      kubeConfigFile: /etc/kubernetes/bouncer/backend-kubeconfig.yaml
      allowTTL: 0
      denyTTL: 0
      retryBackoff: 500
      defaultAllow: true
EOF

cat > "$BOUNCER_DIR/backend-kubeconfig.yaml" <<'EOF'
apiVersion: v1
kind: Config
clusters:
- name: image-scanner
  cluster:
    certificate-authority: /etc/kubernetes/bouncer/ca.crt
    server: https://CHANGE-ME/review
contexts:
- name: image-scanner
  context:
    cluster: image-scanner
    user: image-scanner
current-context: image-scanner
users:
- name: image-scanner
  user: {}
EOF

cat > "$SCANNER_SCRIPT" <<'PY'
#!/usr/bin/env python3
from http.server import BaseHTTPRequestHandler, HTTPServer
import json
import ssl

LOG = "/var/log/smooth-yak-scanner.log"

class Handler(BaseHTTPRequestHandler):
    def log_message(self, fmt, *args):
        return

    def do_POST(self):
        length = int(self.headers.get("Content-Length", "0"))
        body = self.rfile.read(length)
        try:
            request = json.loads(body.decode("utf-8"))
        except Exception:
            request = {}

        containers = request.get("spec", {}).get("containers", [])
        images = [container.get("image", "") for container in containers]
        allowed = not any("vulnerable" in image for image in images)
        message = "image approved"
        if not allowed:
            message = "image denied by smooth-yak scanner"

        with open(LOG, "a", encoding="utf-8") as log:
            log.write(f"path={self.path} images={images} allowed={allowed}\n")

        response = {
            "apiVersion": "imagepolicy.k8s.io/v1alpha1",
            "kind": "ImageReview",
            "status": {
                "allowed": allowed,
                "reason": message,
            },
        }

        payload = json.dumps(response).encode("utf-8")
        self.send_response(200)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(payload)))
        self.end_headers()
        self.wfile.write(payload)

server = HTTPServer(("0.0.0.0", 443), Handler)
context = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
context.load_cert_chain(
    certfile="/etc/kubernetes/bouncer/ca.crt",
    keyfile="/etc/kubernetes/bouncer/smooth-yak.key",
)
server.socket = context.wrap_socket(server.socket, server_side=True)
server.serve_forever()
PY

chmod +x "$SCANNER_SCRIPT"
touch "$SCANNER_LOG"

cat > "$SCANNER_SERVICE" <<EOF
[Unit]
Description=Smooth Yak image scanner
After=network.target

[Service]
ExecStart=$SCANNER_SCRIPT
Restart=always
RestartSec=2

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now smooth-yak-scanner.service

cat > /home/candidate/vulnerable.yaml <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: vulnerable
  namespace: default
spec:
  containers:
  - name: vulnerable
    image: vulnerable/app:1.0
    command: ["sh", "-c", "sleep 3600"]
EOF

chown -R candidate:candidate /home/candidate 2>/dev/null || true

python3 - <<'PY'
from pathlib import Path

path = Path("/etc/kubernetes/manifests/kube-apiserver.yaml")
lines = path.read_text().splitlines()

def update_or_add_flag(flag, value):
    replacement = f"    - --{flag}={value}"
    for i, line in enumerate(lines):
        if line.strip().startswith(f"- --{flag}="):
            indent = line[: len(line) - len(line.lstrip())]
            lines[i] = f"{indent}- --{flag}={value}"
            return

    for i, line in enumerate(lines):
        if line.strip() == "- kube-apiserver":
            lines.insert(i + 1, replacement)
            return
    raise SystemExit("could not find kube-apiserver command block")

def ensure_volume_mount(name, mount_path):
    if any(f"name: {name}" in line for line in lines):
        return
    for i, line in enumerate(lines):
        if line.strip() == "volumeMounts:":
            insert_at = i + 1
            lines.insert(insert_at, f"    - mountPath: {mount_path}")
            lines.insert(insert_at + 1, f"      name: {name}")
            lines.insert(insert_at + 2, "      readOnly: true")
            return
    raise SystemExit("could not find kube-apiserver volumeMounts")

def ensure_volume(name, host_path):
    if any(f"name: {name}" in line for line in lines):
        return
    for i, line in enumerate(lines):
        if line.strip() == "volumes:":
            insert_at = i + 1
            lines.insert(insert_at, "  - hostPath:")
            lines.insert(insert_at + 1, f"      path: {host_path}")
            lines.insert(insert_at + 2, "      type: DirectoryOrCreate")
            lines.insert(insert_at + 3, f"    name: {name}")
            return
    raise SystemExit("could not find kube-apiserver volumes")

def ensure_host_alias(hostname, ip):
    if any(hostname in line for line in lines):
        return
    for i, line in enumerate(lines):
        if line.strip() == "containers:":
            lines.insert(i, "  hostAliases:")
            lines.insert(i + 1, f"  - ip: {ip}")
            lines.insert(i + 2, "    hostnames:")
            lines.insert(i + 3, f"    - {hostname}")
            return
    raise SystemExit("could not find kube-apiserver containers block")

update_or_add_flag("admission-control-config-file", "/etc/kubernetes/bouncer/admission-config.yaml")
update_or_add_flag("enable-admission-plugins", "NodeRestriction")
ensure_volume_mount("bouncer-config", "/etc/kubernetes/bouncer")
ensure_volume("bouncer-config", "/etc/kubernetes/bouncer")
ensure_host_alias("smooth-yak.local", "127.0.0.1")

path.write_text("\n".join(lines) + "\n")
PY

systemctl restart kubelet
sleep 10

echo "[SETUP] Incomplete configuration is in $BOUNCER_DIR."
echo "[SETUP] Scanner log file is $SCANNER_LOG."
