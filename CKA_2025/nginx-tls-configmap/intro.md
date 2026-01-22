# NGINX TLS Configuration via ConfigMap

An NGINX Deployment is running in the cluster and uses a ConfigMap
to define its TLS configuration.

Currently, NGINX allows multiple TLS versions.

---

## Task

You must:

- Disable **TLS 1.2**
- Allow **only TLS 1.3**
- Apply the required configuration changes
- Verify that:
  - TLS 1.3 connections succeed
  - TLS 1.2 connections fail

You must modify the **ConfigMap-based configuration**, not the container image.
