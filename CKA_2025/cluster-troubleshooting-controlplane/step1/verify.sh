
---

## 6️⃣ `step1/verify.sh`  
(Checks **real recovery**, not commands)

```bash
#!/bin/bash
set -e

echo "[VERIFY] Checking API server availability..."
kubectl get nodes >/dev/null

echo "[VERIFY] Checking control plane Pods..."
kubectl -n kube-system get pods | grep kube-apiserver | grep Running >/dev/null

echo "[VERIFY] Cluster is healthy."
