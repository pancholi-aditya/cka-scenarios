## Step 1 – Scale Down Deployment

Scale the WordPress Deployment to 0 replicas
before updating resource requests.

<details>
<summary><strong>Solution</strong></summary>

```bash
kubectl scale deployment wordpress -n wordpress --replicas=0
```
