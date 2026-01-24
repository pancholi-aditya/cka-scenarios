### Task

Create a **Horizontal Pod Autoscaler** named **`apache-server`** in the **`auto-scale`** namespace.

#### Requirements

- Target the existing Deployment `apache-server`
- CPU utilization target: **50%**

> Use the method you prefer (imperative or declarative).

---

<details>
<summary><strong>Check HPA</strong></summary>

Check whether an HPA already exists:

```plain
kubectl get hpa -n auto-scale
```

Inspect the target Deployment and its resource requests:

```plain
kubectl get deployment apache-server -n auto-scale -o yaml
```

If CPU requests are missing, autoscaling will not work.

</details>

---

<details>
<summary><strong>Tip 1</strong></summary>

Horizontal Pod Autoscalers rely on **metrics-server** and container resource requests.

Ensure:

- CPU **requests** are defined for the container
- The Deployment name and namespace are correct
- CPU utilization is specified as a **percentage**

</details>

---

<details>
<summary><strong>Tip 2</strong></summary>

You may create the HPA using:

- An **imperative command**, or
- A **declarative YAML manifest**

Both approaches are valid as long as the final HPA configuration meets the requirements.

</details>

---

<details>
<summary><strong>Solution</strong></summary>

Create the Horizontal Pod Autoscaler using an imperative command:

```bash
kubectl autoscale deployment apache-server \
  --cpu-percent=50 \
  --min=1 \
  --max=10 \
  -n auto-scale\
  --dry-run=client\
  -o yaml > hpa.yaml
```

add stabilizationWindow to file:\

```bash
> vim hpa.yaml
```

add this section

```yaml
behavior:
  scaleDown:
    stabilizationWindowSeconds: 300
```

Save and apply.

Verify that the HPA is created:

```bash
kubectl get hpa apache-server -n auto-scale
```

Or use declarative way:

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: apache-server
  namespace: auto-scale
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: apache-server
  minReplicas: 1
  maxReplicas: 10
  behavior:
    scaleDown:
      stabilizationWindowSeconds: 300
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 50
```

Apply it using:

```bash
kubectl apply -f hpa.yaml
```

The HPA should now target the `apache-server` Deployment and scale based on **50% CPU utilization**.

</details>
