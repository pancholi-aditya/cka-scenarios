## Step 3 – Verify Sidecar Log Access

Confirm that the sidecar container:

- Is running
- Has access to `/var/log/synergy-leverager.log`
- Is tailing the log file continuously

---

<details>
<summary><strong>Solution</strong></summary>

Identify the Pod created by the Deployment:

```bash
kubectl get pods -l app=synergy-leverager
```

Exec into the sidecar container and verify that the log file exists:

```bash
kubectl exec -it <pod-name> -c sidecar -- ls /var/log
```

Verify that the sidecar is actively tailing the log file:

```bash
kubectl exec -it <pod-name> -c sidecar -- ps
```
