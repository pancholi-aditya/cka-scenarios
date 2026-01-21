## Step 1 – Create Gateway

Create a Gateway named `web-gateway` using the `nginx` GatewayClass.

### Requirements

- Hostname: `gateway.web.k8s.local`
- HTTPS listener
- Use the same TLS secret as the Ingress

<details>
<summary><strong>Solution</strong></summary>

```yaml

kubectl apply -n web -f - <<EOF
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: web-gateway
spec:
  gatewayClassName: nginx
  listeners:
  - name: https
    protocol: HTTPS
    port: 443
    hostname: gateway.web.k8s.local
    tls:
      mode: Terminate
      certificateRefs:
      - kind: Secret
        name: web-tls
EOF
```
