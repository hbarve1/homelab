resource "helm_release" "etcd" {
  name             = "etcd"
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "etcd"
  version          = "10.7.2"
  namespace        = "etcd"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
