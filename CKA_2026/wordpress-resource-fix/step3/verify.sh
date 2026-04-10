#!/bin/bash
set -e

kubectl -n wordpress rollout status deployment/wordpress --timeout=120s

REPLICAS=$(kubectl -n wordpress get deployment wordpress -o jsonpath='{.spec.replicas}')
READY=$(kubectl -n wordpress get deployment wordpress -o jsonpath='{.status.readyReplicas}')
AVAILABLE=$(kubectl -n wordpress get deployment wordpress -o jsonpath='{.status.availableReplicas}')

[[ "$REPLICAS" == "3" ]] || {
  echo "Deployment must be scaled to 3 replicas"
  exit 1
}

[[ "$READY" == "3" && "$AVAILABLE" == "3" ]] || {
  echo "All 3 WordPress Pods must be Ready and Available"
  exit 1
}
