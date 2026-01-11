## Step 2 – Create NodePort Service

Create a Service named **front-end-svc** that exposes the **front-end** Pods.

### Requirements

- Service name: `front-end-svc`
- Port: `80`
- TargetPort: `80`
- Type: `NodePort`
- Namespace: `spline-reticulator`
