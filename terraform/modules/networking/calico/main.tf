resource "helm_release" "calico" {
  name             = "calico"
  repository       = "https://projectcalico.docs.tigera.io/charts"
  chart            = "tigera-operator"
  version          = "3.27.3"
  namespace        = "calico-system"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
