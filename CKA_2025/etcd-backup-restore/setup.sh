#!/bin/bash
set -e

# Ensure cluster is reachable
kubectl get nodes >/dev/null

