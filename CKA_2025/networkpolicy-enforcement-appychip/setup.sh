#!/bin/bash
set -e

# Install Calico for NetworkPolicy enforcement
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
kubectl -n kube-system rollout status daemonset/calico-node --timeout=180s

# Create namespaces
kubectl create namespace appychip || true
kubectl create namespace outsider || true

# Create test Pods inside appychip
kubectl -n appychip apply -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: appy-pod
  labels:
    app: appy
spec:
  containers:
  - name: nginx
    image: nginx
    ports:
    - containerPort: 80
EOF

# Create test Pod outside namespace
kubectl -n outsider apply -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: outsider-pod
spec:
  containers:
  - name: busybox
    image: busybox
    command: ["sleep", "3600"]
EOF

kubectl -n appychip wait --for=condition=Ready pod/appy-pod --timeout=120s
kubectl -n outsider wait --for=condition=Ready pod/outsider-pod --timeout=120s
