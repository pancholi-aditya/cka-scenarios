#!/bin/bash
set -eux

echo "SETUP_RAN_AT=$(date)" | tee /tmp/SETUP_RAN


kubectl wait --for=condition=Ready nodes --all --timeout=60s

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
        command: ["/bin/sh", "-c", "echo started >> /var/log/app.log && sleep 3600"]
      volumes:
      - name: log-volume
        emptyDir: {}
EOF

kubectl rollout status deploy/synergy-leverager --timeout=60s
echo "Setup complete."