# Stop the Misbehaving ollama Pod

An `ollama` application is running in the cluster.

One of its Pods is misbehaving and poses a security threat by directly
accessing system memory through `/dev/mem`.

Your job is to identify the offending Pod, determine which Deployment manages
it, and stop that Deployment without changing any other workload.

Falco-style security alerts are written to `/var/log/falco.log`.
