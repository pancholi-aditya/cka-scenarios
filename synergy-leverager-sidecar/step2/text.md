## Step 2 – Add Sidecar Container

Add a sidecar container with the following configuration:

- Name: `sidecar`
- Image: `busybox:stable`
- Command:
  `/bin/sh -c "tail -n+1 -f /var/log/synergy-leverager.log"`
- Mount the shared volume at `/var/log`
