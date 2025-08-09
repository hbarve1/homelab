resource "helm_release" "localstack" {
  name             = "localstack"
  repository       = "https://localstack.github.io/helm-charts"
  chart            = "localstack"
  version          = "0.6.7" # Use the latest available version if needed
  namespace        = "localstack"
  create_namespace = true
  # set values as needed, e.g. persistence, env, etc.
}
