resource "helm_release" "github_actions_runner" {
  name             = "github-actions-runner"
  repository       = "https://actions-runner-controller.github.io/actions-runner-controller"
  chart            = "actions-runner-controller"
  version          = "0.26.2"
  namespace        = "github-actions-runner"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
