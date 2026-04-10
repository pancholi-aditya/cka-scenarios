## Create User and Configure RBAC

You must create a new Kubernetes user named **ajeet** and grant that user
permissions to manage Pods.

---

## Requirements

### User

- Name: `ajeet`
- Private key location: `/root/ajeet.key`
- CSR location: `/root/ajeet.csr`

### Permissions (Pods)

The user must be able to:

- create
- list
- get
- update
- delete

---

<details>
<summary><strong>Solution</strong></summary>

### Step 1: Generate Private Key

```bash
openssl genrsa -out /root/ajeet.key 2048
```

### Step 2: Create Certificate Signing Request (CSR)

```bash
openssl req -new \
  -key /root/ajeet.key \
  -out /root/ajeet.csr \
  -subj "/CN=ajeet"
```

### Step 3: Create Kubernetes CSR Object

Encode the CSR:

```bash
cat /root/ajeet.csr | base64 | tr -d '\n'
```

Create the CSR manifest:

```yaml
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: ajeet
spec:
  request: <BASE64_CSR>
  signerName: kubernetes.io/kube-apiserver-client
  usages:
    - client auth
```

Apply it:

```bash
kubectl apply -f ajeet-csr.yaml
```

Approve the CSR:

```bash
kubectl certificate approve ajeet
```

### Step 4: Create Role with Pod Permissions

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: pod-manager
  namespace: rbac-test
rules:
  - apiGroups: [""]
    resources: ["pods"]
    verbs: ["create", "list", "get", "update", "delete"]
```

Apply it:

```bash
kubectl apply -f role.yaml
```

### Step 5: Bind the Role to User ajeet

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: pod-manager-binding
  namespace: rbac-test
subjects:
  - kind: User
    name: ajeet
    apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: pod-manager
  apiGroup: rbac.authorization.k8s.io
```

Apply it:

```bash
kubectl apply -f rolebinding.yaml
```

## Explanation

    Kubernetes users are external identities

    Authentication is done using x509 certificates

    Authorization is controlled by RBAC

    Roles define what actions are allowed

    RoleBindings define who gets those permissions
