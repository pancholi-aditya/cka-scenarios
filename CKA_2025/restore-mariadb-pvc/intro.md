# Restore MariaDB Deployment with Persistent Storage

A MariaDB Deployment in the `mariadb` namespace was deleted accidentally.

Your task is to restore the Deployment while ensuring that
existing data is preserved using a retained PersistentVolume.

### Objectives

- Create a PersistentVolumeClaim named `mariadb`
- Requested storage must be `250Mi`
- Use the existing retained PersistentVolume
- Update the Deployment manifest to use the PVC
- Apply the restored Deployment to the cluster
