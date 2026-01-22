
---

## 6️⃣ `step1/verify.sh`

This verification checks **real routing via the Ingress**.

```bash
#!/bin/bash
set -e

INGRESS_NS=sound-repeater
INGRESS_NAME=echo-ingress

echo "[VERIFY] Checking Ingress exists..."
kubectl -n $INGRESS_NS get ingress $INGRESS_NAME >/dev/null

echo "[VERIFY] Checking host rule..."
HOST=$(kubectl -n $INGRESS_NS get ingress $INGRESS_NAME \
  -o jsonpath='{.spec.rules[0].host}')

[[ "$HOST" == "www.example.org" ]] || {
  echo "❌ Incorrect host configured"
  exit 1
}

echo "[VERIFY] Checking backend service..."
SVC=$(kubectl -n $INGRESS_NS get ingress $INGRESS_NAME \
  -o jsonpath='{.spec.rules[0].http.paths[0].backend.service.name}')

PORT=$(kubectl -n $INGRESS_NS get ingress $INGRESS_NAME \
  -o jsonpath='{.spec.rules[0].http.paths[0].backend.service.port.number}')

[[ "$SVC" == "echoserver-service" ]] || {
  echo "❌ Incorrect service configured"
  exit 1
}

[[ "$PORT" == "8080" ]] || {
  echo "❌ Incorrect service port configured"
  exit 1
}

echo "[VERIFY] Testing HTTP response..."
CODE=$(curl -o /dev/null -s -w "%{http_code}" http://example.org/echo)

[[ "$CODE" == "200" ]] || {
  echo "❌ Expected HTTP 200, got $CODE"
  exit 1
}

echo "✅ Ingress is correctly configured."
