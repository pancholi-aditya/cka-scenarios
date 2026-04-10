## Step 4 – Verify Argo CD Installation

Verify that Argo CD has been installed successfully and that
all required components are running in the `argocd` namespace.

---

<details>
<summary><strong>Solution</strong></summary>

Check that the Argo CD Pods are created in the `argocd` namespace:

```bash
> kubectl get pods -n argocd
> kubectl get deployment -n argocd argocd-server
> kubectl rollout status deployment argocd-server -n argocd
```

</details>
