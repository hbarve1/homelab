resource "helm_release" "jupyter" {
  name             = "jupyter"
  repository       = "https://jupyterhub.github.io/helm-chart/"
  chart            = "jupyterhub"
  version          = "3.4.8"
  namespace        = "jupyter"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
