# Local Network Access Setup Guide (Kubernetes/Terraform)

This guide explains how to set up local network access for your homelab services using Terraform and Kubernetes (MicroK8s), allowing you to access them using friendly domain names from your local network while maintaining Cloudflare access for external connections.

## Overview

You'll have two access methods:
- **External Access:** Via Cloudflare using your public domain (e.g., `app.yourdomain.com`)
- **Local Access:** Via local DNS using local domain (e.g., `app.homelab.local`)

## Architecture

```
┌─────────────────┐
│  Local Devices  │
│  (192.168.1.x)  │
└────────┬────────┘
         │
         │ DNS Query: app.homelab.local
         ▼
┌─────────────────┐
│  Local DNS      │  ← Pi-hole/AdGuard in Kubernetes
│  (Pi-hole/      │     Resolves to local IP
│   AdGuard)      │
└────────┬────────┘
         │
         │ HTTP Request
         ▼
┌─────────────────┐
│  Nginx Ingress  │  ← Accepts both domains
│  Controller     │     (app.yourdomain.com OR app.homelab.local)
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Your Services  │
│  (Kubernetes)   │
└─────────────────┘
```

## Step 1: Deploy Pi-hole DNS Server

1. **Add to your environment** (`terraform/environments/prod/main.tf`):

```hcl
module "dns_pihole" {
  source    = "../../modules/networking/pihole"
  namespace = kubernetes_namespace.networking.metadata[0].name
  
  web_password                  = var.pihole_password  # Set in terraform.tfvars
  timezone                     = "America/New_York"    # Your timezone
  local_domain                  = "homelab.local"
  router_ip                     = "192.168.1.1"        # Your router IP
  enable_conditional_forwarding = true
  service_type                  = "LoadBalancer"        # Or "NodePort" for MicroK8s
  storage_class                 = "microk8s-hostpath"   # Your storage class
  ingress_enabled               = true
  ingress_host                  = "pihole.homelab.local"
}
```

2. **Add variable to `terraform.tfvars`**:
```hcl
pihole_password = "your_secure_password_here"
```

3. **Deploy**:
```bash
cd terraform/environments/prod
terraform init
terraform plan
terraform apply
```

## Step 2: Get DNS Service IP

After deployment, get the DNS service IP:

```bash
kubectl get svc -n <networking-namespace> pihole
```

Note the `EXTERNAL-IP` or use `NodePort` if using NodePort service type.

## Step 3: Configure Router/Device DNS

### Option A: Configure Router (Recommended)

1. Access your router admin panel (usually `192.168.1.1`)
2. Navigate to DNS settings
3. Set primary DNS to your Pi-hole/AdGuard IP (e.g., `192.168.1.100`)
4. Set secondary DNS to a public DNS (e.g., `8.8.8.8`)

This ensures all devices on your network automatically use local DNS.

### Option B: Configure Individual Devices

**macOS:**
- System Preferences → Network
- Select connection → Advanced → DNS
- Add DNS server: `<dns-service-ip>`

**Windows:**
- Settings → Network & Internet → Change adapter options
- Right-click network adapter → Properties
- IPv4 Properties → Use custom DNS: `<dns-service-ip>`

**Linux:**
- Edit `/etc/resolv.conf` or use NetworkManager
- Add: `nameserver <dns-service-ip>`

## Step 4: Add DNS Records

1. Access Pi-hole web interface:
   - Via ingress: `http://pihole.homelab.local`
   - Or port-forward: `kubectl port-forward -n <namespace> svc/pihole 8080:80`

2. Navigate to **Local DNS Records** → **DNS Records**

3. Add entries:
   ```
   Domain: app.homelab.local → IP: <your-ingress-ip>
   Domain: api.homelab.local → IP: <your-ingress-ip>
   Domain: grafana.homelab.local → IP: <your-ingress-ip>
   Domain: prometheus.homelab.local → IP: <your-ingress-ip>
   ```

## Step 5: Update Ingress for Dual Domains

Update your service ingress configurations to accept both external and local domains.

### Example: Using Terraform Template

Update your ingress template files (e.g., `neo4j-ingress.yaml.tpl`):

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ${service_name}-ingress
  namespace: ${namespace}
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
    nginx.ingress.kubernetes.io/backend-protocol: "HTTP"
    nginx.ingress.kubernetes.io/server-alias: "${service_name}.homelab.local"
spec:
  ingressClassName: nginx
  rules:
    # External domain (via Cloudflare)
    - host: ${external_host}
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: ${service_name}
                port:
                  number: ${service_port}
    # Local domain (via local DNS)
    - host: ${service_name}.homelab.local
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: ${service_name}
                port:
                  number: ${service_port}
  tls:
    - hosts:
        - ${external_host}
      secretName: ${service_name}-tls-secret
```

### Example: Direct Kubernetes Manifest

See `terraform/modules/networking/ingress-dual-domain-example.yaml` for complete examples.

## Step 6: SSL/TLS for Local Domains

Since `.local` domains can't get Let's Encrypt certificates, you have options:

### Option A: Use HTTP for Local Access
- Simple but not secure
- Good for internal network only
- Set `nginx.ingress.kubernetes.io/ssl-redirect: "false"` for local ingress

### Option B: Self-Signed Certificates
Generate self-signed certs:

```bash
# Generate self-signed certificate
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout homelab.local.key \
  -out homelab.local.crt \
  -subj "/CN=*.homelab.local"

# Create Kubernetes secret
kubectl create secret tls homelab-local-tls \
  --cert=homelab.local.crt \
  --key=homelab.local.key \
  -n <namespace>
```

### Option C: Use mkcert for Local CA
```bash
# Install mkcert
brew install mkcert  # macOS
# or: apt install mkcert  # Linux

# Create local CA
mkcert -install

# Generate certificate
mkcert "*.homelab.local" "homelab.local"

# Create Kubernetes secret
kubectl create secret tls homelab-local-tls \
  --cert=_wildcard.homelab.local+2.pem \
  --key=_wildcard.homelab.local+2-key.pem \
  -n <namespace>
```

## Step 7: Test Your Setup

1. **Test DNS Resolution:**
   ```bash
   # Should resolve to your local IP
   nslookup app.homelab.local
   dig app.homelab.local
   ```

2. **Test HTTP Access:**
   ```bash
   curl http://app.homelab.local
   # or open in browser
   ```

3. **Verify Both Domains Work:**
   - External: `https://app.yourdomain.com` (via Cloudflare)
   - Local: `http://app.homelab.local` (via local DNS)

## MicroK8s Specific Notes

### Storage Class
Use `microk8s-hostpath` or your configured storage class:
```hcl
storage_class = "microk8s-hostpath"
```

### Service Type
- **LoadBalancer:** Works if you have MetalLB enabled in MicroK8s
- **NodePort:** Alternative if LoadBalancer isn't available

Enable MetalLB in MicroK8s:
```bash
microk8s enable metallb
# Follow prompts to set IP range
```

### Get Service IP
```bash
# For LoadBalancer
kubectl get svc -n <namespace> pihole

# For NodePort, get node IP
kubectl get nodes -o wide
# Then access via <node-ip>:<nodeport>
```

## Troubleshooting

### DNS Not Resolving
- Verify DNS server is running: `kubectl get pods -n <namespace> | grep pihole`
- Check device/router DNS settings
- Test DNS directly: `dig @<dns-ip> app.homelab.local`

### Services Not Accessible
- Verify ingress accepts local domain: `kubectl describe ingress -n <namespace>`
- Check firewall rules allow local network access
- Verify service is running: `kubectl get pods -n <namespace>`

### SSL Certificate Errors (Local)
- Accept self-signed certificate in browser
- Or use HTTP for local access
- Or set up mkcert for trusted local certificates

## Advanced: Split-Horizon DNS

For advanced setups, you can use the same domain for both internal and external access:

1. Configure Cloudflare DNS for external access
2. Configure local DNS to override for internal access
3. Use same domain name (e.g., `app.yourdomain.com`)
4. Internal requests resolve to local IP, external to Cloudflare

This requires careful DNS configuration but provides seamless experience.

## Security Considerations

- **Local Network:** Consider using HTTPS even for local access
- **Firewall:** Ensure services aren't exposed unnecessarily
- **Access Control:** Use authentication even for local services
- **Network Segmentation:** Consider VLANs for better security

## Next Steps

- Set up monitoring for DNS server
- Configure automatic DNS record updates
- Set up backup DNS server for redundancy
- Document all your service URLs

