# kube-bench kubelet CIS Remediation

A kubeadm-provisioned Kubernetes cluster must be checked with `kube-bench`.

Use the CIS Benchmark findings from `kube-bench` to identify insecure kubelet
settings, update the kubelet configuration, and restart the affected component
so the secure settings take effect.

Use the available Kubernetes documentation for kubeadm, kubelet, and etcd if
needed.
