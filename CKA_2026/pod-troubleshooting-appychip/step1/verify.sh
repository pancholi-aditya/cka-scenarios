#!/bin/bash
set -e

# Deployment must exist
kubectl get deployment appychip >/dev/null

# Replicas must be 2
kubectl get deployment appychip \
  -o jsonpath='{.spec.replicas}' | grep 2 >/dev/null

# All pods must be running
kubectl get pods -l app=appychip \
  -o jsonpath='{range .items[*]}{.status.phase}{"\n"}{end}' \
  | grep -v Running && exit 1 || true