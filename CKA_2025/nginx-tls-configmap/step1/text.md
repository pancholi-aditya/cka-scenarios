## Restrict TLS to Version 1.3

The NGINX Deployment uses a ConfigMap for its TLS configuration.

Currently, both TLS 1.2 and TLS 1.3 are enabled.

---

### Your Task

- Modify the ConfigMap to **disable TLS 1.2**
- Allow **only TLS 1.3**
- Apply the configuration changes
- Ensure NGINX reloads the updated configuration

After your changes:

- TLS 1.3 connections must succeed
- TLS 1.2 connections must fail

<details>
<summary><strong>Solution</strong></summary>

### Step 1: Edit the ConfigMap

Inspect the existing ConfigMap:

```bash
kubectl -n tls-nginx get configmap nginx-tls-config -o yaml > nginx-tls-config.yaml
```

open file

```bash
vim nginx-tls-config.yaml
```

Locate the following line in the NGINX configuration:

```yaml
ssl_protocols TLSv1.2 TLSv1.3;
```

Update it to allow only TLS 1.3:

```yaml
ssl_protocols TLSv1.3;
```

Apply the updated ConfigMap:

```bash
kubectl -n tls-nginx apply -f nginx-tls-config.yaml
```

### Step 2: Reload NGINX Configuration

Because the TLS configuration is read at startup, restart the Deployment
to ensure NGINX loads the updated ConfigMap:

```bash
kubectl -n tls-nginx rollout restart deployment nginx
```

Wait for the rollout to complete:

```bash
kubectl -n tls-nginx rollout status deployment nginx
```

### Step 3: Verify TLS Versions

Identify the NodePort used by the NGINX Service:

```Bash
kubectl -n tls-nginx get svc nginx-svc
```

Verify TLS 1.3 (Should Succeed)

```bash
echo | openssl s_client -connect <NODE_IP>:<NODE_PORT> -tls1_3
```

The output should indicate a successful handshake using TLSv1.3.

Verify TLS 1.2 (Should Fail)

```bash
echo | openssl s_client -connect <NODE_IP>:<NODE_PORT> -tls1_2
```

The connection should fail or terminate during the handshake, confirming
that TLS 1.2 is no longer supported.

## Explanation

The ssl_protocols directive controls which TLS versions NGINX accepts.

Removing TLSv1.2 ensures that older, less secure protocols are disabled.

Restarting the Deployment is required because NGINX does not dynamically
reload TLS protocol settings from a ConfigMap.

Successful TLS 1.3 and failed TLS 1.2 handshakes confirm correct behavior.
