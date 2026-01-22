## Restore the Cluster to a Healthy State

After a migration, the Kubernetes cluster is no longer working correctly.
Some control plane components are down, and the API server is unreachable.

---

## Task

Troubleshoot the cluster and restore it to a healthy state.

You should:

- Identify which control plane component is failing
- Determine why it is not running
- Apply the appropriate fix
- Verify that the cluster is healthy again

---

<details>
<summary><strong>Solution</strong></summary>

### Step 1: Check Cluster Status

Attempt to access the cluster:

```bash
kubectl get nodes
```

The command fails, indicating an API server issue.

### Step 2: Inspect Control Plane Pods

Control plane components are managed as static Pods.

Check their status:

```bash
crictl ps -a | grep kube
```

You should observe that kube-apiserver is not running correctly.

### Step 3: Inspect kube-apiserver Logs

```bash
crictl logs $(crictl ps -a | grep kube-apiserver | awk '{print $1}')
```

The logs indicate a networking or binding failure.

### Step 4: Inspect the Static Pod Manifest

Open the kube-apiserver manifest:

```bash
vi /etc/kubernetes/manifests/kube-apiserver.yaml
```

Look for the following flag:

```yaml
--advertise-address=10.255.255.1
```

This IP address is invalid for the control plane node and was introduced
during migration.

### Step 5: Fix the Advertise Address

Update the flag to use the correct node IP, for example:

```yaml
--advertise-address=<NODE_INTERNAL_IP>
```

Save the file and exit.

The kubelet will automatically restart the kube-apiserver Pod.

### Step 6: Verify Cluster Recovery

Wait a few seconds, then verify:

```bash
> kubectl get nodes
> kubectl get pods -n kube-system
```

All control plane components should now be running, and the cluster
should respond normally.
