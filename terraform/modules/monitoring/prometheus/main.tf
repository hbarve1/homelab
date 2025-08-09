resource "helm_release" "prometheus" {
  name             = "prometheus"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  version          = "58.7.1" # Updated to a valid version
  namespace        = "monitoring"
  create_namespace = true
}
