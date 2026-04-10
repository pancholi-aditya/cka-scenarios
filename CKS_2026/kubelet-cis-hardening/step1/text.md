## Harden kubelet Authentication and Authorization

You must connect to the correct host. Failure to do so may result in a zero
score.

The cluster is kubeadm-provisioned. A CIS Benchmark tool found issues against
the kubelet.

Fix all of the following kubelet violations:

- Ensure that anonymous authentication is disabled.
- Ensure that authorization mode is not set to `AlwaysAllow`.
- Use Webhook authentication/authorization where possible.
- Restart the affected component so the new settings take effect.

The cluster uses Docker as its container runtime. If needed, use the `docker`
command to troubleshoot running containers.

---

<details>
<summary><strong>Solution</strong></summary>

Inspect the kubelet configuration:

```bash
sudo vi /var/lib/kubelet/config.yaml
```

Set anonymous authentication to `false`:

```yaml
authentication:
  anonymous:
    enabled: false
```

Ensure webhook authentication is enabled:

```yaml
authentication:
  webhook:
    enabled: true
```

Set kubelet authorization to `Webhook`:

```yaml
authorization:
  mode: Webhook
```

Restart kubelet so the change takes effect:

```bash
sudo systemctl restart kubelet
```

Verify kubelet is running:

```bash
sudo systemctl status kubelet --no-pager
kubectl get nodes
```

</details>
