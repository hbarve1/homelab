resource "kubernetes_secret_v1" "ghcr_secret" {
  metadata {
    name      = var.ghcr_secret_name
    namespace = var.namespace
  }

  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "ghcr.io" = {
          username = var.github_username
          password = var.github_pat
          auth     = base64encode("${var.github_username}:${var.github_pat}")
        }
      }
    })
  }
}
