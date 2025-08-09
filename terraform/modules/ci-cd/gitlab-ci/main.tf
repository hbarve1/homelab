resource "helm_release" "gitlab_ci" {
  name             = "gitlab-ci"
  repository       = "https://charts.gitlab.io/"
  chart            = "gitlab-runner"
  version          = "0.62.2"
  namespace        = "gitlab-ci"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
