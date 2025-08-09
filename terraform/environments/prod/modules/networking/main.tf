module "nginx_ingress" {
  source           = "../../../../modules/networking/nginx-ingress"
  namespace         = var.namespace
}
