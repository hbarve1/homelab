resource "helm_release" "openldap" {
  name             = "openldap"
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "openldap"
  version          = "13.2.2"
  namespace        = "openldap"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
