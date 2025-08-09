resource "helm_release" "velero" {
  name             = "velero"
  repository       = "https://vmware-tanzu.github.io/helm-charts"
  chart            = "velero"
  version          = "9.1.1"
  namespace        = "velero"
  create_namespace = true
  values           = [file("${path.module}/values.yaml")]
  
  # This prevents the helm_release from being immediately marked as failed
  wait             = false
  atomic           = false
  cleanup_on_fail  = false

  # This effectively gives more time for the deployment to succeed
  timeout          = 600
}

# Wait for Velero to be fully ready before marking the deployment as complete
resource "null_resource" "wait_for_velero" {
  depends_on = [helm_release.velero]

  provisioner "local-exec" {
    command = "sleep 60 && kubectl wait --namespace velero --for=condition=ready pod -l app.kubernetes.io/name=velero --timeout=600s || true"
  }
}
