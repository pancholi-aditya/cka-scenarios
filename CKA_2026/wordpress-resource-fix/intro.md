# Fix WordPress Pods Not Running

A WordPress application has Pods that are not running due to
incorrect resource requests.

Your task is to rebalance CPU and memory requests so that:

- Node resources are divided evenly across 3 Pods
- Each Pod gets a fair share of CPU and memory
- Some overhead is reserved to keep the node stable

### Constraints

- Use identical resource requests for:
  - All containers
  - All init containers
- Scale the Deployment to 0 replicas before making changes
- Scale back to 3 replicas after updates
