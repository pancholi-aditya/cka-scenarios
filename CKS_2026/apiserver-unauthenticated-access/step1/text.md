## Secure the Cluster API Server

For testing purposes, the kubeadm-provisioned cluster API server was configured
to allow unauthenticated and unauthorized access.

First, secure the cluster API server by configuring it as follows:

- Forbid anonymous authentication.
- Use authorization mode `Node,RBAC`.
- Use admission controller `NodeRestriction`.

The cluster uses Docker as its container runtime. If needed, use the `docker`
command to troubleshoot running containers.

`kubectl` is configured to use unauthenticated and unauthorized access. You do
not have to change it, but be aware that `kubectl` may stop working once you
have secured the cluster.

---

<details>
<summary><strong>Solution</strong></summary>

Edit the kube-apiserver static Pod manifest:

```bash
sudo vi /etc/kubernetes/manifests/kube-apiserver.yaml
```

Set or add the following flags:

```yaml
- --anonymous-auth=false
- --authorization-mode=Node,RBAC
- --enable-admission-plugins=NodeRestriction
```

If `--enable-admission-plugins` already exists, ensure `NodeRestriction` is
included. For this task, the final value may be set directly to
`NodeRestriction`.

Save the manifest. The kubelet will restart the kube-apiserver static Pod.

If the default `kubectl` context stops working, use the admin kubeconfig:

```bash
sudo KUBECONFIG=/etc/kubernetes/admin.conf kubectl get nodes
```

</details>
