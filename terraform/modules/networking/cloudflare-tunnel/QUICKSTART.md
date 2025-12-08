# Cloudflare Tunnel Quick Start

## What This Solves

**Problem:** Your services are only accessible via specific node IP, breaks when IP changes  
**Solution:** Cloudflare Tunnel provides stable access via your Cloudflare domain, regardless of IP changes

## 5-Minute Setup

### Step 1: Create Tunnel (One-time)

```bash
# Install cloudflared
brew install cloudflared  # macOS

# Login to Cloudflare
cloudflared tunnel login

# Create tunnel
cloudflared tunnel create homelab-tunnel

# Save the Tunnel ID (e.g., abc12345-6789-0123-4567-890123456789)
```

### Step 2: Get Credentials

```bash
# Credentials are saved to:
cat ~/.cloudflared/<tunnel-id>.json

# Copy the entire JSON - you'll need it for Terraform
```

### Step 3: Configure DNS in Cloudflare Dashboard

1. **DNS Records (for each subdomain):**
   - Go to Cloudflare Dashboard → Your Domain → DNS
   - Add CNAME: `app` → `<tunnel-id>.cfargotunnel.com` (Proxied ✅)
   - Add CNAME: `api` → `<tunnel-id>.cfargotunnel.com` (Proxied ✅)
   - Add more as needed...

2. **Tunnel Routes:**
   - Go to Zero Trust → Networks → Tunnels → Your Tunnel
   - Add Public Hostname (catch-all):
     - Subdomain: `*` (wildcard for all subdomains)
     - Domain: `yourdomain.com`
     - Service: `http://nginx-ingress-controller.ingress-nginx.svc.cluster.local:80`

### Step 4: Add to Terraform

**terraform/environments/prod/main.tf:**
```hcl
module "cloudflare_tunnel" {
  source = "../../modules/networking/cloudflare-tunnel"
  
  namespace              = "cloudflare-tunnel"
  tunnel_id              = var.cloudflare_tunnel_id
  tunnel_credentials_json = var.cloudflare_tunnel_credentials_json
  
  # Multiple subdomains through same tunnel (recommended)
  domain     = "yourdomain.com"
  subdomains = [
    "app",
    "api",
    "grafana",
    "prometheus"
  ]
  
  # High availability: Multiple replicas across nodes
  replicas = 2
}
```

**Alternative: Explicit Routes**
```hcl
routes = [
  {
    hostname = "app.yourdomain.com"
    service  = "http://nginx-ingress-controller.ingress-nginx.svc.cluster.local:80"
  }
]
```

**terraform/environments/prod/variables.tf** (add if not exists):
```hcl
variable "cloudflare_tunnel_id" {
  description = "Cloudflare Tunnel ID"
  type        = string
  sensitive   = true
}

variable "cloudflare_tunnel_credentials_json" {
  description = "Cloudflare Tunnel credentials JSON"
  type        = string
  sensitive   = true
}
```

**terraform/environments/prod/terraform.tfvars:**
```hcl
cloudflare_tunnel_id = "your-tunnel-id-here"
cloudflare_tunnel_credentials_json = file("~/.cloudflared/your-tunnel-id.json")
```

### Step 5: Deploy

```bash
cd terraform/environments/prod
terraform init
terraform plan
terraform apply
```

### Step 6: Verify

```bash
# Check tunnel pod
kubectl get pods -n cloudflare-tunnel

# Check logs (should show "Connection established")
kubectl logs -n cloudflare-tunnel -l app=cloudflare-tunnel

# Test access
curl https://app.yourdomain.com
```

## How It Works

1. **Tunnel Pod** runs in your cluster
2. **Connects outbound** to Cloudflare (no inbound ports needed)
3. **Cloudflare routes** `app.yourdomain.com` → Tunnel
4. **Tunnel forwards** → Ingress Controller
5. **Ingress routes** → Your Service

## Multiple Services / Subdomains

**Recommended: Use subdomains list**
```hcl
domain     = "yourdomain.com"
subdomains = ["app", "api", "grafana", "prometheus"]
```

**Alternative: Explicit routes**
```hcl
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
```

Then create DNS records for each in Cloudflare Dashboard. All subdomains route through the same tunnel.

**High Availability:** Set `replicas = 2` (or more) to spread pods across multiple nodes.

## Benefits

✅ **No IP changes** - Works regardless of cluster IP  
✅ **No port forwarding** - Only outbound connections  
✅ **Stable URLs** - Your domain always works  
✅ **Secure** - Encrypted end-to-end  
✅ **Multiple subdomains** - One tunnel handles all  
✅ **High availability** - Multiple replicas across nodes  

## Troubleshooting

**Tunnel not connecting:**
```bash
kubectl logs -n cloudflare-tunnel -l app=cloudflare-tunnel
```

**DNS not resolving:**
- Verify CNAME points to `<tunnel-id>.cfargotunnel.com`
- Ensure DNS is proxied (orange cloud)

**Service not accessible:**
- Check ingress controller is running
- Verify ingress rules match hostname

