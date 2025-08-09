resource "helm_release" "drupal" {
  name             = "drupal"
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "drupal"
  version          = "15.2.2"
  namespace        = "drupal"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
