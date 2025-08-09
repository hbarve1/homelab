resource "helm_release" "stash" {
  name             = "stash"
  repository       = "https://charts.appscode.com/stable/"
  chart            = "stash-community"
  version          = "2024.4.18"
  namespace        = "stash"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
