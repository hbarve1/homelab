resource "helm_release" "argo_workflows" {
  name             = "argo-workflows"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-workflows"
  version          = "0.45.15"
  namespace        = "argo-workflows"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
