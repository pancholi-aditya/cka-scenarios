## Step 1: Backup ETCD

The cluster uses **etcd** as its backing data store.

---

### Task

Create a backup of the ETCD database and save it to:/opt/etcd-backup.db

You must use **etcdctl** with the existing cluster certificates.

<details>
<summary><strong>Solution</strong></summary>

### Set ETCDCTL API Version

```bash
> export ETCDCTL_API=3
```

Take the Snapshot

```bash
> etcdctl snapshot save /opt/etcd-backup.db \
  --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key
```
