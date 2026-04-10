#!/bin/bash
set -e

kubectl delete storageclass local-path || true
# No setup required for this scenario.
# Existing Deployments and PVCs must remain untouched.
