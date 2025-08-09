resource "helm_release" "keycloak" {
  name             = "keycloak"
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "keycloak"
  version          = "21.2.2"
  namespace        = "keycloak"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
