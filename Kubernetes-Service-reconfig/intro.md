# Kubernetes Service & Deployment Reconfiguration

In this scenario, you will reconfigure an existing Kubernetes Deployment and expose it using a NodePort Service.

### Namespace

All tasks must be completed in the **`spline-reticulator`** namespace.

### Objective

You are provided with an existing Deployment named **`front-end`** running an **nginx** container.

You must:

- Expose port **80/TCP** from the container
- Create a Service named **`front-end-svc`**
- Expose the application using a **NodePort**

This scenario closely matches real CKA-style operational tasks.
