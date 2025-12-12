module "simple_api_server" {
  source = "./simple-api-server"
  namespace = var.namespace

  image_registry          = "ghcr.io"
  image_name              = "hbarve1/homelab/simple-api-server"
  image_tag               = "develop"
  image_pull_secret_name  = "ghcr-secret"
  ingress_enabled         = true
  ingress_host            = "api-1.hbarve1.com"
  ingress_class_name      = "nginx"
  replicas                = 1
  environment             = "production"
  resources_requests_cpu  = "50m"
  resources_requests_memory = "64Mi"
  resources_limits_cpu    = "200m"
  resources_limits_memory = "128Mi"
}
