resource "helm_release" "gitea" {
  name             = "gitea"
  repository       = "https://dl.gitea.io/charts/"
  chart            = "gitea"
  version          = "12.4.0"
  namespace        = "gitea"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
