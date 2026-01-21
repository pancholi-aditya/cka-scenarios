## Step 3 – Verify Routing

Ensure that routing rules from the Ingress are preserved
and traffic is handled by the Gateway and HTTPRoute.

<details>
<summary><strong>Solution</strong></summary>

```bash
kubectl describe gateway web-gateway -n web
kubectl describe httproute web-route -n web
```
