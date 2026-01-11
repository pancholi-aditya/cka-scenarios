#!/bin/bash

set -e

kubectl create namespace auto-scale || true

kubectl -n auto-scale create deployment apache-server \
  --image=nginx \
  --replicas=1

kubectl -n auto-scale set resources deployment apache-server \
  --requests=cpu=100m \
  --limits=cpu=200m

