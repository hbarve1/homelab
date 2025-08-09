resource "helm_release" "nats" {
  name             = "nats"
  repository       = "https://nats-io.github.io/k8s/helm/charts/"
  chart            = "nats"
  version          = "1.1.12"
  namespace        = "nats"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
