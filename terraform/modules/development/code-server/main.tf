resource "helm_release" "code_server" {
  name             = "code-server"
  repository       = "https://coder.github.io/charts"
  chart            = "code-server"
  version          = "4.89.1"
  namespace        = "code-server"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
