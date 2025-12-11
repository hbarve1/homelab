# GitHub Container Registry (GHCR) Setup Guide

This guide explains how to use GitHub Container Registry (ghcr.io) for private container images in your Kubernetes cluster.

## Prerequisites

1. A GitHub account
2. A GitHub Personal Access Token (PAT) with `read:packages` permission
3. Kubernetes cluster access

## Step 1: Create GitHub Personal Access Token

1. Go to GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Click "Generate new token (classic)"
3. Give it a name (e.g., "K8s Image Pull")
4. Select the `read:packages` scope
5. Click "Generate token"
6. **Copy the token immediately** (you won't see it again)

## Step 2: Create Kubernetes Image Pull Secret

### Option A: Using kubectl (Recommended)

```bash
# Replace YOUR_GITHUB_USERNAME and YOUR_GITHUB_PAT with your actual values
kubectl create secret docker-registry ghcr-secret \
  --docker-server=ghcr.io \
  --docker-username=YOUR_GITHUB_USERNAME \
  --docker-password=YOUR_GITHUB_PAT \
  --namespace=apps
```

### Option B: Using base64 encoded credentials

```bash
# Create the secret manually
echo -n 'YOUR_GITHUB_USERNAME:YOUR_GITHUB_PAT' | base64

# Then create the secret YAML
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: ghcr-secret
  namespace: apps
type: kubernetes.io/dockerconfigjson
data:
  .dockerconfigjson: $(echo -n '{"auths":{"ghcr.io":{"username":"YOUR_GITHUB_USERNAME","password":"YOUR_GITHUB_PAT","auth":"BASE64_ENCODED_USERNAME:PAT"}}}' | base64)
EOF
```

### Option C: Using Terraform (if managing secrets via Terraform)

Uncomment the resource in `modules/apps/ghcr-secret.tf` and add variables to your environment.

## Step 3: Verify the Secret

```bash
kubectl get secret ghcr-secret -n apps
kubectl describe secret ghcr-secret -n apps
```

## Step 4: Configure Your Application

In your Terraform configuration (`environments/prod/main.tf`):

```hcl
module "simple_api_server" {
  source = "../../modules/apps/simple-api-server"
  
  namespace      = kubernetes_namespace.apps.metadata[0].name
  image_registry = "ghcr.io"
  image_name     = "your-username/your-repo-name"  # e.g., "hbarve1/simple-api-server"
  image_tag      = "latest"
  image_pull_secret_name = "ghcr-secret"
  
  ingress_enabled = true
  ingress_host    = "api-1.hbarve1.com"
  
  replicas = 1
}
```

## Image Naming Convention

GitHub Container Registry images follow this format:
```
ghcr.io/USERNAME/REPO-NAME:TAG
```

For example:
- `ghcr.io/hbarve1/simple-api-server:latest`
- `ghcr.io/hbarve1/simple-api-server:v1.0.0`

## Pushing Images to GHCR

### 1. Authenticate Docker with GitHub

**Option A: Using environment variable (if GITHUB_PAT is set)**
```bash
export GITHUB_PAT="your_pat_token_here"
echo "$GITHUB_PAT" | docker login ghcr.io -u YOUR_GITHUB_USERNAME --password-stdin
```

**Option B: Direct token (one-liner)**
```bash
echo "YOUR_PAT_TOKEN" | docker login ghcr.io -u YOUR_GITHUB_USERNAME --password-stdin
```

**Option C: Using a file (more secure)**
```bash
# Save token to file (one time)
echo "YOUR_PAT_TOKEN" > ~/.github_pat
chmod 600 ~/.github_pat

# Login using file
cat ~/.github_pat | docker login ghcr.io -u YOUR_GITHUB_USERNAME --password-stdin
```

**Note:** Make sure to use your GitHub Personal Access Token (PAT), not your GitHub password!

### 2. Tag Your Image

```bash
docker tag your-image:latest ghcr.io/YOUR_USERNAME/your-repo-name:latest
```

### 3. Push to GHCR

```bash
docker push ghcr.io/YOUR_USERNAME/your-repo-name:latest
```

## Troubleshooting

### ImagePullBackOff Error

If you see `ImagePullBackOff` or `ErrImagePull`:

1. **Check secret exists:**
   ```bash
   kubectl get secret ghcr-secret -n apps
   ```

2. **Verify secret is correct:**
   ```bash
   kubectl get secret ghcr-secret -n apps -o jsonpath='{.data.\.dockerconfigjson}' | base64 -d | jq
   ```

3. **Check pod events:**
   ```bash
   kubectl describe pod <pod-name> -n apps
   ```

4. **Verify GitHub PAT has correct permissions:**
   - Token must have `read:packages` scope
   - Token must not be expired

### Secret Not Found

If the secret is not found:
- Ensure the secret is created in the same namespace as your pods
- Check the namespace name matches: `kubectl get namespaces`

### Authentication Failed

- Verify your GitHub username is correct
- Ensure the PAT token is valid and not expired
- Check that the image is actually private (public images don't need authentication)

## Security Best Practices

1. **Use fine-grained PATs** with minimal permissions (`read:packages` only)
2. **Rotate tokens regularly**
3. **Store PATs securely** (use Kubernetes secrets, not in code)
4. **Use separate tokens** for different environments
5. **Consider using GitHub Actions** to push images automatically

## References

- [GitHub Container Registry Documentation](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry)
- [Kubernetes Image Pull Secrets](https://kubernetes.io/docs/concepts/containers/images/#specifying-imagepullsecrets-on-a-pod)
