resource "helm_release" "gitlab" {
  name             = "gitlab"
  repository       = "https://charts.gitlab.io/"
  chart            = "gitlab"
  version          = "7.11.2"
  namespace        = "gitlab"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
