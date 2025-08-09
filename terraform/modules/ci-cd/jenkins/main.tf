resource "helm_release" "jenkins" {
  name             = "jenkins"
  repository       = "https://charts.jenkins.io"
  chart            = "jenkins"
  version          = "5.1.16"
  namespace        = "jenkins"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
