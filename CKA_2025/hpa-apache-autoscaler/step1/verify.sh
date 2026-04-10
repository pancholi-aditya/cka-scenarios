#!/bin/bash
set -e

# Check HPA exists
kubectl get hpa apache-server -n auto-scale >/dev/null 2>&1 || {
  echo "HPA apache-server not found in auto-scale namespace"
  exit 1
}

# Check target CPU utilization is 50%
CPU_TARGET=$(kubectl get hpa apache-server -n auto-scale \
  -o jsonpath='{.spec.metrics[0].resource.target.averageUtilization}')

if [ "$CPU_TARGET" != "50" ]; then
  echo "Expected CPU utilization target 50%, found ${CPU_TARGET}%"
  exit 1
fi

# Check scale target reference
TARGET_KIND=$(kubectl get hpa apache-server -n auto-scale \
  -o jsonpath='{.spec.scaleTargetRef.kind}')
TARGET_NAME=$(kubectl get hpa apache-server -n auto-scale \
  -o jsonpath='{.spec.scaleTargetRef.name}')

if [ "$TARGET_KIND" != "Deployment" ] || [ "$TARGET_NAME" != "apache-server" ]; then
  echo "HPA does not target Deployment apache-server"
  exit 1
fi

# Check scaleDown stabilization window
STABILIZATION_WINDOW=$(kubectl get hpa apache-server -n auto-scale \
  -o jsonpath='{.spec.behavior.scaleDown.stabilizationWindowSeconds}')

if [ "$STABILIZATION_WINDOW" != "300" ]; then
  echo "Expected scaleDown stabilization window 300s, found ${STABILIZATION_WINDOW:-none}"
  exit 1
fi

echo "HPA configuration including stabilization window verified successfully"
