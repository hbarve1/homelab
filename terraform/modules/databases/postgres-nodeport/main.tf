# NodePort service for PostgreSQL to expose via Cloudflare Tunnel
resource "kubernetes_service_v1" "postgres_nodeport" {
  metadata {
    name      = "${var.release_name}-nodeport"
    namespace = var.namespace
    labels = {
      app = var.release_name
    }
  }

  spec {
    type = "NodePort"

    selector = {
      "app.kubernetes.io/component" = "primary"
      "app.kubernetes.io/instance"   = var.release_name
      "app.kubernetes.io/name"       = "postgresql"
    }

    port {
      name        = "postgresql"
      port        = 5432
      target_port = 5432
      protocol    = "TCP"
      node_port   = var.node_port
    }
  }
}

