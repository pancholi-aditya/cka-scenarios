#!/bin/bash
set -e

# User must exist via approved CSR
kubectl get csr ajeet | grep Approved >/dev/null

# RBAC permissions must be correct
kubectl auth can-i create pods \
  --as=ajeet \
  -n rbac-test | grep yes >/dev/null

kubectl auth can-i delete pods \
  --as=ajeet \
  -n rbac-test | grep yes >/dev/null

kubectl auth can-i get pods \
  --as=ajeet \
  -n rbac-test | grep yes >/dev/null