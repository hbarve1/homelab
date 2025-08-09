resource "helm_release" "nexus" {
  name             = "nexus"
  repository       = "https://sonatype.github.io/helm3-charts/"
  chart            = "nexus-repository-manager"
  version          = "58.1.0"
  namespace        = "nexus"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
