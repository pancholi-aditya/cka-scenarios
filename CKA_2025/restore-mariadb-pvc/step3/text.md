## Step 3 – Apply and Verify Deployment

Apply the updated Deployment manifest and ensure that
the MariaDB Pods are running successfully.

<details>
<summary><strong>Solution</strong></summary>

Apply the updated Deployment:

```bash
kubectl apply -f /mariadb-deployment.yaml
```

Verify that the Deployment is running:

```bash
> kubectl get deployment -n mariadb
> kubectl get pods -n mariadb
```
