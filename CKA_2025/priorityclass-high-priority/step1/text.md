## Step 1 – Create PriorityClass

Create a new PriorityClass named `high-priority`.

### Requirements

- Name: `high-priority`
- Value: **one less than the highest existing user-defined PriorityClass**
- globalDefault: false

---

<details>
<summary><strong>Solution</strong></summary>
First, identify the highest existing **user-defined** PriorityClass value
(excluding system PriorityClasses):

```bash
kubectl get priorityclass
```

Create Priority Class

```yaml
kubectl apply -f - <<EOF
apiVersion: scheduling.k8s.io/v1
kind: PriorityClass
metadata:
  name: high-priority
value: 9999999999999
globalDefault: false
description: "High priority for user workloads"
EOF
```

```
Note: In existing exam the value will be this much high for priority class and you must getone less value from that and because we cannot copy from the terminal to given calculator it will be tough, so you should be familiar with command line mathematical operation to do this properly in exam.
```
