# Simple API Server

A simple Express.js API server for homelab deployment.

## Registry Configuration

### Two Registry Endpoints

1. **External Registry** (for Docker push):
   - `192.168.31.85:32000` (or your node IP)
   - Used when pushing images from your local machine
   - Requires Docker insecure registry configuration

2. **Internal Registry** (for Kubernetes):
   - `registry.container-registry.svc.cluster.local:5000`
   - Used by Kubernetes to pull images
   - Works automatically, no HTTPS/authentication issues

### Why Two Endpoints?

- **Docker push** happens from your local machine → needs external IP:port
- **Kubernetes pull** happens inside the cluster → uses internal service name
- Internal endpoint avoids HTTPS/authentication issues

## Build and Push

```bash
cd apps/simple-api-server
./build-and-push.sh
```

This will:
1. Build the Docker image
2. Push to external registry (`192.168.31.85:32000`)
3. Kubernetes will automatically pull from internal registry (`registry.container-registry.svc.cluster.local:5000`)

## Docker Insecure Registry Setup

If you get `http: server gave HTTP response to HTTPS client`:

**macOS (Docker Desktop):**
1. Open Docker Desktop → Settings → Docker Engine
2. Add to JSON:
   ```json
   {
     "insecure-registries": ["192.168.31.85:32000"]
   }
   ```
3. Click "Apply & Restart"

**Linux:**
```bash
sudo tee /etc/docker/daemon.json <<EOF
{
  "insecure-registries": ["192.168.31.85:32000"]
}
EOF
sudo systemctl restart docker
```

## Deploy

The Terraform configuration uses the internal registry endpoint automatically:

```hcl
image_registry = "registry.container-registry.svc.cluster.local:5000"
```

Deploy with:
```bash
cd terraform/environments/prod
terraform apply
```

## API Endpoints

- `GET /` - API information and available endpoints
- `GET /health` - Health check endpoint
- `GET /api/info` - Server information
- `GET /api/echo` - Echo GET request data
- `POST /api/echo` - Echo POST request data

## Access

- **Local:** `kubectl port-forward -n apps svc/simple-api-server 8080:80`
- **External:** `https://api-1.hbarve1.com` (via Cloudflare Tunnel)
