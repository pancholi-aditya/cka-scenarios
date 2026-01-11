## Step 1 – Create Default StorageClass

Create a StorageClass with the following requirements:

- Name: `local-path`
- Provisioner: `rancher.io/local-path`
- volumeBindingMode: `WaitForFirstConsumer`
- Must be configured as the default StorageClass

Do not modify any existing Deployments or PersistentVolumeClaims.

---

<details>
<summary><strong>Solution</strong></summary>

Create the StorageClass using the following manifest:

```bash
kubectl apply -f - <<EOF
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: local-path
  annotations:
    storageclass.kubernetes.io/is-default-class: "true"
provisioner: rancher.io/local-path
volumeBindingMode: WaitForFirstConsumer
EOF
```
