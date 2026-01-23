#!/bin/bash

kubectl get deployment synergy-leverager -o json | \
jq -e '
.spec.template.spec.volumes[]?.name == "log-volume"
and
.spec.template.spec.containers[].volumeMounts[]?.mountPath == "/var/log"
' >/dev/null 2>&1

if [ $? -eq 0 ]; then
  echo "Shared volume correctly configured"
  exit 0
else
  echo "Shared volume is missing or incorrectly mounted"
  exit 1
fi
