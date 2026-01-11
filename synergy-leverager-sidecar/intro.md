# Add a Sidecar Container to an Existing Deployment

In this scenario, you will update an existing Kubernetes Deployment by adding
a co-located **sidecar container** that tails an application log file.

### Deployment

- Name: `synergy-leverager`
- Namespace: `default`

### Objective

- Add a sidecar container named `sidecar`
- Share logs using a common volume mounted at `/var/log`
- Ensure the sidecar continuously tails the log file
