resource "helm_release" "rabbitmq_cluster_operator" {
  name             = "rabbitmq-cluster-operator"
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "rabbitmq-cluster-operator"
  version          = "4.0.2"
  namespace        = "rabbitmq-system"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
