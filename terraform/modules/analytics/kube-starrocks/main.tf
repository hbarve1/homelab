resource "helm_release" "kube_starrocks" {
  name             = "kube-starrocks"
  repository       = "https://starrocks.github.io/helm-charts/"
  chart            = "kube-starrocks"
  version          = "3.2.6"
  namespace        = "kube-starrocks"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
