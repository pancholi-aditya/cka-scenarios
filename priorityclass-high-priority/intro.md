# PriorityClass Management and Deployment Patching

In this scenario, you will create a new Kubernetes PriorityClass and
apply it to an existing Deployment.

### Namespace

priority

### Objectives

- Create a PriorityClass named `high-priority`
- Set its value to **one less than the highest existing user-defined PriorityClass**
- Patch an existing Deployment to use the new PriorityClass
- Ensure a successful rollout

> Pods from other Deployments in the namespace may be evicted.
