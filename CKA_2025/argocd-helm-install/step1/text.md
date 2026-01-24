## Step 1 – Add Helm Repository

Add the official Argo CD Helm repository with the name `argo`.

https://argoproj.github.io/argo-helm

Ensure the repository is added successfully.

---

<details>
<summary><strong>Solution</strong></summary>

Add the Argo CD Helm repository:

```bash
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
helm repo list
```

</details>
