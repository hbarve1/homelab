resource "helm_release" "questdb" {
  name             = "questdb"
  repository       = "https://helm.questdb.io/"
  chart            = "questdb"
  version          = "0.34.0"
  namespace        = "questdb"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
