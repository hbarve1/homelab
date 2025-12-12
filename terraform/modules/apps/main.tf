module "simple_api_server" {
  source    = "./simple-api-server"
  namespace = var.namespace

  image_registry         = "ghcr.io"
  image_name             = "hbarve1/homelab/simple-api-server"
  image_tag              = "develop"
  image_pull_secret_name = var.ghcr_secret_name
  ingress_hosts          = ["api-1.hbarve1.com", "api-test.instanews.app"]
}
