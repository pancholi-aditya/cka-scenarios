#!/bin/bash
set -e

# Create cert-manager namespace
kubectl create namespace cert-manager 2>/dev/null || true

# Install cert-manager CRDs only (no controllers needed for this task)
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.14.4/cert-manager.crds.yaml >/dev/null 2>&1

# Create a dummy Certificate for inspection
kubectl apply -n cert-manager -f - <<EOF
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: example-cert
spec:
  secretName: example-tls
  commonName: example.com
  subject:
    organizations:
    - ExampleOrg
  issuerRef:
    name: dummy
    kind: Issuer
EOF
