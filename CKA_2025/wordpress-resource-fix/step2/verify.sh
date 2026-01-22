
---

# ✅ UPDATED DYNAMIC VERIFICATION (NO HARDCODING)

## 📄 `step2/verify.sh` (FULL FILE)

This verification checks **logic**, not fixed numbers.

```bash
#!/bin/bash

# Get allocatable CPU (in millicores) and memory (in Ki)
NODE=$(kubectl get nodes -o jsonpath='{.items[0].metadata.name}')

ALLOC_CPU=$(kubectl get node "$NODE" -o jsonpath='{.status.allocatable.cpu}')
ALLOC_MEM=$(kubectl get node "$NODE" -o jsonpath='{.status.allocatable.memory}')

# Convert CPU to millicores
if [[ "$ALLOC_CPU" == *"m" ]]; then
  ALLOC_CPU_MC=${ALLOC_CPU%m}
else
  ALLOC_CPU_MC=$((ALLOC_CPU * 1000))
fi

# Convert memory to Mi
ALLOC_MEM_MI=$(( ${ALLOC_MEM%Ki} / 1024 ))

# Read requested resources from deployment
REQ_CPU=$(kubectl get deployment wordpress -n wordpress \
  -o jsonpath='{.spec.template.spec.containers[0].resources.requests.cpu}')

REQ_MEM=$(kubectl get deployment wordpress -n wordpress \
  -o jsonpath='{.spec.template.spec.containers[0].resources.requests.memory}')

# Convert requested CPU
REQ_CPU_MC=${REQ_CPU%m}

# Convert requested memory
REQ_MEM_MI=${REQ_MEM%Mi}

# Calculate total requested for 3 pods
TOTAL_REQ_CPU=$((REQ_CPU_MC * 3))
TOTAL_REQ_MEM=$((REQ_MEM_MI * 3))

# Ensure overhead exists (at least 10%)
CPU_OK=$((TOTAL_REQ_CPU * 100 / ALLOC_CPU_MC))
MEM_OK=$((TOTAL_REQ_MEM * 100 / ALLOC_MEM_MI))

# Verify identical requests in initContainers
kubectl get deployment wordpress -n wordpress -o json | \
jq -e '
.spec.template.spec.initContainers[].resources.requests ==
.spec.template.spec.containers[].resources.requests
' >/dev/null 2>&1 || exit 1

# Ensure total usage is below 90% (overhead preserved)
if [ "$CPU_OK" -lt 90 ] && [ "$MEM_OK" -lt 90 ]; then
  exit 0
else
  exit 1
fi
