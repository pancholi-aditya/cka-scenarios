# NetworkPolicy – Least Privilege (Selection Based)

There are two existing Deployments in this cluster:

- `frontend` Deployment in the `frontend` namespace
- `backend` Deployment in the `backend` namespace

The application requires that **only frontend Pods may communicate with backend Pods**.

All other ingress traffic to backend Pods must be denied.

---

## Task

Three NetworkPolicy YAML files are provided.

You must **choose and apply the most restrictive policy** that still allows
the required communication.
