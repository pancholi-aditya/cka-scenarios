#!/bin/bash
set -e

# Remove Flannel if present
kubectl delete daemonset kube-flannel-ds -n kube-system --ignore-not-found >/dev/null 2>&1
kubectl delete configmap kube-flannel-cfg -n kube-system --ignore-not-found >/dev/null 2>&1

# Remove Calico if present
kubectl delete deployment tigera-operator -n tigera-operator --ignore-not-found >/dev/null 2>&1
kubectl delete namespace calico-system --ignore-not-found >/dev/null 2>&1
kubectl delete crd $(kubectl get crd -o name | grep projectcalico.org || true) >/dev/null 2>&1 || true

# Remove Weave Net if present
kubectl delete daemonset weave-net -n kube-system --ignore-not-found >/dev/null 2>&1

# Allow time for cleanup (silent)
sleep 5
