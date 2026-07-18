# Kubernetes Secret Management for GitOps

In our GitOps workflow, we manage sensitive data by encrypting manifests to be stored in Git. These are decrypted in-cluster by the **Sealed Secrets** controller.

## 1. The Sealed Secrets Architecture

To maintain the "Everything in Git" philosophy, we never commit raw secrets.

1. **Encryption (Local):** `kubeseal` uses the cluster's public key to encrypt a manifest.
2. **Commit:** You push the encrypted `SealedSecret` to your Git repository.
3. **Decryption (In-Cluster):** The controller (which holds the private key) automatically decrypts the `SealedSecret` and creates a native Kubernetes `Secret`.

## 2. Defining & Encrypting Secrets

Instead of base64-encoding plain text, we use `kubeseal` to generate a `SealedSecret`.

### Create a manifest (Local, uncommitted)

```yaml
# local-secret.yaml (DO NOT COMMIT)
apiVersion: v1
kind: Secret
metadata:
  name: app-secrets
  namespace: project
stringData:
  DB_PASSWORD: "super-secret-password"
  API_KEY: "random-key-123"
```

### Seal the Secret

```bash
kubeseal --format yaml < local-secret.yaml > base/common/example-project/app-secrets.yaml
```

## 3. Consuming Secrets in Deployments

There are two primary ways to consume these secrets in your `deployment.yaml`.

### Method A: Environment Variables (`envFrom`)

Best for key-value pairs. This injects every secret key as an environment variable.

```yaml
spec:
  template:
    spec:
      containers:
        - name: backend
          envFrom:
            - secretRef:
                name: app-secrets # Matches the metadata.name of the Secret
```

### Method B: Volume Mounts

Best if your application requires a physical file (e.g., `.env`, config files, or certificates).

```yaml
spec:
  template:
    spec:
      containers:
        - name: backend
          volumeMounts:
            - name: secret-volume
              mountPath: /etc/secrets
              readOnly: true
      volumes:
        - name: secret-volume
          secret:
            secretName: app-secrets
```

## 4. Special Case: Image Pull Secrets

For Docker registry authentication (`regcred`), do **not** use volume mounts. Use the `imagePullSecrets` field specifically intended for registry access:

```yaml
spec:
  template:
    spec:
      imagePullSecrets:
        - name: regcred
      containers:
        - name: backend
          # ...
```

## Summary Checklist

- [ ] **Install Controller:** Ensure the Sealed Secrets controller is running in your cluster.
- [ ] **Seal Secrets:** Always pipe local secrets through `kubeseal` before committing.
- [ ] **Match Names:** Ensure the `metadata.name` in your `SealedSecret` matches the name used in `secretRef` or `volume` definitions.
- [ ] **Ignore Raw Secrets:** Add your temporary `local-secret.yaml` files to `.gitignore`.

---

## Mounting .env Files as Secrets

If your application expects a physical `.env` file on the filesystem, you can store the file content inside a `Secret` and mount it as a volume.

### 1. Create the Secret Manifest

Create a secret where the key is the filename (e.g., `.env`) and the value is the content of the file.

```yaml
# local-env-file.yaml (DO NOT COMMIT)
apiVersion: v1
kind: Secret
metadata:
  name: app-env-file
  namespace: project
stringData:
  .env: |
    DB_URL=postgres://user:pass@db:5432/app
    LOG_LEVEL=debug
    API_KEY=my-secret-key
```

### 2. Seal the Secret

Encrypt it so it can be safely committed to your GitOps repository:

```bash
kubeseal --format yaml < local-env-file.yaml > base/common/example-project/app-env-file.yaml
```

### 3. Mount in Deployment

In your `deployment.yaml`, you must define the volume and then mount it to the specific directory where your application expects the file.

```yaml
spec:
  template:
    spec:
      containers:
        - name: backend
          volumeMounts:
            # Mount the file directly to the path
            - name: env-file-volume
              mountPath: /app/.env
              subPath: .env # IMPORTANT: This ensures ONLY the .env file is mounted
              readOnly: true
      volumes:
        - name: env-file-volume
          secret:
            secretName: app-env-file
```

#### Why use `subPath`?

- **Without `subPath`:** Kubernetes mounts the entire secret as a directory. If your secret has one key called `.env`, it will replace the entire `/app` directory with a folder containing only that file.
- **With `subPath`:** Kubernetes maps the individual key `.env` from your secret to the specific file path `/app/.env`, leaving the rest of your `/app` directory content intact.
