# GitHub Container Registry Image Pull Secret
# This creates a Kubernetes secret for pulling private images from GitHub Container Registry (ghcr.io)
#
# To use this, you need a GitHub Personal Access Token (PAT) with 'read:packages' permission
#
# Create the secret manually using kubectl:
# kubectl create secret docker-registry ghcr-secret \
#   --docker-server=ghcr.io \
#   --docker-username=YOUR_GITHUB_USERNAME \
#   --docker-password=YOUR_GITHUB_PAT \
#   --namespace=apps
#
# Or use Terraform (if you want to manage it via Terraform):
# Uncomment the resource below and set the variables

# resource "kubernetes_secret_v1" "ghcr_secret" {
#   metadata {
#     name      = "ghcr-secret"
#     namespace = var.namespace
#   }
#
#   type = "kubernetes.io/dockerconfigjson"
#
#   data = {
#     ".dockerconfigjson" = jsonencode({
#       auths = {
#         "ghcr.io" = {
#           username = var.github_username
#           password = var.github_pat
#           auth     = base64encode("${var.github_username}:${var.github_pat}")
#         }
#       }
#     })
#   }
# }
