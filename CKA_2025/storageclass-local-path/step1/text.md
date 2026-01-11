## Step 1 – Create Default StorageClass

Create a StorageClass with the following requirements:

- Name: `local-path`
- Provisioner: `rancher.io/local-path`
- volumeBindingMode: `WaitForFirstConsumer`
- Must be configured as the default StorageClass

Do not modify any existing Deployments or PersistentVolumeClaims.
