// Networking and ingress modules
module "nginx-ingress" {
  source = "../networking/nginx-ingress"
}

module "istiod" {
  source = "../networking/istio"
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
