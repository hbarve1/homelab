# MicroK8s Docker Registry Information

## Registry Details

- **Namespace:** `container-registry`
- **Service Name:** `registry`
- **Service Type:** `NodePort`
- **NodePort:** `32000`
- **ClusterIP:** `10.152.183.201`
- **Container Port:** `5000`
- **Node IP:** `192.168.31.85`
- **Registry Image:** `registry:2.8.1`
- **Authentication:** None (public registry)

## Registry Endpoints

### External Access (from outside cluster)
- **Primary:** `http://192.168.31.85:32000`
- **Localhost:** `http://localhost:32000` (if accessing from the node)

### Internal Access (within Kubernetes)
- **Service DNS:** `registry.container-registry.svc.cluster.local:5000`
- **ClusterIP:** `10.152.183.201:5000`

## Registry Configuration

- **Storage:** Filesystem at `/var/lib/registry`
- **Delete Enabled:** Yes
- **HTTP Address:** `:5000`

## Test Commands

### 1. Test Registry Connection
```bash
curl http://192.168.31.85:32000/v2/
# Should return: {}
```

### 2. List Repositories
```bash
curl http://192.168.31.85:32000/v2/_catalog
# Returns: {"repositories":[]}
```

### 3. Push an Image
```bash
# Tag an image
docker tag nginx:alpine 192.168.31.85:32000/my-nginx:v1

# Push to registry
docker push 192.168.31.85:32000/my-nginx:v1
```

### 4. Pull an Image
```bash
docker pull 192.168.31.85:32000/my-nginx:v1
```

### 5. Use in Kubernetes Pod
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: test-registry
spec:
  containers:
  - name: test
    image: registry.container-registry.svc.cluster.local:5000/my-nginx:v1
```

## Complete Test Example

```bash
#!/bin/bash
REGISTRY="192.168.31.85:32000"

# Test connection
echo "Testing registry..."
curl -s http://${REGISTRY}/v2/ && echo "✓ Connected"

# Tag and push
docker tag nginx:alpine ${REGISTRY}/test-nginx:latest
docker push ${REGISTRY}/test-nginx:latest

# Verify
curl -s http://${REGISTRY}/v2/test-nginx/tags/list

# Pull back
docker pull ${REGISTRY}/test-nginx:latest
```

## Notes

- **No authentication required** - Registry is public
- **Works from any machine** on the network using `192.168.31.85:32000`
- **Internal Kubernetes access** uses the service DNS name
- **Docker configured** - Insecure registry added to Docker Desktop

## Current Images

- `my-nginx:v1` - Test image (nginx:alpine)

## Docker Configuration

The registry is configured as an insecure registry in Docker Desktop:
- Added to `~/.docker/daemon.json`
- Restart Docker Desktop after configuration changes

