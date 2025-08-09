resource "helm_release" "tekton" {
  name             = "tekton"
  repository       = "https://cdfoundation.github.io/tekton-helm-chart/"
  chart            = "tekton-pipeline"
  version          = "0.50.2"
  namespace        = "tekton-pipelines"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
