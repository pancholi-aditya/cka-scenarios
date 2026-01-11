#!/bin/bash

pods=$(kubectl get pods -n spline-reticulator -l app=front-end --no-headers 2>/dev/null | wc -l)

if [ "$pods" -ge 1 ]; then
  echo "Service is selecting front-end Pods correctly"
  exit 0
else
  echo "Service is NOT selecting any Pods"
  exit 1
fi
