## Step 2 – Verify NetworkPolicy Support

Verify that Calico is installed and capable of enforcing
native Kubernetes NetworkPolicy.

<details>
<summary><strong>Solution</strong></summary>

1️⃣ Create test namespace and pods

```bash
> kubectl create namespace np-test

> kubectl run server -n np-test \
  --image=nginx \
  --labels=app=server

> kubectl expose pod server -n np-test \
  --port=80 --name=server-svc

> kubectl run client -n np-test \
  --image=busybox:1.28 \
  --restart=Never \
  --command -- sleep 3600
```

2️⃣ Apply deny-all NetworkPolicy

```yaml
kubectl apply -n np-test -f - <<EOF
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-all
spec:
  podSelector:
    matchLabels:
      app: server
  policyTypes:
  - Ingress
EOF
```

3️⃣ Verify traffic is blocked:

```bash
> kubectl exec -n np-test client -- \
  wget -qO- --timeout=3 server-svc
```
