#!/bin/bash
set -e

kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: synergy-leverager
spec:
  replicas: 1
  selector:
    matchLabels:
      app: synergy-leverager
  template:
    metadata:
      labels:
        app: synergy-leverager
    spec:
      containers:
      - name: app
        image: nginx:1.25
        volumeMounts:
        - name: log-volume
          mountPath: /var/log
        command:
        - /bin/sh
        - -c
        - |
          echo "synergy leverager started" >> /var/log/synergy-leverager.log
          sleep 3600
      volumes:
      - name: log-volume
        emptyDir: {}
EOF
