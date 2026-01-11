# Horizontal Pod Autoscaler (HPA)

## Task

Create a **Horizontal Pod Autoscaler (HPA)** named **apache-server** in the **auto-scale** namespace.

### Requirements

- Target the existing Deployment **apache-server**
- Target **50% CPU utilization per Pod**
- Minimum replicas: **1**
- Maximum replicas: **4**
- Set **downscale stabilization window** to **30 seconds**

---

## Notes

- The Deployment and Namespace already exist.
- Metrics Server is already installed.
- You must not modify the Deployment itself.

---

## Validation

Your solution will be automatically validated.

