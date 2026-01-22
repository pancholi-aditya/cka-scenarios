#!/bin/bash
set -e

NS=backend
POLICY=backend-access

echo "[VERIFY] Checking NetworkPolicy existence..."
kubectl -n $NS get networkpolicy $POLICY >/dev/null

echo "[VERIFY] Checking podSelector..."
APP=$(kubectl -n $NS get networkpolicy $POLICY \
  -o jsonpath='{.spec.podSelector.matchLabels.app}')

[[ "$APP" == "backend" ]] || {
  echo "❌ Policy must target backend Pods"
  exit 1
}

echo "[VERIFY] Checking namespace + pod selectors..."

NS_SEL=$(kubectl -n $NS get networkpolicy $POLICY \
  -o jsonpath='{.spec.ingress[0].from[0].namespaceSelector.matchLabels.name}')

POD_SEL=$(kubectl -n $NS get networkpolicy $POLICY \
  -o jsonpath='{.spec.ingress[0].from[0].podSelector.matchLabels.app}')

[[ "$NS_SEL" == "frontend" ]] || {
  echo "❌ Namespace selector missing or incorrect"
  exit 1
}

[[ "$POD_SEL" == "frontend" ]] || {
  echo "❌ Pod selector missing or incorrect"
  exit 1
}

echo "[VERIFY] Ensuring no CIDR is used..."

CIDR=$(kubectl -n $NS get networkpolicy $POLICY \
  -o jsonpath='{.spec.ingress[*].from[*].ipBlock.cidr}' 2>/dev/null)

if [[ -n "$CIDR" ]]; then
  echo "❌ CIDR-based rule detected — not least privilege"
  exit 1
fi

echo "✅ Correct NetworkPolicy selected and applied."

mkdir -p /root/manifests
cd /root/manifests

cat <<EOF > np-option1.yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: backend-access
  namespace: backend
spec:
  podSelector:
    matchLabels:
      app: backend
  policyTypes:
  - Ingress
  ingress:
  - {}
EOF
cat <<EOF > np-option2.yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: backend-access
  namespace: backend
spec:
  podSelector:
    matchLabels:
      app: backend
  policyTypes:
  - Ingress
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          name: frontend
      podSelector:
        matchLabels:
          app: frontend
EOF
cat <<EOF > np-option3.yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: backend-access
  namespace: backend
spec:
  podSelector:
    matchLabels:
      app: backend
  policyTypes:
  - Ingress
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          name: frontend
      podSelector:
        matchLabels:
          app: frontend
      ipBlock:
        cidr: 10.244.0.0/16
EOF

echo "[SETUP] YAML options created in /root/manifests"
echo "[SETUP] Environment ready."
