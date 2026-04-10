## Step 2 – Extract Certificate subject

Extract the **subject field** from cert-manager Certificates and
save it to a file named:

cert-manager-subject.txt

### Important Notes

- Certificates are **namespaced**
- The subject is found under:
  .spec.subject
- Use kubectl output formatting (JSONPath or YAML processing)

<details>
<summary><strong>Solution</strong></summary>

#### Step 1: Locate Certificates

```bash
kubectl get certificates -A
```

This confirms:

    Certificates exist

    Their namespace

#### Step 2: Extract the subject field

```bash
kubectl explain certificate.spec.subject > cert-manager-subject.txt

```
