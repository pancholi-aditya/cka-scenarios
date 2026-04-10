#!/bin/bash

pod=$(kubectl get pods -l app=synergy-leverager -o jsonpath='{.items[0].metadata.name}')

kubectl exec "$pod" -c sidecar -- \
sh -c 'test -f /var/log/synergy-leverager.log' >/dev/null 2>&1

if [ $? -eq 0 ]; then
  echo "Sidecar can access synergy-leverager.log"
  exit 0
else
  echo "Sidecar cannot access the log file"
  exit 1
fi
