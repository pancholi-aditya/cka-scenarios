# Prepare the System for Kubernetes

In this scenario, you must prepare the system for Kubernetes by
installing and configuring `cri-dockerd` and applying required
kernel networking parameters.

### Tasks

#### Set up cri-dockerd

- Install the Debian package:
  `/cri-dockerd_0.3.9.3-0.ubuntu-focal_amd64.deb`
- Enable and start the `cri-dockerd` systemd service

#### Configure system parameters

- net.bridge.bridge-nf-call-iptables = 1
- net.ipv6.conf.all.forwarding = 1
- net.ipv4.ip_forward = 1
- net.netfilter.nf_conntrack_max = 131072
