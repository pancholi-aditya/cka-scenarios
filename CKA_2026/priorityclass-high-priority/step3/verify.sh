#!/bin/bash

kubectl rollout status deployment busybox-logger -n priority \
--timeout=60s >/dev/null 2>&1

if [ $? -eq 0 ]; then
  echo "Deployment rollout successful"
  exit 0
else
  echo "Deployment rollout failed"
  exit 1
fi
