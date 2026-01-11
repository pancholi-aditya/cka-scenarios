#!/bin/bash

sc=$(kubectl get storageclass local-path -o json 2>/dev/null)

if [ -z "$sc" ]; then
  echo "StorageClass local-path does not exist"
  exit 1
fi

provisioner=$(echo "$sc" | jq -r '.provisioner')
bindingMode=$(echo "$sc" | jq -r '.volumeBindingMode')
defaultClass=$(echo "$sc" | jq -r '.metadata.annotations["storageclass.kubernetes.io/is-default-class"]')

if [[ "$provisioner" == "rancher.io/local-path" && \
      "$bindingMode" == "WaitForFirstConsumer" && \
      "$defaultClass" == "true" ]]; then
  echo "StorageClass local-path correctly configured as default"
  exit 0
else
  echo "StorageClass configuration is incorrect"
  exit 1
fi
