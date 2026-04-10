## Step 2: Restore ETCD

An ETCD snapshot already exists at: /opt/etcd-backup.db

---

### Task

Restore ETCD from this snapshot and ensure the cluster becomes healthy again.

---

<details>
<summary><strong>Solution</strong></summary>

## Stop ETCD (Static Pod)

```bash
> mv /etc/kubernetes/manifests/etcd.yaml /root/etcd.yaml.bak
```

## Restore the Snapshot

```bash

> export ETCDCTL_API=3

> etcdctl snapshot restore /opt/etcd-backup.db \
  --data-dir=/var/lib/etcd-restored

```

This creates a clean ETCD data directory containing the restored state.

## Step 3: Update the ETCD Static Pod Manifest

Edit the ETCD manifest:

```bash
> vi /root/etcd.yaml.bak
```

Locate the --data-dir argument and update it:

```yaml
--data-dir=/var/lib/etcd-restored
```

Ensure the corresponding volume mount allows access to this path.
If necessary, update the hostPath volume:

```yaml
- name: etcd-data
  hostPath:
    path: /var/lib/etcd-restored
    type: DirectoryOrCreate
```

Save the file.

## Step 4: Restart ETCD with Restored Data

Move the updated manifest back:

```bash
> mv /root/etcd.yaml.bak /etc/kubernetes/manifests/etcd.yaml
```

The kubelet will automatically restart ETCD using the restored snapshot.

## Step 5: Verify Cluster Recovery

```bash
> kubectl get nodes
> kubectl -n etcd-test get configmap etcd-marker
```

The presence of the etcd-marker ConfigMap confirms that ETCD is running
from the restored data.
