## Step 1 – Expose Container Port

Reconfigure the existing **front-end** Deployment so that the **nginx container exposes port 80/TCP**.

### Requirements

- Deployment name: `front-end`
- Container: `nginx`
- Container port: `80`
- Namespace: `spline-reticulator`
