## Step 2 – Patch Deployment

Patch the existing Deployment `busybox-logger`
to use the `high-priority` PriorityClass.

### Requirements

- Deployment: `busybox-logger`
- Namespace: `priority`
- priorityClassName: `high-priority`

---

<details>
<summary><strong>Solution</strong></summary>

Patch the Deployment to use the new PriorityClass:

```bash
> kubectl -n priority patch deployment busybox-logger \
  --type='merge' \
  -p '{"spec":{"template":{"spec":{"priorityClassName":"high-priority"}}}}'
```
