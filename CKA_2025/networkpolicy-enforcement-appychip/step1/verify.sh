#!/bin/bash
set -e

# Policy must exist
kubectl -n appychip get networkpolicy my-policy >/dev/null

# Must apply to all pods
kubectl -n appychip get networkpolicy my-policy \
  -o jsonpath='{.spec.podSelector}' | grep '{}' >/dev/null

# Must allow only port 80
kubectl -n appychip get networkpolicy my-policy \
  -o jsonpath='{.spec.ingress[0].ports[0].port}' | grep 80 >/dev/null

# Must not allow namespaceSelector (no external access)
kubectl -n appychip get networkpolicy my-policy \
  -o jsonpath='{.spec.ingress[*].from[*].namespaceSelector}' | grep -q '^$'