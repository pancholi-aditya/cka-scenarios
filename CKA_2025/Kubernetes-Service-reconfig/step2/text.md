## Step 2 – Create NodePort Service

Create a Service named **front-end-svc** that exposes the **front-end** Pods.

### Requirements

- Service name: `front-end-svc`
- Port: `80`
- TargetPort: `80`
- Type: `NodePort`
- Namespace: `spline-reticulator`

---

<details>
<summary><strong>Solution</strong></summary>

Create the Service using a manifest:

```bash
kubectl -n spline-reticulator apply -f - <<EOF
apiVersion: v1
kind: Service
metadata:
  name: front-end-svc
spec:
  type: NodePort
  selector:
    app: front-end
  ports:
  - port: 80
    targetPort: 80
    protocol: TCP
EOF
```

</details>
