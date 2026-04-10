#!/bin/bash

highest=$(kubectl get priorityclass -o json | \
jq '[.items[] | select(.metadata.name!="system-cluster-critical" and .metadata.name!="system-node-critical") | .value] | max')

target=$((highest - 1))

actual=$(kubectl get priorityclass high-priority -o jsonpath='{.value}' 2>/dev/null)

if [ "$actual" = "$target" ]; then
  echo "PriorityClass high-priority correctly created"
  exit 0
else
  echo "PriorityClass value is incorrect or missing"
  exit 1
fi
