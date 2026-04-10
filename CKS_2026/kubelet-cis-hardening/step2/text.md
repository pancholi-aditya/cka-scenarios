## Harden kubelet Authentication and Authorization

Fix all kubelet violations identified by kube-bench:

- Ensure that anonymous authentication is disabled.
- Ensure that authorization mode is not set to `AlwaysAllow`.
- Use Webhook authentication/authorization where possible.
- Restart the affected component so the new settings take effect.

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

Run kube-bench again to confirm the kubelet findings are remediated:

```bash
sudo kube-bench run --targets=node
```

</details>
