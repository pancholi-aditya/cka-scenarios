# Configure Default StorageClass

In this scenario, you will configure Kubernetes storage by creating
a new StorageClass and setting it as the default.

### Objective

- Create a StorageClass named `local-path`
- Use the existing provisioner `rancher.io/local-path`
- Set `volumeBindingMode` to `WaitForFirstConsumer`
- Configure this StorageClass as the default

### Important Constraints

- Do NOT modify any existing Deployments
- Do NOT modify any existing PersistentVolumeClaims

Failure to follow these constraints may result in a reduced score.
