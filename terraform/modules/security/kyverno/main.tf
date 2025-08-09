resource "helm_release" "kyverno" {
  name             = "kyverno"
  repository       = "https://kyverno.github.io/kyverno/"
  chart            = "kyverno"
  version          = "v3.1.2"  # Latest stable version as of May 2025
  namespace        = "kyverno"
  create_namespace = true
  wait            = true
  timeout         = 300  # 5 minutes

  set {
    name  = "installCRDs"
    value = "true"
  }

  values = [
    file("${path.module}/values.yaml")
  ]

  depends_on = [
    kubernetes_namespace.kyverno
  ]
}

resource "kubernetes_namespace" "kyverno" {
  metadata {
    name = "kyverno"
    labels = {
      "app.kubernetes.io/component" = "kyverno"
      "app.kubernetes.io/name"      = "kyverno"
    }
  }
}
