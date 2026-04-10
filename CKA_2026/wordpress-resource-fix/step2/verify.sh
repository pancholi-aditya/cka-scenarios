#!/bin/bash
set -e

to_millicores() {
  local value="$1"
  if [[ "$value" == *m ]]; then
    echo "${value%m}"
  else
    echo $((value * 1000))
  fi
}

to_mib() {
  local value="$1"
  case "$value" in
    *Ki) echo $((${value%Ki} / 1024)) ;;
    *Mi) echo "${value%Mi}" ;;
    *Gi) echo $((${value%Gi} * 1024)) ;;
    *) echo "$value" ;;
  esac
}

NODE=$(kubectl get nodes -o jsonpath='{.items[0].metadata.name}')

ALLOC_CPU=$(kubectl get node "$NODE" -o jsonpath='{.status.allocatable.cpu}')
ALLOC_MEM=$(kubectl get node "$NODE" -o jsonpath='{.status.allocatable.memory}')

ALLOC_CPU_MC=$(to_millicores "$ALLOC_CPU")
ALLOC_MEM_MI=$(to_mib "$ALLOC_MEM")

REQ_CPU=$(kubectl get deployment wordpress -n wordpress \
  -o jsonpath='{.spec.template.spec.containers[0].resources.requests.cpu}')

REQ_MEM=$(kubectl get deployment wordpress -n wordpress \
  -o jsonpath='{.spec.template.spec.containers[0].resources.requests.memory}')

REQ_CPU_MC=$(to_millicores "$REQ_CPU")
REQ_MEM_MI=$(to_mib "$REQ_MEM")

TOTAL_REQ_CPU=$((REQ_CPU_MC * 3))
TOTAL_REQ_MEM=$((REQ_MEM_MI * 3))

CPU_PERCENT=$((TOTAL_REQ_CPU * 100 / ALLOC_CPU_MC))
MEM_PERCENT=$((TOTAL_REQ_MEM * 100 / ALLOC_MEM_MI))

kubectl get deployment wordpress -n wordpress -o json | \
  jq -e '
    .spec.template.spec.initContainers[].resources.requests ==
    .spec.template.spec.containers[].resources.requests
  ' >/dev/null

if [ "$CPU_PERCENT" -lt 90 ] && [ "$MEM_PERCENT" -lt 90 ]; then
  exit 0
fi

echo "Resource requests are too high for 3 replicas with node overhead preserved"
exit 1
