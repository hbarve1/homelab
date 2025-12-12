# PgBouncer proxy for PostgreSQL to work better with Cloudflare Tunnel
# PgBouncer handles connection pooling and works better with TCP routing

resource "kubernetes_deployment_v1" "postgres_proxy" {
  metadata {
    name      = "${var.release_name}-proxy"
    namespace = var.namespace
    labels = {
      app = "${var.release_name}-proxy"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "${var.release_name}-proxy"
      }
    }

    template {
      metadata {
        labels = {
          app = "${var.release_name}-proxy"
        }
      }

      spec {
        container {
          name  = "pgbouncer"
          image = "pgbouncer/pgbouncer:latest"

          env {
            name  = "DATABASES_HOST"
            value = "${var.release_name}-postgresql.${var.namespace}.svc.cluster.local"
          }
          env {
            name  = "DATABASES_PORT"
            value = "5432"
          }
          env {
            name  = "DATABASES_USER"
            value = var.postgres_user
          }
          env {
            name  = "DATABASES_PASSWORD"
            value = var.postgres_password
          }
          env {
            name  = "DATABASES_DBNAME"
            value = var.postgres_db
          }
          env {
            name  = "POOL_MODE"
            value = "transaction"
          }
          env {
            name  = "LISTEN_PORT"
            value = "5432"
          }

          port {
            container_port = 5432
            name          = "postgres"
          }

          resources {
            requests = {
              cpu    = "100m"
              memory = "128Mi"
            }
            limits = {
              cpu    = "500m"
              memory = "256Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "postgres_proxy" {
  metadata {
    name      = "${var.release_name}-proxy"
    namespace = var.namespace
    labels = {
      app = "${var.release_name}-proxy"
    }
  }

  spec {
    type = "ClusterIP"

    selector = {
      app = "${var.release_name}-proxy"
    }

    port {
      name        = "postgres"
      port        = 5432
      target_port = 5432
      protocol    = "TCP"
    }
  }
}

