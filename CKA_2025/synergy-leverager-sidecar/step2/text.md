## Step 2 – Add Sidecar Container

Add a co-located sidecar container to the existing Deployment.

### Requirements

- Sidecar container name: `sidecar`
- Image: `busybox:stable`
- Command:
  `/bin/sh -c "tail -n+1 -f /var/log/synergy-leverager.log"`
- Mount the shared volume at `/var/log`

---

<details>
<summary><strong>Solution</strong></summary>

Edit the existing Deployment:

```bash
> kubectl edit deployment synergy-leverager
```

Add the following container definition under `spec.template.spec.containers`:

```yaml
- name: sidecar
  image: busybox:stable
  command:
    - /bin/sh
    - -c
    - tail -n+1 -f /var/log/synergy-leverager.log
  volumeMounts:
    - name: log-volume
      mountPath: /var/log
```

Save and exit the editor to apply the changes.

This adds a sidecar container that shares the log-volume and continuously
tails the application log file.
