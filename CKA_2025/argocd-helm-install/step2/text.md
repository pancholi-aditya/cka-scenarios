## Step 2 – Render Helm Templates

Render Helm templates for Argo CD with these requirements:

- Chart: argo/argo-cd
- Version: 7.7.3
- Namespace: argocd
- Do not install CRDs
- Save output to argo-helm.yaml

---

<details>
<summary><strong>Solution</strong></summary>

Render the Helm templates using the following command:

```bash
> helm template argocd argo/argo-cd \
  --version 7.7.3 \
  --namespace argocd \
  --set crds.install=false \

> argo-helm.yaml
```

</details>
