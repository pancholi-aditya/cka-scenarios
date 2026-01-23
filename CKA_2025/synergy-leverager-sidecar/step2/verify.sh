#!/bin/bash

kubectl get deployment synergy-leverager -o json | \
jq -e '
.spec.template.spec.containers[] |
select(.name=="sidecar") |
.image=="busybox:stable"
' >/dev/null 2>&1

if [ $? -eq 0 ]; then
  echo "Sidecar container exists with correct image"
  exit 0
else
  echo "Sidecar container is missing or misconfigured"
  exit 1
fi
