# Example: Cloudflare Tunnel Configuration with Multiple Subdomains
# Add this to terraform/environments/prod/main.tf

# Option 1: Simple - Use subdomains list (recommended)
# All subdomains route to ingress controller, which handles routing
# NOTE: This example module is commented out so Terraform does not try to load it from within the module directory.
# Copy into your environment (e.g., terraform/environments/prod/main.tf) and uncomment there.
# module "cloudflare_tunnel" {
#   source = "../../modules/networking/cloudflare-tunnel"
#   
#   namespace              = "cloudflare-tunnel"
#   tunnel_id              = var.cloudflare_tunnel_id
#   tunnel_credentials_json = var.cloudflare_tunnel_credentials_json
#   
#   # Multiple subdomains through same tunnel
#   domain     = "hbarve1.com"
#   subdomains = [
#     "app",
#     "api",
#     "grafana",
#     "prometheus",
#     "nextcloud",
#     "pihole"
#   ]
#   
#   # High availability: Run multiple replicas across nodes
#   replicas = 2
# }

# Option 2: Explicit routes (more control)
# module "cloudflare_tunnel" {
#   source = "../../modules/networking/cloudflare-tunnel"
#   
#   namespace              = "cloudflare-tunnel"
#   tunnel_id              = var.cloudflare_tunnel_id
#   tunnel_credentials_json = var.cloudflare_tunnel_credentials_json
#   
#   routes = [
#     {
#       hostname = "app.hbarve1.com"
#       service  = "http://nginx-ingress-controller.ingress-nginx.svc.cluster.local:80"
#     },
#     {
#       hostname = "api.hbarve1.com"
#       service  = "http://nginx-ingress-controller.ingress-nginx.svc.cluster.local:80"
#     }
#   ]
#   
#   replicas = 2  # For HA across multiple nodes
# }

# Setup Steps:
# 1. Create tunnel: cloudflared tunnel create homelab-tunnel
# 2. Get tunnel ID and credentials JSON
# 3. Add to terraform.tfvars:
#    cloudflare_tunnel_id = "your-tunnel-id"
#    cloudflare_tunnel_credentials_json = file("~/.cloudflared/your-tunnel-id.json")
# 4. Configure DNS in Cloudflare Dashboard:
#    - Create CNAME: app.hbarve1.com -> <tunnel-id>.cfargotunnel.com
#    - Or use Cloudflare API/Terraform to create DNS records
# 5. Deploy: terraform apply

