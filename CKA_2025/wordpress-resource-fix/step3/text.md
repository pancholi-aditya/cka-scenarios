## Step 3 – Scale Up and Verify Pods

Scale the Deployment back to 3 replicas and
ensure all Pods are Running and Ready.

<details>
<summary><strong>Solution</strong></summary>

```bash
> kubectl scale deployment wordpress -n wordpress --replicas=3
```
