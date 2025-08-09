resource "helm_release" "mariadb" {
  name             = "mariadb"
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "mariadb"
  version          = "18.1.2"
  namespace        = "mariadb"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
