## Step 3 – Install Argo CD

Install Argo CD by applying the rendered Helm manifest.

Use `kubectl` to apply the contents of `argo-helm.yaml` to the cluster.

---

<details>
<summary><strong>Solution</strong></summary>

Apply the rendered Helm manifest to install Argo CD:

```bash
kubectl apply -f argo-helm.yaml
```

</details>
