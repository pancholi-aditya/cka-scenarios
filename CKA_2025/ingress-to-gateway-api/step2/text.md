## Step 2 – Create HTTPRoute

Create an HTTPRoute named `web-route`.

### Requirements

- Hostname: `gateway.web.k8s.local`
- Must preserve routing behavior from the Ingress

<details>
<summary><strong>Solution</strong></summary>

```yaml
kubectl apply -n web -f - <<EOF
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: web-route
spec:
  parentRefs:
  - name: web-gateway
  hostnames:
  - gateway.web.k8s.local
  rules:
  - matches:
    - path:
        type: PathPrefix
        value: /
    backendRefs:
    - name: web-service
      port: 80
EOF
```
