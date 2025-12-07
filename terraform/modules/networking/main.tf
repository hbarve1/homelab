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
