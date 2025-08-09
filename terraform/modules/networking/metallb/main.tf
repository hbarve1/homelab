resource "helm_release" "metallb" {
  name             = "metallb"
  repository       = "https://metallb.github.io/metallb"
  chart            = "metallb"
  version          = "0.14.5"
  namespace        = "metallb-system"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
