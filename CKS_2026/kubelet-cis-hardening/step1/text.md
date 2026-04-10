## Check CIS Findings with kube-bench

You must connect to the correct host. Failure to do so may result in a zero
score.

The cluster is kubeadm-provisioned. Use `kube-bench` to find CIS Benchmark
issues against the kubelet.

Run the kube-bench node checks and save the output to:

```bash
/opt/course/kube-bench-report.txt
```

The initial kube-bench output is also saved here:

```bash
/opt/course/kube-bench-initial.txt
```

Use the kube-bench output to identify the following kubelet violations:

- Ensure that anonymous authentication is disabled.
- Ensure that authorization mode is not set to `AlwaysAllow`.
- Use Webhook authentication/authorization where possible.

The cluster uses Docker as its container runtime. If needed, use the `docker`
command to troubleshoot running containers.

---

<details>
<summary><strong>Solution</strong></summary>

Run kube-bench for the node checks and save the output:

```bash
sudo kube-bench run --targets=node | tee /opt/course/kube-bench-report.txt
```

You can also review the saved initial report:

```bash
cat /opt/course/kube-bench-initial.txt
```

Look for failed kubelet checks related to:

- `--anonymous-auth`
- `--authorization-mode`
- Webhook authentication/authorization

</details>
