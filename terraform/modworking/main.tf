resource "helm_release" "haproxy" {
  name             = "haproxy"
  repository       = "https://haproxytech.github.io/helm-charts"
  chart            = "kubernetes-ingress"
  version          = "1.34.5"
  namespace        = "haproxy-controller"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
