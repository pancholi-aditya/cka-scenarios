#!/bin/bash

kubectl get pods -n argocd --no-headers 2>/dev/null | wc -l | grep -q '[1-9]'

if [ $? -eq 0 ]; then
  echo "Argo CD is installed and running"
  exit 0
else
  echo "Argo CD pods are not running"
  exit 1
fi
