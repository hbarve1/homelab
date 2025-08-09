resource "helm_release" "docker_registry" {
  name             = "docker-registry"
  repository       = "https://helm.twun.io"
  chart            = "docker-registry"
  version          = "2.2.2" # Use the latest available version if needed
  namespace        = "registry"
  create_namespace = true
  # set values as needed, e.g. persistence, secrets, etc.
}
