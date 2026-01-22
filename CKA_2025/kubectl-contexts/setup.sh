#!/bin/bash
set -e

# Ensure cluster access
kubectl config get-contexts >/dev/null

# Create required directory
mkdir -p /opt/course/1

# Clean old outputs
rm -f /opt/course/1/contexts
rm -f /opt/course/1/context_default_kubectl.sh
rm -f /opt/course/1/context_default_no_kubectl.sh
