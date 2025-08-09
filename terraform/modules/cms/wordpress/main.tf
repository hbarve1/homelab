resource "helm_release" "wordpress" {
  name             = "wordpress"
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "wordpress"
  version          = "19.2.2"
  namespace        = "wordpress"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
