resource "helm_release" "linkerd" {
  name             = "linkerd"
  repository       = "https://helm.linkerd.io/stable"
  chart            = "linkerd-control-plane"
  version          = "1.16.12"
  namespace        = "linkerd"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
