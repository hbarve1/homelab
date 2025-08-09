resource "helm_release" "vault" {
  name             = "vault"
  repository       = "https://helm.releases.hashicorp.com"
  chart            = "vault"
  version          = "0.28.0"
  namespace        = "vault"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
