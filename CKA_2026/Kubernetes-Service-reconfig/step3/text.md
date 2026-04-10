## Step 3 – Validate Pod Exposure

Ensure that the **front-end-svc** Service correctly selects the Pods created by the Deployment.

### Validation

- Service selector must match Pod labels
- Pods must be in **Running** state

---

<details>
<summary><strong>Solution</strong></summary>

Verify that the Service selector matches the Pod labels:

```bash
kubectl -n spline-reticulator get svc front-end-svc -o yaml
```

</details>
