#!/bin/bash

helm repo list | awk '{print $1}' | grep -w argo >/dev/null 2>&1

if [ $? -eq 0 ]; then
  echo "Argo CD Helm repository added"
  exit 0
else
  echo "Argo CD Helm repository not found"
  exit 1
fi
