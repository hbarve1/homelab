resource "helm_release" "n8n" {
  name             = "n8n"
  repository       = "https://community-charts.github.io/helm-charts"
  chart            = "n8n"
  version          = "1.16.7"
  namespace        = var.namespace
}
