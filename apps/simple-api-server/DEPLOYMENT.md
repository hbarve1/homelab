# Simple API Server Deployment Guide

This guide walks you through deploying the Simple API Server to your MicroK8s cluster using the Docker registry and Cloudflare Tunnel.

## Prerequisites

- MicroK8s cluster running
- Docker registry enabled in MicroK8s
- Docker configured for insecure registry (see `terraform/modules/compute/microk8s-registry/docker-insecure-registry-setup.md`)
- Terraform configured
- Cloudflare Tunnel configured (optional, for external access)

## Step 1: Build and Push Docker Image

```bash
cd apps/simple-api-server
./build-and-push.sh
```

This will:
1. Build the Docker image
2. Tag it for the MicroK8s registry
3. Push it to `192.168.31.85:32000/simple-api-server:latest`

## Step 2: Verify Image in Registry

```bash
# Get node IP
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')

# List images in registry
curl http://${NODE_IP}:32000/v2/_catalog

# Check specific image tags
curl http://${NODE_IP}:32000/v2/simple-api-server/tags/list
```

## Step 3: Deploy with Terraform

```bash
cd terraform/environments/prod

# Initialize Terraform (if not done already)
terraform init

# Plan deployment
terraform plan

# Apply deployment
terraform apply
```

This will create:
- Namespace: `apps`
- Deployment: `simple-api-server` (1 replica)
- Service: `simple-api-server` (ClusterIP)
- Ingress: `api-1.hbarve1.com` → `simple-api-server`

## Step 4: Configure Cloudflare Tunnel (if enabled)

The Cloudflare tunnel subdomains already include `api-1` in the default list. If you have the tunnel enabled:

1. **DNS Configuration in Cloudflare:**
   - Go to Cloudflare Dashboard → DNS
   - Add CNAME: `api-1` → `<tunnel-id>.cfargotunnel.com` (Proxied ✅)

2. **Verify Tunnel Routes:**
   - The tunnel is configured to route all subdomains (including `api-1.hbarve1.com`) to the ingress controller
   - The ingress controller will route `api-1.hbarve1.com` to the `simple-api-server` service

## Step 5: Verify Deployment

```bash
# Check pod status
kubectl get pods -n apps -l app=simple-api-server

# Check service
kubectl get svc -n apps simple-api-server

# Check ingress
kubectl get ingress -n apps simple-api-server

# View logs
kubectl logs -n apps -l app=simple-api-server
```

## Step 6: Test the API

### Local Access (via port-forward)

```bash
# Port forward to service
kubectl port-forward -n apps svc/simple-api-server 8080:80

# Test endpoints
curl http://localhost:8080/
curl http://localhost:8080/health
curl http://localhost:8080/api/info
curl http://localhost:8080/api/echo?test=hello
```

### External Access (via Cloudflare Tunnel)

```bash
# Test via Cloudflare domain
curl https://api-1.hbarve1.com/
curl https://api-1.hbarve1.com/health
curl https://api-1.hbarve1.com/api/info
```

## API Endpoints

- `GET /` - API information and available endpoints
- `GET /health` - Health check endpoint
- `GET /api/info` - Server information
- `GET /api/echo` - Echo GET request data
- `POST /api/echo` - Echo POST request data

## Troubleshooting

### Image Pull Errors

If pods fail to pull the image:

1. Verify image exists in registry:
   ```bash
   curl http://192.168.31.85:32000/v2/simple-api-server/tags/list
   ```

2. Check if Docker insecure registry is configured:
   ```bash
   docker info | grep -i insecure
   ```

3. Verify image pull secrets (if using authentication):
   ```bash
   kubectl get secrets -n apps
   ```

### Ingress Not Working

1. Check ingress controller is running:
   ```bash
   kubectl get pods -n ingress-nginx
   ```

2. Check ingress resource:
   ```bash
   kubectl describe ingress -n apps simple-api-server
   ```

3. Test ingress directly:
   ```bash
   kubectl port-forward -n ingress-nginx svc/nginx-ingress-controller 8080:80
   curl -H "Host: api-1.hbarve1.com" http://localhost:8080/
   ```

### Cloudflare Tunnel Not Routing

1. Check tunnel pod logs:
   ```bash
   kubectl logs -n cloudflare-tunnel -l app=cloudflare-tunnel
   ```

2. Verify DNS record in Cloudflare Dashboard
3. Verify tunnel route configuration in Zero Trust Dashboard

## Updating the Image

To update the API server:

```bash
# 1. Make changes to server.js
# 2. Rebuild and push
cd apps/simple-api-server
./build-and-push.sh v2  # Use a new tag

# 3. Update Terraform variable
# In terraform/environments/prod/main.tf:
# image_tag = "v2"

# 4. Apply changes
cd terraform/environments/prod
terraform apply
```

Or use `kubectl` to update the image directly:

```bash
kubectl set image deployment/simple-api-server simple-api-server=192.168.31.85:32000/simple-api-server:v2 -n apps
kubectl rollout status deployment/simple-api-server -n apps
```

