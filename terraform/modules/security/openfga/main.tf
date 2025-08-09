resource "helm_release" "openfga" {
  name             = "openfga"
  repository       = "https://openfga.github.io/helm-charts"
  chart            = "openfga"
  version          = "0.2.30"
  namespace        = "openfga"
  create_namespace = true
  # set values as needed, e.g. persistence, env, etc.
}
