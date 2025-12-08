# Example: Multiple Subdomains Through Single Tunnel
# This example shows how to route multiple subdomains through one tunnel
# All subdomains route to the ingress controller, which handles routing

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
#   # All route to ingress controller, which handles hostname-based routing
#   domain     = "hbarve1.com"
#   subdomains = [
#     "app",        # app.hbarve1.com
#     "api",        # api.hbarve1.com
#     "grafana",    # grafana.hbarve1.com
#     "prometheus", # prometheus.hbarve1.com
#     "nextcloud",  # nextcloud.hbarve1.com
#     "pihole"      # pihole.hbarve1.com
#   ]
#   
#   # High availability: Run multiple replicas across nodes
#   # Pods will be spread across different nodes automatically
#   replicas = 2
#   
#   # Ingress controller configuration (defaults shown)
#   ingress_host      = "nginx-ingress-controller.ingress-nginx.svc.cluster.local"
#   ingress_port      = 80
#   ingress_service   = "nginx-ingress-controller"
#   ingress_namespace = "ingress-nginx"
# }

# DNS Configuration in Cloudflare Dashboard:
# 
# For each subdomain, create a CNAME record pointing to the same tunnel:
# - Type: CNAME
# - Name: app (becomes app.hbarve1.com)
# - Target: <tunnel-id>.cfargotunnel.com
# - Proxy: Proxied (orange cloud) ✅
#
# Repeat for: api, grafana, prometheus, nextcloud, pihole
# All point to: <tunnel-id>.cfargotunnel.com
#
# Then in Zero Trust → Networks → Tunnels → Your Tunnel:
# Add Public Hostname for each:
# - Subdomain: app, Domain: hbarve1.com, Service: http://nginx-ingress-controller.ingress-nginx.svc.cluster.local:80
# - Subdomain: api, Domain: hbarve1.com, Service: http://nginx-ingress-controller.ingress-nginx.svc.cluster.local:80
# etc.
#
# OR use the simpler approach: Just add one catch-all route in tunnel config
# and let ingress controller handle all hostname-based routing

