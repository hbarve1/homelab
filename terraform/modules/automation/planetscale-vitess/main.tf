resource "helm_release" "planetscale_vitess" {
  name             = "planetscale-vitess"
  repository       = "https://vitess-operator.io/helm"
  chart            = "vitess-operator"
  version          = "0.17.0"
  namespace        = "planetscale-vitess"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
