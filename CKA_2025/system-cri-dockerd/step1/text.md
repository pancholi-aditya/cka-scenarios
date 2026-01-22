## Step 1 – Install and Enable cri-dockerd

Install `cri-dockerd` using the provided Debian package and
ensure the service is enabled and running.

### Requirements

- Package: `/cri-dockerd_0.3.9.3-0.ubuntu-focal_amd64.deb`
- Service must be enabled and started

<details>
<summary><strong>Solution</strong></summary>

dpkg -i /cri-dockerd_0.3.9.3-0.ubuntu-focal_amd64.deb

systemctl daemon-reload
systemctl enable cri-docker.service
systemctl start cri-docker.service
