resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "5.46.8"  # Using stable version, adjust as needed
  namespace        = "argocd"
  create_namespace = true

  # Use values file for complex configuration
  values = [
    file("${path.module}/values.yaml")
  ]

  # These settings override anything in the values.yaml file
  set {
    name  = "server.service.type"
    value = "ClusterIP"
  }
}

# Wait for CRDs to be established before apps can be deployed
resource "null_resource" "wait_for_crds" {
  depends_on = [helm_release.argocd]

  provisioner "local-exec" {
    command = "kubectl wait --for=condition=established --timeout=90s crd/applications.argoproj.io crd/applicationsets.argoproj.io"
  }
}
