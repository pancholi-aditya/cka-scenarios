## Expose the Service Using NGINX Ingress

The following resources already exist:

- **Namespace:** `sound-repeater`
- **Service:** `echoserver-service`
- **Service Port:** `8080`

---

## Task

Create an **NGINX Ingress** that satisfies the following requirements:

- Host: `www.example.org`
- Path: `/echo`
- Service: `echoserver-service`
- Service Port: `8080`
- External Port: `80`

---

<details>
<summary><strong>Solution</strong></summary>

### Step 1: Create the Ingress Resource

Create an Ingress in the `sound-repeater` namespace with the required
host- and path-based routing.

Example solution:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: echo-ingress
  namespace: sound-repeater
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /$1
spec:
  ingressClassName: nginx
  rules:
    - host: www.example.org
      http:
        paths:
          - path: /echo
            pathType: Prefix
            backend:
              service:
                name: echoserver-service
                port:
                  number: 8080
```

Apply the Ingress:

```bash
kubectl apply -f ingress.yaml
```

### Step 2: Verify the Ingress

Test access using the following command:

```bash
curl -o /dev/null -s -w "%{http_code}\n" http://example.org/echo
```

A successful configuration will return:

```bash
200
```
