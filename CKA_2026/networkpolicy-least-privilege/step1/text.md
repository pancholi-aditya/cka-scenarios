Three NetworkPolicy YAML files are provided in the `manifests/` directory.

Each file represents a different approach to allowing traffic
from frontend Pods to backend Pods.

Apply the **most restrictive NetworkPolicy** that still allows
frontend Pods to communicate with backend Pods.

Only one option satisfies the requirement correctly.

<details>
<summary><strong>Solution</strong></summary>

The correct choice is the policy that:

- Targets **only backend Pods**
- Allows ingress **only from frontend Pods**
- Uses **Kubernetes identity (labels and namespaces)** instead of IP ranges
- Avoids unnecessary or brittle constraints

### Correct Policy to Apply

Apply **Option 2**, which uses both a **namespace selector** and a **pod selector**:

```bash
kubectl apply -f /root/manifests/np-option2.yaml
```

## Explanation of Each Option

### Option 1 — Pod selector only (Incorrect)

    This policy selects backend Pods but does not restrict the source of
    incoming traffic.

    As a result, any Pod from any namespace can communicate with the backend.
    This violates the principle of least privilege and is therefore too permissive.

### Option 2 — Pod selector + Namespace selector (Correct)

    This policy:

    Targets backend Pods explicitly

    Allows ingress only from Pods labeled app=frontend

    Further restricts traffic to the frontend namespace

    It uses stable Kubernetes identity primitives and denies all other ingress
    traffic by default.

    This makes it the most restrictive policy that still satisfies the
    application requirement.

### Option 3 — Pod selector + Namespace selector + CIDR (Incorrect)

    This policy adds an ipBlock CIDR restriction.

    Pod IP addresses are ephemeral and cluster-specific, and the question does
    not require restricting traffic by IP range. Adding a CIDR introduces
    unnecessary dependency on network implementation details and makes the
    policy overly restrictive and brittle.
