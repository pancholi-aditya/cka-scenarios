## Pod Troubleshooting – appychip

A Pod named `appychip` using the `nginx` image is not running
in the `default` namespace.

---

## Task

1. Identify why the Pod is not running.
2. Fix the issue.
3. Ensure the **minimum required number of Pods** is maintained.

---

<details>
<summary><strong>Solution</strong></summary>

### Step 1: Check Pod Status

```bash
kubectl get pods
```

The Pods are in CrashLoopBackOff.

### Step 2: Describe the Pod

```bash
kubectl describe pod <appychip-pod-name>
```

The events indicate container startup failure.

### Step 3: Check Container Logs

```bash
kubectl logs <appychip-pod-name>
```

The logs show an invalid nginx configuration argument.

### Step 4: Fix the Deployment

Edit the Deployment:

```bash
kubectl edit deployment appychip
```

Locate the container command and arguments:

```yaml
command: ["nginx"]
args: ["-g", "daemon off;invalid"]
```

Fix it by removing the invalid argument:

```yaml
command: ["nginx"]
args: ["-g", "daemon off;"]
```

Save and exit.

### Step 5: Verify Pod Availability

```bash
kubectl get pods
```

Ensure both Pods are running
