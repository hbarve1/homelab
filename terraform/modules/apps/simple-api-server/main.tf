resource "kubernetes_deployment_v1" "simple_api_server" {
  metadata {
    name      = "simple-api-server"
    namespace = var.namespace
    labels    = { app = "simple-api-server" }
  }

  spec {
    replicas = 1
    selector { match_labels = { app = "simple-api-server" } }

    template {
      metadata { labels = { app = "simple-api-server" } }
      spec {
        dynamic "image_pull_secrets" {
          for_each = var.image_pull_secret_name != "" ? [1] : []
          content { name = var.image_pull_secret_name }
        }

        container {
          name  = "simple-api-server"
          image = "${var.image_registry}/${var.image_name}:${var.image_tag}"

          port {
            name           = "http"
            container_port = 3000
          }

          env {
            name  = "PORT"
            value = "3000"
          }

          env {
            name = "HOSTNAME"
            value_from {
              field_ref { field_path = "metadata.name" }
            }
          }

          env {
            name  = "NODE_ENV"
            value = var.environment
          }

          resources {
            requests = { memory = "64Mi", cpu = "50m" }
            limits   = { memory = "128Mi", cpu = "200m" }
          }

          liveness_probe {
            http_get {
              path = "/health"
              port = 3000
            }
            initial_delay_seconds = 10
            period_seconds       = 30
          }

          readiness_probe {
            http_get {
              path = "/health"
              port = 3000
            }
            initial_delay_seconds = 5
            period_seconds        = 10
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "simple_api_server" {
  metadata {
    name      = "simple-api-server"
    namespace = var.namespace
    labels    = { app = "simple-api-server" }
  }

  spec {
    type     = "ClusterIP"
    selector = { app = "simple-api-server" }

    port {
      name        = "http"
      port        = 80
      target_port = 3000
    }
  }
}

resource "kubernetes_ingress_v1" "simple_api_server" {
  count = length(var.ingress_hosts) > 0 ? 1 : 0

  metadata {
    name      = "simple-api-server"
    namespace = var.namespace
    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
    }
  }

  spec {
    ingress_class_name = "nginx"

    dynamic "rule" {
      for_each = var.ingress_hosts
      content {
        host = rule.value
        http {
          path {
            path      = "/"
            path_type = "Prefix"
            backend {
              service {
                name = kubernetes_service_v1.simple_api_server.metadata[0].name
                port { number = 80 }
              }
            }
          }
        }
      }
    }
  }
}

