resource "helm_release" "kubeflow" {
  name             = "kubeflow"
  repository       = "https://kubeflow.github.io/manifests"
  chart            = "kubeflow"
  version          = "1.8.0"
  namespace        = "kubeflow"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
