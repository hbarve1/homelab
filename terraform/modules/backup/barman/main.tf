resource "helm_release" "barman" {
  name             = "barman"
  repository       = "https://enterprisedb.github.io/helm-charts"
  chart            = "barman"
  version          = "2.7.0"
  namespace        = "barman"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
