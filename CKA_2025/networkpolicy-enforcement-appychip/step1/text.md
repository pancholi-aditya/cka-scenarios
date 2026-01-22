## NetworkPolicy Enforcement in Namespace `appychip`

You must create a NetworkPolicy that restricts traffic for Pods
running in the `appychip` namespace.

---

## Task

1. Create a namespace named `appychip` (if it does not already exist).
2. Create a NetworkPolicy named `my-policy` in the `appychip` namespace.

### Requirements

1. Allow Pods within `appychip` to communicate **only on port 80**.
2. Deny **all traffic from Pods outside the namespace**.

---

<details>
<summary><strong>Solution</strong></summary>

### Step 1: Create the NetworkPolicy

Create the following NetworkPolicy in the `appychip` namespace:

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: my-policy
  namespace: appychip
spec:
  podSelector: {}
  policyTypes:
    - Ingress
  ingress:
    - from:
        - podSelector: {}
      ports:
        - protocol: TCP
          port: 80
```

Apply the policy:

```bash
kubectl apply -f my-policy.yaml
```
