## Step 3 – Verify Deployment Rollout

Ensure that the `busybox-logger` Deployment has rolled out successfully
using the `high-priority` PriorityClass.

### Notes

- Pods from other Deployments in the `priority` namespace may be evicted.
- This behavior is expected and does not indicate a failure.

---

<details>
<summary><strong>Solution</strong></summary>

Check the rollout status of the Deployment:

```bash
kubectl rollout status deployment busybox-logger -n priority
```
