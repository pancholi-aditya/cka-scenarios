#!/bin/bash
set -e

kubectl create namespace argocd 2>/dev/null || true

# CRDs are pre-installed as per exam condition
