# Install Argo CD Using Helm

In this scenario, you will install Argo CD using Helm by rendering
the chart templates and applying them manually.

### Tasks

- Add the official Argo CD Helm repository named `argo`
- Render Helm templates for Argo CD version `7.7.3`
- Use the `argocd` namespace
- Save the rendered output to `argo-helm.yaml`
- Ensure CRDs are NOT installed by Helm
- Install Argo CD by applying the rendered manifest

### Important Note

Argo CD CustomResourceDefinitions are already installed in the cluster.
Helm must not manage CRDs in this scenario.
