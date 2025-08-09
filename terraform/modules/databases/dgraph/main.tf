resource "helm_release" "dgraph" {
  name             = "dgraph"
  repository       = "https://charts.dgraph.io"
  chart            = "dgraph"
  version          = "24.1.1"
  namespace        = "dgraph"
  create_namespace = true

  values = [
    yamlencode({
      alpha = {
        replicaCount = null # Let HPA or KEDA manage scaling, not fixed
        persistence = {
          enabled      = true
          storageClass = "standard"
          size         = "100Gi"
        }
        resources = {
          requests = {
            memory = "8Gi"
            cpu    = "2"
          }
          limits = {
            memory = "16Gi"
          }
        }
        securityContext = {
          enabled = false
        }
        autoscaling = {
          enabled = true
          minReplicas = 2
          maxReplicas = 20
          targetCPUUtilizationPercentage = 70
        }
      }
      zero = {
        replicaCount = 3
        persistence = {
          enabled      = true
          storageClass = "standard"
          size         = "32Gi"
        }
        resources = {
          requests = {
            memory = "2Gi"
            cpu    = "1"
          }
          limits = {
            memory = "4Gi"
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
            memory = "256Mi"
            cpu    = "200m"
          }
        }
      }
    })
  ]
}
