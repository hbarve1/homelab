resource "helm_release" "percona_xtrabackup" {
  name             = "percona-xtrabackup"
  repository       = "https://percona.github.io/percona-helm-charts/"
  chart            = "xtradb-cluster"
  version          = "1.15.0"
  namespace        = "percona-xtrabackup"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
