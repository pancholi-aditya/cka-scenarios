## Step 1 – Create PersistentVolumeClaim

Create a PersistentVolumeClaim named `mariadb` in the `mariadb` namespace.

### Requirements

- Requested storage: `250Mi`
- Must bind to the existing retained PersistentVolume

<details>
<summary><strong>Solution</strong></summary>

```bash
kubectl apply -n mariadb -f - <<EOF
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mariadb
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 250Mi
EOF
```
