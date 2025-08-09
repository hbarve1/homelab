resource "helm_release" "mediawiki" {
  name             = "mediawiki"
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "mediawiki"
  version          = "14.2.2"
  namespace        = "mediawiki"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
