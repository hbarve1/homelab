# Cloudflare Tunnel Setup for Stable Access

This guide explains how to set up Cloudflare Tunnel (cloudflared) to provide stable, IP-independent access to your Kubernetes services.

## Problem Solved

**Before:** Services accessible only via specific node IP, breaks when IP changes  
**After:** Services accessible via stable Cloudflare domain, works regardless of IP changes

## Architecture

```
┌─────────────┐
│   Internet  │
└──────┬──────┘
       │
       │ HTTPS: app.yourdomain.com
       ▼
┌─────────────────┐
│   Cloudflare    │  ← DNS + Proxy
│   (yourdomain)  │
└──────┬──────────┘
       │
       │ Tunnel Connection (outbound)
       ▼
┌─────────────────┐
│ Cloudflare      │  ← Runs in Kubernetes
│ Tunnel Pod      │     Connects outbound to Cloudflare
└──────┬──────────┘
       │
       │ HTTP: nginx-ingress-controller
       ▼
┌─────────────────┐
│ Nginx Ingress   │  ← Routes based on hostname
│ Controller       │
└──────┬──────────┘
       │
       ▼
┌─────────────────┐
│ Your Services   │
└─────────────────┘
```

## Key Benefits

- ✅ **No IP dependencies** - Works even if cluster IP changes
- ✅ **No port forwarding** - Only outbound connections needed
- ✅ **Stable URLs** - Your Cloudflare domain always works
- ✅ **Secure** - Traffic encrypted end-to-end
- ✅ **Works behind NAT** - Perfect for homelabs

## Setup Steps

### Step 1: Create Cloudflare Tunnel

```bash
# Install cloudflared (if not installed)
brew install cloudflared  # macOS
# or download from: https://github.com/cloudflare/cloudflared/releases

# Login to Cloudflare
cloudflared tunnel login

# Create tunnel
cloudflared tunnel create homelab-tunnel

# Note the Tunnel ID (e.g., abc12345-6789-0123-4567-890123456789)
# Credentials saved to: ~/.cloudflared/<tunnel-id>.json
```

### Step 2: Get Tunnel Credentials

```bash
# View credentials
cat ~/.cloudflared/<tunnel-id>.json

# Save the JSON content - you'll need it for Terraform
```

### Step 3: Configure DNS in Cloudflare

For each service, create a CNAME record:

1. Go to Cloudflare Dashboard → Your Domain → DNS
2. Add CNAME:
   - **Name:** `app` (or your subdomain)
   - **Target:** `<tunnel-id>.cfargotunnel.com`
   - **Proxy:** Proxied (orange cloud) ✅
   - **TTL:** Auto

3. Go to Zero Trust → Networks → Tunnels → Your Tunnel
4. Add Public Hostname:
   - **Subdomain:** `app`
   - **Domain:** `yourdomain.com`
   - **Service:** `http://nginx-ingress-controller.ingress-nginx.svc.cluster.local:80`

### Step 4: Deploy Tunnel in Kubernetes

Add to `terraform/environments/prod/main.tf`:

```hcl
module "cloudflare_tunnel" {
  source = "../../modules/networking/cloudflare-tunnel"
  
  namespace              = "cloudflare-tunnel"
  tunnel_id              = var.cloudflare_tunnel_id
  tunnel_credentials_json = var.cloudflare_tunnel_credentials_json
  
  # Route all traffic to ingress controller
  # Ingress will handle hostname-based routing
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

Add to `terraform.tfvars`:

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
3. **Cloudflare routes** traffic based on DNS/hostname
4. **Tunnel forwards** to your ingress controller
5. **Ingress routes** to your services based on ingress rules

## Integration with Existing Setup

Your existing ingress configuration works as-is:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: app-ingress
spec:
  ingressClassName: nginx
  rules:
    - host: app.yourdomain.com  # ← Cloudflare Tunnel routes here
      http:
        paths:
          - path: /
            backend:
              service:
                name: app-service
                port:
                  number: 80
```

The tunnel just forwards traffic to your ingress - no changes needed to your services!

## Multiple Services

You can expose multiple services through the same tunnel:

```hcl
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
```

All routes go to the same ingress controller, which handles routing based on hostname.

## Troubleshooting

### Tunnel not connecting
```bash
# Check pod logs
kubectl logs -n cloudflare-tunnel -l app=cloudflare-tunnel

# Verify credentials
kubectl get secret -n cloudflare-tunnel cloudflare-tunnel-credentials -o jsonpath='{.data.credentials}' | base64 -d
```

### DNS not resolving
- Verify CNAME points to `<tunnel-id>.cfargotunnel.com`
- Ensure DNS is proxied (orange cloud)
- Wait for DNS propagation

### Service not accessible
- Check ingress controller is running
- Verify ingress rules match hostname
- Test ingress directly: `kubectl port-forward -n ingress-nginx svc/nginx-ingress-controller 8080:80`

## Comparison

| Traditional Setup | Cloudflare Tunnel |
|------------------|-------------------|
| Requires public IP | ✅ No public IP needed |
| IP changes break access | ✅ IP-independent |
| Port forwarding required | ✅ No ports to forward |
| Firewall configuration | ✅ No firewall rules |
| Dynamic DNS needed | ✅ Stable domain |

## Next Steps

- Deploy tunnel module
- Configure DNS records
- Test access via Cloudflare domain
- Your services are now accessible regardless of IP changes!

