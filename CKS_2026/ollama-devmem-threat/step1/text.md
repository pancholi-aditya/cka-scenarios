## Identify and Stop the Threat

A Pod is misbehaving and poses a security threat to the system.

One of the Pods belonging to the application `ollama` is directly accessing the
system's memory by reading from the sensitive file `/dev/mem`.

First, identify the misbehaving Pod that is accessing `/dev/mem`.

Falco-style messages are available in:

```bash
/var/log/falco.log
```

The cluster uses Docker Engine as its container runtime. If needed, use the
`docker` command to troubleshoot running containers. Use Docker to inspect the
running containers and identify the offending Pod.

Next, identify the Deployment managing the misbehaving Pod and scale it to zero
replicas.

Constraints:

- Do not modify the Deployment except for scaling it.
- Do not modify any other Deployments.
- Do not delete any Deployments.

---

<details>
<summary><strong>Solution</strong></summary>

Check the Falco messages:

```bash
tail -f /var/log/falco.log
```

List the `ollama` Pods:

```bash
kubectl get pods -n ollama
```

Use Docker to inspect the running workloads and find the suspicious container:

```bash
docker ps | grep ollama
docker logs <container-id>
```

Then map the Pod back to its Deployment:

```bash
kubectl get pod -n ollama <pod-name> --show-labels
kubectl get deployment -n ollama --show-labels
```

The bad Pod belongs to the Deployment accessing `/dev/mem`, managed by `amd`.

Scale only that Deployment to zero:

```bash
kubectl scale deployment -n ollama amd --replicas=0
```

Verify the remaining Deployments are still running:

```bash
kubectl get deployment -n ollama
kubectl get pods -n ollama
```

</details>
