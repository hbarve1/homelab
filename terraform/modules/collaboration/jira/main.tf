resource "helm_release" "jira" {
  name             = "jira"
  repository       = "https://atlassian.github.io/data-center-helm-charts/"
  chart            = "jira"
  version          = "1.19.0"
  namespace        = "jira"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
