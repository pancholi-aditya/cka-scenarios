## Step 2 – Update Deployment to Use PVC

Edit the Deployment manifest located at:

/mariadb-deployment.yaml

Update it to use the `mariadb` PersistentVolumeClaim for data storage.

<details>
<summary><strong>Solution</strong></summary>

Edit the Deployment file:

```bash
vi /mariadb-deployment.yaml
```

Ensure the Pod specification includes the PVC:

```yaml
volumes:
  - name: mariadb-storage
    persistentVolumeClaim:
      claimName: mariadb
```

And mount it in the MariaDB container:

```yaml
volumeMounts:
  - name: mariadb-storage
    mountPath: /var/lib/mysql
```

Save the file after making the changes.
