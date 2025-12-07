resource "helm_release" "dgraph" {
  name             = "dgraph"
  repository       = "https://charts.dgraph.io"
  chart            = "dgraph"
  version          = "24.1.4"
  namespace        = var.namespace
  timeout          = 900  # 15 minutes timeout

  values = [
    yamlencode({
      alpha = {
        replicaCount = 1
        persistence = {
          enabled      = true
          storageClass = "microk8s-hostpath"  # Use MicroK8s default storage class
          size         = "5Gi"
        }
        resources = {
          requests = {
            memory = "512Mi"  # Minimal memory
            cpu    = "100m"   # Minimal CPU
          }
          limits = {
            memory = "1Gi"
            cpu    = "500m"
          }
        }
        securityContext = {
          enabled = false
        }
        autoscaling = {
          enabled = false
        }
      }
      zero = {
        replicaCount = 1
        persistence = {
          enabled      = true
          storageClass = "microk8s-hostpath"  # Use MicroK8s default storage class
          size         = "2Gi"
        }
        resources = {
          requests = {
            memory = "256Mi"  # Minimal memory
            cpu    = "100m"    # Minimal CPU
          }
          limits = {
            memory = "512Mi"
            cpu    = "250m"
          }
        }
        securityContext = {
          enabled = false
        }
      }
      ratel = {
        enabled = true
        image = {
          tag = "v21.12.0"
        }
        service = {
          type = "ClusterIP"
        }
        resources = {
          requests = {
            memory = "128Mi"  # Reduced
            cpu    = "100m"    # Reduced
          }
        }
      }
    })
  ]
}
