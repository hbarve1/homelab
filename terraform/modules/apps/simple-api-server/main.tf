# Simple API Server Module
# Deploys a simple Express.js API server

resource "kubernetes_deployment_v1" "simple_api_server" {
  metadata {
    name      = "simple-api-server"
    namespace = var.namespace
    labels = {
      app = "simple-api-server"
    }
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = "simple-api-server"
      }
    }

    template {
      metadata {
        labels = {
          app = "simple-api-server"
        }
      }

      spec {
        container {
          name  = "simple-api-server"
          image = "${var.image_registry}/simple-api-server:${var.image_tag}"

          port {
            name           = "http"
            container_port = 3000
            protocol       = "TCP"
          }

          env {
            name  = "PORT"
            value = "3000"
          }

          env {
            name = "HOSTNAME"
            value_from {
              field_ref {
                field_path = "metadata.name"
              }
            }
          }

          env {
            name  = "NODE_ENV"
            value = var.environment
          }

          resources {
            requests = {
              memory = var.resources_requests_memory
              cpu    = var.resources_requests_cpu
            }
            limits = {
              memory = var.resources_limits_memory
              cpu    = var.resources_limits_cpu
            }
          }

          liveness_probe {
            http_get {
              path = "/health"
              port = 3000
            }
            initial_delay_seconds = 10
            period_seconds        = 30
            timeout_seconds       = 5
            failure_threshold     = 3
          }

          readiness_probe {
            http_get {
              path = "/health"
              port = 3000
            }
            initial_delay_seconds = 5
            period_seconds        = 10
            timeout_seconds       = 3
            failure_threshold     = 3
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
    labels = {
      app = "simple-api-server"
    }
  }

  spec {
    type = "ClusterIP"

    selector = {
      app = "simple-api-server"
    }

    port {
      name        = "http"
      port        = 80
      target_port = 3000
      protocol    = "TCP"
    }
  }
}

resource "kubernetes_ingress_v1" "simple_api_server" {
  count = var.ingress_enabled ? 1 : 0

  metadata {
    name      = "simple-api-server"
    namespace = var.namespace
    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
    }
  }

  spec {
    ingress_class_name = var.ingress_class_name

    rule {
      host = var.ingress_host

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = kubernetes_service_v1.simple_api_server.metadata[0].name
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}

