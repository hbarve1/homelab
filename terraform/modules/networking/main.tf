// Networking and ingress modules
# module "nginx-ingress" {
#   source = "../networking/nginx-ingress"
# }

# module "istiod" {
#   source = "../networking/istio"
# }

// Local DNS - Pi-hole
module "pihole" {
  source    = "./pihole"
  namespace = var.namespace
  
  web_password                  = var.pihole_password
  timezone                      = var.timezone
  local_domain                  = var.local_domain
  router_ip                     = var.router_ip
  enable_conditional_forwarding = var.enable_conditional_forwarding
  service_type                  = var.dns_service_type
  ingress_enabled               = var.dns_ingress_enabled
  ingress_host                  = var.dns_ingress_host
}

// Cloudflare Tunnel - Multiple subdomains through single tunnel
module "cloudflare_tunnel" {
  count = var.cloudflare_tunnel_enabled ? 1 : 0
  
  source = "./cloudflare-tunnel"
  
  namespace              = var.cloudflare_tunnel_namespace
  tunnel_id              = var.cloudflare_tunnel_id
  tunnel_credentials_json = var.cloudflare_tunnel_credentials_json
  
  # Multiple subdomains through same tunnel
  domain     = "hbarve1.com"
  subdomains = var.cloudflare_tunnel_subdomains
  
  # High availability: Multiple replicas across nodes
  replicas = var.cloudflare_tunnel_replicas
}

# Run this on original k8s cluster
# module "cilium" {
#   source = "../networking/cilium"
# }

# module "haproxy" {
#   source = "../../modules/network/haproxy"
# }

# module "envoy" {
#   source = "../../modules/network/envoy"
# }

# module "metallb" {
#   source = "../../modules/network/metallb"
# }

# module "calico" {
#   source = "../../modules/network/calico"
# }

# module "flannel" {
#   source = "../../modules/network/flannel"
# }

# module "harbor" {
#   source = "../../modules/development/harbor"
# }
