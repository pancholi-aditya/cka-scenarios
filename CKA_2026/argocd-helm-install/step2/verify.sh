#!/bin/bash

if [ ! -f argo-helm.yaml ]; then
  echo "argo-helm.yaml not found"
  exit 1
fi

grep -q "argo-cd" argo-helm.yaml && grep -q "namespace: argocd" argo-helm.yaml

if [ $? -eq 0 ]; then
  echo "Helm templates rendered correctly"
  exit 0
else
  echo "Rendered manifest validation failed"
  exit 1
fi
