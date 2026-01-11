#!/bin/bash

value=$(kubectl get deployment busybox-logger -n priority \
-o jsonpath='{.spec.template.spec.priorityClassName}')

if [ "$value" = "high-priority" ]; then
  echo "Deployment patched with correct PriorityClass"
  exit 0
else
  echo "Deployment does not use high-priority"
  exit 1
fi
