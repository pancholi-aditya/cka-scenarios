#!/bin/bash
set -e

kubectl create namespace priority

kubectl apply -f - <<EOF
apiVersion: scheduling.k8s.io/v1
kind: PriorityClass
metadata:
  name: medium-priority
value: 10000000000000
globalDefault: false
description: "Existing user-defined priority"
EOF

kubectl apply -n priority -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: busybox-logger
spec:
  replicas: 1
  selector:
    matchLabels:
      app: busybox-logger
  template:
    metadata:
      labels:
        app: busybox-logger
    spec:
      containers:
      - name: busybox
        image: busybox:stable
        command:
        - /bin/sh
        - -c
        - |
          while true; do echo "logging"; sleep 5; done
EOF
