resource "helm_release" "minio" {
  name             = "minio"
  repository       = "https://charts.min.io/"
  chart            = "minio"
  version          = "5.0.15" # Use the latest available version if needed
  namespace        = "minio"
  create_namespace = true
  set {
    name  = "rootUser"
    value = "minioadmin"
  }
  set {
    name  = "rootPassword"
    value = "minioadmin"
  }
  set {
    name  = "mode"
    value = "standalone"
  }
  set {
    name  = "persistence.enabled"
    value = "true"
  }
}
