#!/bin/bash

kubectl get deploy -n argocd argocd-server >/dev/null 2>&1

if [ $? -eq 0 ]; then
  echo "Argo CD resources applied"
  exit 0
else
  echo "Argo CD deployment not found"
  exit 1
fi
