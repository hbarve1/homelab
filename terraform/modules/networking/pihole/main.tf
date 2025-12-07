resource "kubernetes_namespace" "pihole" {
  count = var.create_namespace ? 1 : 0
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_config_map" "pihole_config" {
  metadata {
    name      = "pihole-config"
    namespace = var.namespace
  }

  data = {
    TZ                        = var.timezone
    WEBPASSWORD               = var.web_password
    PIHOLE_DNS_              = var.dns_servers
    CONDITIONAL_FORWARDING    = var.enable_conditional_forwarding ? "true" : "false"
    CONDITIONAL_FORWARDING_IP = var.router_ip
    CONDITIONAL_FORWARDING_DOMAIN = var.local_domain
    CONDITIONAL_FORWARDING_REVERSE = var.conditional_forwarding_reverse
  }
}

resource "kubernetes_persistent_volume_claim_v1" "pihole_data" {
  count = var.persistence_enabled ? 1 : 0
  metadata {
    name      = "pihole-data"
    namespace = var.namespace
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    storage_class_name = var.storage_class != "" ? var.storage_class : null
    resources {
      requests = {
        storage = var.storage_size
      }
    }
  }

  # For WaitForFirstConsumer storage classes, PVC won't bind until pod uses it
  # Don't wait for binding - PVC will be created in Pending state
  # and will bind automatically when the pod starts
  wait_until_bound = false
}

resource "kubernetes_deployment" "pihole" {
  metadata {
    name      = "pihole"
    namespace = var.namespace
    labels = {
      app = "pihole"
    }
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = "pihole"
      }
    }

    template {
      metadata {
        labels = {
          app = "pihole"
        }
      }

      spec {
        container {
          name  = "pihole"
          image = "${var.image_repository}:${var.image_tag}"

          env_from {
            config_map_ref {
              name = kubernetes_config_map.pihole_config.metadata[0].name
            }
          }

          port {
            name           = "dns-tcp"
            container_port = 53
            protocol       = "TCP"
          }

          port {
            name           = "dns-udp"
            container_port = 53
            protocol       = "UDP"
          }

          port {
            name           = "web"
            container_port = 80
            protocol       = "TCP"
          }

          volume_mount {
            name       = "pihole-data"
            mount_path = "/etc/pihole"
          }

          volume_mount {
            name       = "pihole-data"
            mount_path = "/etc/dnsmasq.d"
            sub_path   = "dnsmasq.d"
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

          security_context {
            capabilities {
              add = ["NET_ADMIN", "NET_BIND_SERVICE"]
            }
          }
        }

        dynamic "volume" {
          for_each = var.persistence_enabled ? [1] : []
          content {
            name = "pihole-data"
            persistent_volume_claim {
              claim_name = kubernetes_persistent_volume_claim_v1.pihole_data[0].metadata[0].name
            }
          }
        }

        dynamic "volume" {
          for_each = var.persistence_enabled ? [] : [1]
          content {
            name = "pihole-data"
            empty_dir {}
          }
        }

        dns_policy = "None"
        dns_config {
          nameservers = ["127.0.0.1"]
        }
      }
    }
  }

  depends_on = [kubernetes_config_map.pihole_config]
}

resource "kubernetes_service_v1" "pihole" {
  metadata {
    name      = "pihole"
    namespace = var.namespace
    labels = {
      app = "pihole"
    }
  }

  spec {
    type = var.service_type

    selector = {
      app = "pihole"
    }

    port {
      name        = "dns-tcp"
      port        = 53
      target_port = 53
      protocol    = "TCP"
    }

    port {
      name        = "dns-udp"
      port        = 53
      target_port = 53
      protocol    = "UDP"
    }

    port {
      name        = "web"
      port        = 80
      target_port = 80
      protocol    = "TCP"
    }
  }

  depends_on = [kubernetes_deployment.pihole]
  
  timeouts {
    create = "2m"
  }
}

resource "kubernetes_ingress_v1" "pihole" {
  count = var.ingress_enabled ? 1 : 0

  metadata {
    name      = "pihole"
    namespace = var.namespace
    annotations = {
      "nginx.ingress.kubernetes.io/ssl-redirect" = "false"
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
              name = kubernetes_service_v1.pihole.metadata[0].name
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

