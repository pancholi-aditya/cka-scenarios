## Fix Insecure User Settings

Analyze and edit the Dockerfile located at:

```bash
/home/candidate/subtle-bee/Dockerfile
```

Fix one existing instruction present in the file that is a prominent security
best-practice issue.

Do not remove instructions. Only modify the one existing instruction with a
security best-practice concern.

Do not build the Dockerfile. Failure to do so may result in running out of
storage and a zero score.

Then analyze and edit the manifest file:

```bash
/home/candidate/subtle-bee/deployment.yaml
```

Fix one existing field present in the file that is a prominent security
best-practice issue.

Do not add or remove fields. Only modify the one existing field with a security
best-practice concern.

Should you need an unprivileged user for any of the tasks, use user `nobody`
with user ID `65535`.

---

<details>
<summary><strong>Solution</strong></summary>

Edit the Dockerfile:

```bash
vi /home/candidate/subtle-bee/Dockerfile
```

Change the existing insecure user instruction:

```dockerfile
USER nobody
```

Edit the Deployment manifest:

```bash
vi /home/candidate/subtle-bee/deployment.yaml
```

Change the existing root user ID to the unprivileged `nobody` UID:

```yaml
runAsUser: 65535
```

Do not run `docker build` or `kubectl apply` for this task.

</details>
