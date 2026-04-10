#!/bin/bash

kubectl get deployment wordpress -n wordpress \
  -o jsonpath='{.spec.replicas}' | grep -q '^0$'
