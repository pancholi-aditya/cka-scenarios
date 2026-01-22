## Step 2 – Configure Kernel Networking Parameters

Configure the following system parameters so they persist:

- net.bridge.bridge-nf-call-iptables = 1
- net.ipv6.conf.all.forwarding = 1
- net.ipv4.ip_forward = 1
- net.netfilter.nf_conntrack_max = 131072

<details>
<summary><strong>Solution</strong></summary>

Create a persistent sysctl configuration file:

```yaml
cat <<EOF | tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables = 1
net.ipv6.conf.all.forwarding = 1
net.ipv4.ip_forward = 1
net.netfilter.nf_conntrack_max = 131072
EOF
```

Apply the settings:

```bash
sysctl --system
```
