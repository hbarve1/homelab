resource "helm_release" "localstack" {
  name             = "localstack"
  repository       = "https://localstack.github.io/helm-charts"
  chart            = "localstack"
  version          = "0.6.26"
  namespace        = "localstack"
  create_namespace = true
}
