> The Horizontal Pod Autoscaler must target an existing Deployment.
> <br>
> CPU-based autoscaling requires CPU requests on the container.

---

Create the Horizontal Pod Autoscaler using an imperative command:

````plain
kubectl autoscale deployment apache-server \
  --cpu-percent=50 \
  --min=1 \
  --max=10 \
  -n auto-scale
```{}

---

Alternatively, create the HPA using a declarative manifest:

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
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 50
````
