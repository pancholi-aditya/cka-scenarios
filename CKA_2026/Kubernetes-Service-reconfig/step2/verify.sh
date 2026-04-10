#!/bin/bash

svc=$(kubectl get svc front-end-svc -n spline-reticulator -o json 2>/dev/null)

if [ -z "$svc" ]; then
  echo "Service front-end-svc does not exist"
  exit 1
fi

type=$(echo "$svc" | jq -r '.spec.type')
port=$(echo "$svc" | jq -r '.spec.ports[0].port')
targetPort=$(echo "$svc" | jq -r '.spec.ports[0].targetPort')

if [[ "$type" == "NodePort" && "$port" == "80" && "$targetPort" == "80" ]]; then
  echo "NodePort Service correctly configured"
  exit 0
else
  echo "Service configuration is incorrect"
  exit 1
fi
