## Step 2 – Update Resource Requests (With Calculation)

Before updating resource requests, determine how much CPU and memory
are available on the node.

### Required approach

1. Inspect the node's **allocatable** CPU and memory.
2. Reserve some resources to keep the node stable.
3. Divide the remaining resources evenly across **3 Pods**.
4. Use the same resource requests for:
   - All containers
   - All init containers

---

<details>
<summary><strong>Solution</strong></summary>

1.  Check node allocatable resources

```bash
kubectl describe node | grep -A5 Allocatable
```

Example output:

```yaml
Allocatable:
  cpu: 2000m
  memory: 4Gi
```

2.  Reserve overhead for node stability

    A safe and common practice is to reserve approximately:

        20–25% CPU

        20–25% memory

    Example reservation:

        CPU reserved: 500m

        Memory reserved: 1Gi

    Remaining allocatable:

        CPU: 2000m - 500m = 1500m

        Memory: 4Gi - 1Gi = 3Gi

3.  Divide remaining resources across 3 Pods

    CPU per Pod: 1500m / 3 = 500m

    Memory per Pod: 3Gi / 3 = 1Gi

4.  Apply identical resource requests

    Edit the Deployment:

    ```bash
    kubectl edit deployment wordpress -n wordpress
    ```

    Update all containers and init containers:

    ```yaml
    resources:
    requests:
      cpu: "500m"
      memory: "1Gi"
    ```

Ensure the values are identical everywhere.
