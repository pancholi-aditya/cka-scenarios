## Step 1 – Expose Container Port

Reconfigure the existing **front-end** Deployment so that the **nginx container exposes port 80/TCP**.

### Requirements

- Deployment name: `front-end`
- Container: `nginx`
- Container port: `80`
- Namespace: `spline-reticulator`

---

## Solution

Edit the existing Deployment:

```bash
kubectl -n spline-reticulator edit deployment front-end
```

Add the container port configuration to the nginx container:

```yaml
spec:
  template:
    spec:
      containers:
        - name: nginx
          ports:
            - containerPort: 80
              protocol: TCP
```
