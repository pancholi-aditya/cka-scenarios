## Step 1 – List cert-manager CRDs

List **all CustomResourceDefinitions (CRDs)** that belong to cert-manager
and save them to a file named:

custom-crd.txt

### Important Notes

- CRDs are **cluster-scoped**
- cert-manager CRDs contain `cert-manager.io` in their name
- The output must be written to a file

<details>
<summary><strong>Solution</strong></summary>

```bash
kubectl get crd | grep cert-manager.io > custom-crd.txt
```

## Explanation (THIS is where most people fail)

kubectl get crd

```plain

Lists all CRDs in the cluster (not namespaced)
```

grep cert-manager.io

```plain

cert-manager CRDs always include this domain
```

> redirects output to the required file

## Example output file (custom-crd.txt)

    certificaterequests.cert-manager.io
    certificates.cert-manager.io
    challenges.acme.cert-manager.io
    clusterissuers.cert-manager.io
    issuers.cert-manager.io
    orders.acme.cert-manager.io
