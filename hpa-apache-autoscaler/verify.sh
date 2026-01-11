#!/bin/bash

set -e

# Check HPA exists
kubectl -n auto-scale get hpa apache-server >/dev/null 2>&1 \
  || { echo "HPA apache-server not found"; exit 1; }

# Check min/max replicas
MIN=$(kubectl -n auto-scale get hpa apache-server -o jsonpath='{.spec.minReplicas}')
MAX=$(kubectl -n auto-scale get hpa apache-server -o jsonpath='{.spec.maxReplicas}')

[[ "$MIN" == "1" ]] || { echo "minReplicas incorrect"; exit 1; }
[[ "$MAX" == "4" ]] || { echo "maxReplicas incorrect"; exit 1; }

# Check CPU target
CPU=$(kubectl -n auto-scale get hpa apache-server \
  -o jsonpath='{.spec.metrics[0].resource.target.averageUtilization}')

[[ "$CPU" == "50" ]] || { echo "CPU target incorrect"; exit 1; }

# Check stabilization window
WINDOW=$(kubectl -n auto-scale get hpa apache-server \
  -o jsonpath='{.spec.behavior.scaleDown.stabilizationWindowSeconds}')

[[ "$WINDOW" == "30" ]] || { echo "Downscale window incorrect"; exit 1; }

echo "✅ HPA configuration is correct"

