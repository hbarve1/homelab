resource "helm_release" "n8n" {
  name             = "n8n"
  repository       = "https://community-charts.github.io/helm-charts"
  chart            = "n8n"
  version          = "0.1.4" # Use the latest available version if needed
  # set values as needed, e.g. persistence, env, etc.
  namespace        = var.namespace
}
