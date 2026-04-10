## Step 1 – Install CNI

Install a Container Network Interface that supports native NetworkPolicy.

Choose **one** option:

### Option 1 – Flannel

- Version: 0.26.1
- Manifest:
  https://github.com/flannel-io/flannel/releases/download/v0.26.1/kube-flannel.yml

### Option 2 – Calico

- Version: 3.28.2
- Manifest:
  https://raw.githubusercontent.com/projectcalico/calico/v3.28.2/manifests/tigera-operator.yaml

<details>
<summary><strong>Solution</strong></summary>

kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.2/manifests/tigera-operator.yaml
