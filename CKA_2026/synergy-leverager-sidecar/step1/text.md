## Step 1 – Shared Volume Verification

Ensure the existing Deployment uses a shared volume named `log-volume`
mounted at `/var/log`.

This volume must be accessible by all containers in the Pod.

---

<details>
<summary><strong>Solution</strong></summary>

Inspect the Deployment to verify that a shared volume is defined
and mounted at `/var/log`:

```bash
kubectl get deployment synergy-leverager -o yaml
```

Confirm that the Pod specification includes a volume named `log-volume`

```yaml
volumes:
  - name: log-volume
```

Verify that the volume is mounted at `/var/log` in the containers:

```yaml
volumeMounts:
  - name: log-volume
    mountPath: /var/log
```

If both the volume and the volume mount are present, the shared volume
is correctly configured and accessible to all containers in the Pod.
