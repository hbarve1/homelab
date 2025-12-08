# Multiple Subdomains Through Single Cloudflare Tunnel

This guide explains how to route multiple subdomains through a single Cloudflare Tunnel, with support for multiple nodes in your cluster.

## Architecture

```
Internet
    ↓
Cloudflare (Multiple DNS records)
    ↓
Single Tunnel Pod (or multiple for HA)
    ↓
Ingress Controller (handles hostname routing)
    ↓
Your Services (app, api, grafana, etc.)
```

## Key Points

- ✅ **One tunnel** handles all subdomains
- ✅ **Multiple replicas** for high availability across nodes
- ✅ **Ingress controller** handles hostname-based routing
- ✅ **No IP dependencies** - works regardless of node IP changes

## Configuration

### Option 1: Simple Subdomains List (Recommended)

```hcl
module "cloudflare_tunnel" {
  source = "../../modules/networking/cloudflare-tunnel"
  
  namespace              = "cloudflare-tunnel"
  tunnel_id              = var.cloudflare_tunnel_id
  tunnel_credentials_json = var.cloudflare_tunnel_credentials_json
  
  # All subdomains route through same tunnel
  domain     = "yourdomain.com"
  subdomains = [
    "app",
    "api",
    "grafana",
    "prometheus",
    "nextcloud",
    "pihole"
  ]
  
  # High availability: Multiple replicas across nodes
  replicas = 2
}
```

### Option 2: Explicit Routes

```hcl
module "cloudflare_tunnel" {
  source = "../../modules/networking/cloudflare-tunnel"
  
  namespace              = "cloudflare-tunnel"
  tunnel_id              = var.cloudflare_tunnel_id
  tunnel_credentials_json = var.cloudflare_tunnel_credentials_json
  
  routes = [
    {
      hostname = "app.yourdomain.com"
      service  = "http://nginx-ingress-controller.ingress-nginx.svc.cluster.local:80"
    },
    {
      hostname = "api.yourdomain.com"
      service  = "http://nginx-ingress-controller.ingress-nginx.svc.cluster.local:80"
    },
    {
      hostname = "grafana.yourdomain.com"
      service  = "http://nginx-ingress-controller.ingress-nginx.svc.cluster.local:80"
    }
  ]
  
  replicas = 2
}
```

## DNS Configuration

### In Cloudflare Dashboard

For each subdomain, create a CNAME record:

1. **DNS Records:**
   - Go to Cloudflare Dashboard → Your Domain → DNS
   - Add CNAME for each:
     - `app` → `<tunnel-id>.cfargotunnel.com` (Proxied ✅)
     - `api` → `<tunnel-id>.cfargotunnel.com` (Proxied ✅)
     - `grafana` → `<tunnel-id>.cfargotunnel.com` (Proxied ✅)
     - etc.

2. **Tunnel Routes (Zero Trust Dashboard):**
   - Go to Zero Trust → Networks → Tunnels → Your Tunnel
   - Add Public Hostname for each:
     - Subdomain: `app`, Domain: `yourdomain.com`, Service: `http://nginx-ingress-controller.ingress-nginx.svc.cluster.local:80`
     - Subdomain: `api`, Domain: `yourdomain.com`, Service: `http://nginx-ingress-controller.ingress-nginx.svc.cluster.local:80`
     - etc.

**OR** use a catch-all approach:
- Add one route: `*` → `http://nginx-ingress-controller.ingress-nginx.svc.cluster.local:80`
- Let ingress controller handle all hostname routing

## High Availability

### Multiple Replicas Across Nodes

```hcl
replicas = 2  # or more, depending on your node count
```

The module automatically:
- Spreads pods across different nodes
- Ensures at least one pod per node (if replicas >= node count)
- Provides redundancy if a node fails

### Verify Pod Distribution

```bash
# Check pods are on different nodes
kubectl get pods -n cloudflare-tunnel -o wide

# Should show pods on different NODE columns
```

## How It Works

1. **DNS Resolution:**
   - `app.yourdomain.com` → CNAME → `<tunnel-id>.cfargotunnel.com`
   - `api.yourdomain.com` → CNAME → `<tunnel-id>.cfargotunnel.com`
   - All point to the same tunnel endpoint

2. **Tunnel Routing:**
   - Tunnel receives traffic for any subdomain
   - Routes to ingress controller based on hostname

3. **Ingress Routing:**
   - Ingress controller receives request with hostname header
   - Routes to appropriate service based on ingress rules

4. **Service Access:**
   - Request reaches your service
   - Response flows back through same path

## Example: Complete Setup

```hcl
# terraform/environments/prod/main.tf
module "cloudflare_tunnel" {
  source = "../../modules/networking/cloudflare-tunnel"
  
  namespace              = "cloudflare-tunnel"
  tunnel_id              = var.cloudflare_tunnel_id
  tunnel_credentials_json = var.cloudflare_tunnel_credentials_json
  
  domain     = "yourdomain.com"
  subdomains = [
    "app",
    "api",
    "grafana",
    "prometheus",
    "nextcloud",
    "pihole"
  ]
  
  replicas = 2  # HA across nodes
}
```

**terraform.tfvars:**
```hcl
cloudflare_tunnel_id = "abc12345-6789-0123-4567-890123456789"
cloudflare_tunnel_credentials_json = file("~/.cloudflared/abc12345-6789-0123-4567-890123456789.json")
```

## Benefits

- ✅ **Single tunnel** - Easier to manage
- ✅ **Multiple subdomains** - All through one connection
- ✅ **High availability** - Multiple replicas across nodes
- ✅ **IP independent** - Works regardless of node IP changes
- ✅ **Scalable** - Easy to add more subdomains

## Troubleshooting

### Multiple pods on same node

```bash
# Check pod distribution
kubectl get pods -n cloudflare-tunnel -o wide

# If all on same node, increase replicas or check node availability
```

### Subdomain not working

1. Verify DNS record exists and is proxied
2. Check tunnel route in Zero Trust dashboard
3. Verify ingress rule matches hostname
4. Check tunnel pod logs: `kubectl logs -n cloudflare-tunnel -l app=cloudflare-tunnel`

### Service not accessible

- Verify ingress controller is running
- Check ingress rules match hostname
- Test ingress directly: `kubectl port-forward -n ingress-nginx svc/nginx-ingress-controller 8080:80`

