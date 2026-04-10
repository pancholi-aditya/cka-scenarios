#!/bin/bash
set -e

# Remove cri-dockerd if present
systemctl stop cri-docker.service cri-docker.socket >/dev/null 2>&1 || true
systemctl disable cri-docker.service cri-docker.socket >/dev/null 2>&1 || true
rm -f /usr/bin/cri-dockerd >/dev/null 2>&1 || true
rm -f /etc/systemd/system/cri-docker.service >/dev/null 2>&1 || true
rm -f /etc/systemd/system/cri-docker.socket >/dev/null 2>&1 || true
systemctl daemon-reload >/dev/null 2>&1 || true

# Reset sysctl parameters (intentionally unset)
sysctl -w net.bridge.bridge-nf-call-iptables=0 >/dev/null 2>&1 || true
sysctl -w net.ipv6.conf.all.forwarding=0 >/dev/null 2>&1 || true
sysctl -w net.ipv4.ip_forward=0 >/dev/null 2>&1 || true

# Remove persistent sysctl configs if present
rm -f /etc/sysctl.d/99-kubernetes-cri.conf >/dev/null 2>&1 || true
rm -f /etc/sysctl.d/k8s.conf >/dev/null 2>&1 || true


wget https://github.com/Mirantis/cri-dockerd/releases/download/v0.3.9/cri-dockerd_0.3.9.3-0.ubuntu-focal_amd64.deb -O /cri-dockerd_0.3.9.3-0.ubuntu-focal_amd64.deb
