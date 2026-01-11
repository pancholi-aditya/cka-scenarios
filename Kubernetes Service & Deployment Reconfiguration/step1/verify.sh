#!/bin/bash

kubectl get deployment front-end -n spline-reticulator -o json | \
jq -e '.spec.template.spec.containers[].ports[]?.containerPort == 80' >/dev/null 2>&1

if [ $? -eq 0 ]; then
  echo "Port 80 is exposed from the nginx container"
  exit 0
else
  echo "Container port 80 is NOT exposed"
  exit 1
fi
