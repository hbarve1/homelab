resource "helm_release" "traefik" {
  name             = "traefik"
  repository       = "https://traefik.github.io/charts"
  chart            = "traefik"
  version          = "28.2.0"
  namespace        = "traefik"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
