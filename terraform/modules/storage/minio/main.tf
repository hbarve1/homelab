resource "helm_release" "minio" {
  name             = "minio"
  repository       = "https://charts.min.io/"
  chart            = "minio"
  version          = "5.4.0"
  namespace        = "minio"
  create_namespace = true

  values = [
    yamlencode({
      rootUser     = "minioadmin"
      rootPassword = "minioadmin"
      mode         = "standalone"
      persistence = {
        enabled      = true
        storageClass = "openebs-hostpath"  # Use OpenEBS LocalPV hostpath storage class
        size         = "10Gi"
      }
      resources = {
        requests = {
          memory            = "256Mi"
          cpu               = "100m"
          ephemeral-storage = "1Gi"
        }
        limits = {
          memory            = "512Mi"
          cpu               = "500m"
          ephemeral-storage = "2Gi"
        }
      }
      # Reduce post-install job resource requirements
      makeUserJob = {
        resources = {
          requests = {
            memory            = "64Mi"
            cpu               = "50m"
            ephemeral-storage = "100Mi"
          }
          limits = {
            memory            = "128Mi"
            cpu               = "100m"
            ephemeral-storage = "200Mi"
          }
        }
      }
    })
  ]

  # Don't wait for all pods to be ready - MinIO can take time to fully initialize
  wait = false
  timeout = 600
  
  # Allow partial failures - some pods may take longer to start
  atomic = false
}
