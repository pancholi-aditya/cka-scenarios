# Migrate Ingress to Gateway API

An existing web application is exposed using an Ingress resource.
You must migrate it to the Gateway API while preserving HTTPS access
and routing behavior.

### Objectives

- Create a Gateway named `web-gateway`
- Hostname: `gateway.web.k8s.local`
- Preserve TLS and listener configuration from the existing Ingress `web`
- Create an HTTPRoute named `web-route`
- Preserve all routing rules from the existing Ingress

### Note

A GatewayClass named `nginx` is already installed.
