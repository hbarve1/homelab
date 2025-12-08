# Cloudflare Tunnel (cloudflared) Module

This module deploys Cloudflare Tunnel (cloudflared) in your Kubernetes cluster, providing stable, IP-independent access to your services through Cloudflare.

## Why Cloudflare Tunnel?

- ✅ **No IP dependencies** - Works regardless of cluster node IP changes
- ✅ **No port forwarding** - Creates outbound connections to Cloudflare
- ✅ **Stable URLs** - Your Cloudflare domain always works
- ✅ **Secure** - Traffic encrypted end-to-end
- ✅ **No public IP needed** - Perfect for homelabs behind NAT

## Architecture

```
Internet → Cloudflare → Cloudflare Tunnel → Kubernetes Ingress → Your Services
```

The tunnel runs as a pod in your cluster and connects outbound to Cloudflare, so you don't need to expose any ports or worry about IP changes.

## Prerequisites

1. **Cloudflare Account** with a domain
2. **Cloudflare Tunnel Created** - Get tunnel ID and credentials

### Step 1: Create Tunnel in Cloudflare

```bash
# Install cloudflared (if not already installed)
# macOS: brew install cloudflared
# Linux: Download from https://github.com/cloudflare/cloudflared/releases

# Login to Cloudflare
cloudflared tunnel login

# Create a tunnel
cloudflared tunnel create homelab-tunnel

# This will output:
# - Tunnel ID (e.g., abc12345-6789-0123-4567-890123456789)
# - Credentials file location
```

### Step 2: Get Tunnel Credentials

The credentials file is typically at:
- **macOS/Linux:** `~/.cloudflared/<tunnel-id>.json`
- Contains: `{"AccountTag":"...","TunnelID":"...","TunnelSecret":"..."}`

Read it:
```bash
cat ~/.cloudflared/<tunnel-id>.json
```

### Step 3: Configure DNS Routes in Cloudflare Dashboard

1. Go to Cloudflare Dashboard → Zero Trust → Networks → Tunnels
2. Select your tunnel
3. Configure Public Hostnames:
   - **Subdomain:** `app` (or your service name)
   - **Domain:** `yourdomain.com`
   - **Service:** `http://nginx-ingress-controller.ingress-nginx.svc.cluster.local:80`
   - **Path:** (optional, e.g., `/`)

Or use the Terraform module to configure routes automatically.

## Usage

### Basic Example

```hcl
module "cloudflare_tunnel" {
  source = "../../modules/networking/cloudflare-tunnel"
  
  namespace              = "cloudflare-tunnel"
  tunnel_id              = "abc12345-6789-0123-4567-890123456789"
  tunnel_credentials_json = file("~/.cloudflared/abc12345-6789-0123-4567-890123456789.json")
  
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
}
```

### Advanced Example with Multiple Routes

```hcl
module "cloudflare_tunnel" {
  source = "../../modules/networking/cloudflare-tunnel"
  
  namespace              = "cloudflare-tunnel"
  tunnel_id              = var.cloudflare_tunnel_id
  tunnel_credentials_json = var.cloudflare_tunnel_credentials
  
  ingress_host     = "nginx-ingress-controller.ingress-nginx.svc.cluster.local"
  ingress_port     = 80
  ingress_service  = "nginx-ingress-controller"
  ingress_namespace = "ingress-nginx"
  
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
  
  replicas = 2  # For high availability
}
```

## How It Works

1. **Tunnel Pod** runs in your cluster
2. **Connects outbound** to Cloudflare (no inbound ports needed)
3. **Routes traffic** based on hostname to your ingress controller
4. **Ingress controller** routes to your services based on ingress rules

## Integration with Existing Setup

Your existing ingress rules work as-is. The tunnel just forwards traffic to your ingress controller:

```
Cloudflare → Tunnel → Ingress Controller → Your Services
```

Your ingress can still handle:
- Multiple hostnames
- Path-based routing
- TLS termination
- Both external (Cloudflare) and local domains

## DNS Configuration

### In Cloudflare Dashboard

For each service, create a CNAME record:
- **Type:** CNAME
- **Name:** `app` (or your subdomain)
- **Target:** `<tunnel-id>.cfargotunnel.com`
- **Proxy:** Proxied (orange cloud)

### Or Use Cloudflare API/Terraform

```hcl
# Example: Create DNS record pointing to tunnel
resource "cloudflare_record" "app" {
  zone_id = var.cloudflare_zone_id
  name    = "app"
  type    = "CNAME"
  content = "${var.tunnel_id}.cfargotunnel.com"
  proxied = true
}
```

## Troubleshooting

### Tunnel not connecting

```bash
# Check tunnel pod logs
kubectl logs -n cloudflare-tunnel -l app=cloudflare-tunnel

# Check pod status
kubectl get pods -n cloudflare-tunnel
```

### Routes not working

1. Verify DNS records point to `<tunnel-id>.cfargotunnel.com`
2. Check routes in Cloudflare Dashboard → Zero Trust → Networks → Tunnels
3. Verify ingress controller is accessible from tunnel pod:
   ```bash
   kubectl exec -n cloudflare-tunnel <tunnel-pod> -- \
     curl http://nginx-ingress-controller.ingress-nginx.svc.cluster.local:80
   ```

### Service not accessible

- Verify ingress rules are configured correctly
- Check ingress controller logs
- Ensure service is running and healthy

## Security Considerations

- **Tunnel credentials** are stored as Kubernetes secrets (encrypted at rest)
- **Traffic is encrypted** between Cloudflare and your cluster
- **No public IP exposure** - only outbound connections
- Consider using **Cloudflare Access** for additional authentication

## Benefits Over Traditional Setup

| Traditional (Port Forwarding) | Cloudflare Tunnel |
|-------------------------------|-------------------|
| Requires public IP | ✅ No public IP needed |
| IP changes break access | ✅ IP-independent |
| Port forwarding required | ✅ No ports to forward |
| Firewall configuration | ✅ No firewall rules |
| Dynamic DNS needed | ✅ Stable domain |

## Next Steps

1. Deploy the tunnel module
2. Configure DNS records in Cloudflare
3. Test access via your Cloudflare domain
4. Your services are now accessible regardless of IP changes!

