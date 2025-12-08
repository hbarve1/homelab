resource "helm_release" "openebs" {
  name             = "openebs"
  repository       = "https://openebs.github.io/openebs"
  chart            = "openebs"
  version          = "4.4.0"
  namespace        = "openebs"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]

  # Don't wait for all pods to be ready - OpenEBS can take time to fully initialize
  # The storage classes will be available once core components are running
  wait = false
  timeout = 600
  
  # Allow partial failures - some pods may take longer to start
  atomic = false
}

