# Cloudflare Tunnel Setup Guide

## Quick Setup Steps

### 1. Install cloudflared (if not already installed)

**macOS:**
```bash
brew install cloudflared
```

**Linux:**
```bash
# Download from https://github.com/cloudflare/cloudflared/releases
# Or use package manager
```

### 2. Login to Cloudflare

```bash
cloudflared tunnel login
```

This will open a browser to authenticate with Cloudflare.

### 3. Create a Tunnel

```bash
cloudflared tunnel create homelab-tunnel
```

Output will show:
- **Tunnel ID:** `abc12345-6789-0123-4567-890123456789`
- **Credentials file:** `~/.cloudflared/<tunnel-id>.json`

### 4. Get Tunnel Credentials

```bash
# View credentials
cat ~/.cloudflared/<tunnel-id>.json

# It contains:
# {
#   "AccountTag": "...",
#   "TunnelID": "...",
#   "TunnelSecret": "..."
# }
```

### 5. Configure DNS in Cloudflare Dashboard

**For Multiple Subdomains (Recommended):**

1. Go to Cloudflare Dashboard → Your Domain → DNS
2. Add CNAME records for each subdomain:
   - **Type:** CNAME
   - **Name:** `app` (becomes `app.yourdomain.com`)
   - **Target:** `<tunnel-id>.cfargotunnel.com`
   - **Proxy status:** Proxied (orange cloud) ✅
   - **TTL:** Auto
   - Repeat for: `api`, `grafana`, `prometheus`, etc.

3. Go to Zero Trust → Networks → Tunnels → Your Tunnel
4. Add Public Hostname (catch-all approach):
   - **Subdomain:** `*` (wildcard for all subdomains)
   - **Domain:** `yourdomain.com`
   - **Service:** `http://nginx-ingress-controller.ingress-nginx.svc.cluster.local:80`

**OR** add individual routes for each subdomain (more explicit but verbose).

### 6. Deploy Tunnel in Kubernetes

**Option 1: Multiple Subdomains (Simple)**

Add to your Terraform configuration:

```hcl
module "cloudflare_tunnel" {
  source = "../../modules/networking/cloudflare-tunnel"
  
  namespace              = "cloudflare-tunnel"
  tunnel_id              = "your-tunnel-id-here"
  tunnel_credentials_json = file("~/.cloudflared/your-tunnel-id.json")
  
  # Multiple subdomains through same tunnel
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

**Option 2: Explicit Routes**

```hcl
module "cloudflare_tunnel" {
  source = "../../modules/networking/cloudflare-tunnel"
  
  namespace              = "cloudflare-tunnel"
  tunnel_id              = "your-tunnel-id-here"
  tunnel_credentials_json = file("~/.cloudflared/your-tunnel-id.json")
  
  routes = [
    {
      hostname = "app.yourdomain.com"
      service  = "http://nginx-ingress-controller.ingress-nginx.svc.cluster.local:80"
    },
    {
      hostname = "api.yourdomain.com"
      service  = "http://nginx-ingress-controller.ingress-nginx.svc.cluster.local:80"
    }
  ]
  
  replicas = 2  # For HA across multiple nodes
}
```

See `MULTI-SUBDOMAIN-GUIDE.md` for detailed multi-subdomain setup.

### 7. Apply Configuration

```bash
cd terraform/environments/prod
terraform init
terraform plan
terraform apply
```

### 8. Verify Tunnel is Running

```bash
# Check pod status
kubectl get pods -n cloudflare-tunnel

# Check logs
kubectl logs -n cloudflare-tunnel -l app=cloudflare-tunnel

# Should see: "Connection established"
```

### 9. Test Access

```bash
# Access your service via Cloudflare domain
curl https://app.yourdomain.com

# Should route to your service through the tunnel
```

## Architecture Flow

```
Internet User
    ↓
Cloudflare (yourdomain.com DNS)
    ↓
Cloudflare Tunnel (<tunnel-id>.cfargotunnel.com)
    ↓
Tunnel Pod in Kubernetes
    ↓
Nginx Ingress Controller
    ↓
Your Service
```

## Benefits

✅ **No IP dependencies** - Works even if your cluster IP changes  
✅ **No port forwarding** - Only outbound connections  
✅ **Stable URLs** - Your Cloudflare domain always works  
✅ **Secure** - Encrypted end-to-end  
✅ **Works behind NAT** - Perfect for homelabs  
✅ **Multiple subdomains** - One tunnel handles all subdomains  
✅ **High availability** - Multiple replicas across nodes  

## Troubleshooting

### Tunnel not connecting
- Check credentials are correct
- Verify tunnel ID matches
- Check pod logs: `kubectl logs -n cloudflare-tunnel -l app=cloudflare-tunnel`

### DNS not resolving
- Verify CNAME record points to `<tunnel-id>.cfargotunnel.com`
- Ensure DNS is proxied (orange cloud)
- Wait for DNS propagation (can take a few minutes)

### Service not accessible
- Verify ingress controller is running
- Check ingress rules are configured
- Test ingress directly: `kubectl port-forward -n ingress-nginx svc/nginx-ingress-controller 8080:80`

