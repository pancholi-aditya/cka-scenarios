## Kubectl Contexts

You must work with the kubeconfig contexts available on this system.

---

## Tasks

1. Write **all available context names** to the file:

   ```bash
   /opt/course/1/contexts
   ```

2. Write a command that displays the **current context using kubectl** to:

   ```bash
   /opt/course/1/context_default_kubectl.sh
   ```

3. Write another command that displays the **current context without using kubectl** to:
   `bash
 /opt/course/1/context_default_no_kubectl.sh
 `
   Each file must contain **only the required command or output**, nothing extra.

---

<details>
<summary><strong>Solution</strong></summary>

### Task 1: Write All Context Names

Use kubectl to list only the context names:

```bash
> kubectl config get-contexts -o name > /opt/course/1/contexts
```

### Task 2: Command Using kubectl

Write a command that prints the current context using kubectl:

```bash
> kubectl config current-context
```

Save it to the file:

```bash

> echo "kubectl config current-context" > /opt/course/1/context_default_kubectl.sh
```

### Task 3: Command Without Using kubectl

The current context is stored in the kubeconfig file under
current-context.

Extract it directly without kubectl:

```bash

> grep "^current-context:" ~/.kube/config | awk '{print $2}'
```

Save this command to the file:

```bash

> echo "grep \"^current-context:\" ~/.kube/config | awk '{print \$2}'" \
/opt/course/1/context_default_no_kubectl.sh
```

## Explanation

kubectl config get-contexts -o name

    prints only context names

kubectl config current-context is the canonical kubectl method

current-context is a plain YAML field inside kubeconfig

Reading kubeconfig directly avoids kubectl entirely
