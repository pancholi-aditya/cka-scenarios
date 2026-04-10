## Configure ImagePolicyWebhook

You must integrate a container image scanner into the kubeadm-provisioned
cluster.

Given an incomplete configuration located at:

```bash
/etc/kubernetes/bouncer
```

and a functional container image scanner with an HTTPS endpoint at:

```bash
https://smooth-yak.local/review
```

perform the following tasks to implement a validating admission controller:

- Reconfigure the API server to enable all admission plugin(s) required to
  support the provided `AdmissionConfiguration`.
- Reconfigure the `ImagePolicyWebhook` configuration to deny images on backend
  failure.
- Complete the backend configuration so it points to the scanner endpoint
  `https://smooth-yak.local/review`.
- Test the configuration by creating the resource defined in
  `/home/candidate/vulnerable.yaml`, which uses an image that should be denied.

You may delete and recreate the test resource as often as needed.

The container image scanner log file is located at:

```bash
/var/log/smooth-yak-scanner.log
```

---

<details>
<summary><strong>Solution</strong></summary>

Inspect the provided configuration:

```bash
ls -l /etc/kubernetes/bouncer
cat /etc/kubernetes/bouncer/admission-config.yaml
cat /etc/kubernetes/bouncer/backend-kubeconfig.yaml
```

Edit the admission configuration:

```bash
sudo vi /etc/kubernetes/bouncer/admission-config.yaml
```

Set backend failure handling to deny:

```yaml
defaultAllow: false
```

Edit the backend kubeconfig:

```bash
sudo vi /etc/kubernetes/bouncer/backend-kubeconfig.yaml
```

Set the scanner endpoint:

```yaml
server: https://smooth-yak.local/review
```

Edit the kube-apiserver static Pod manifest:

```bash
sudo vi /etc/kubernetes/manifests/kube-apiserver.yaml
```

Ensure the API server has the admission configuration flag:

```yaml
- --admission-control-config-file=/etc/kubernetes/bouncer/admission-config.yaml
```

Ensure `ImagePolicyWebhook` is enabled in `--enable-admission-plugins`. If the
flag already contains other admission plugins, add `ImagePolicyWebhook` to the
comma-separated list.

For example:

```yaml
- --enable-admission-plugins=NodeRestriction,ImagePolicyWebhook
```

Wait for the kube-apiserver static Pod to restart, then test the vulnerable Pod:

```bash
kubectl apply -f /home/candidate/vulnerable.yaml
```

The request should be denied by the scanner.

Check the scanner log if needed:

```bash
sudo tail -n 20 /var/log/smooth-yak-scanner.log
```

</details>
