# Cloudflare Tunnel (cloudflared) Module
# Provides stable, IP-independent access to your Kubernetes services
# No need to expose ports or worry about IP changes

# Compute routes: if subdomains provided, create routes for each
# Otherwise use provided routes or default to ingress controller
locals {
  ingress_service_url = "http://${var.ingress_host}:${var.ingress_port}"
  
  computed_routes = length(var.routes) > 0 ? var.routes : (
    length(var.subdomains) > 0 && var.domain != "" ? [
      for subdomain in var.subdomains : {
        hostname = "${subdomain}.${var.domain}"
        service  = local.ingress_service_url
      }
    ] : []
  )
}

resource "kubernetes_namespace" "cloudflare_tunnel" {
  count = var.create_namespace ? 1 : 0
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_secret_v1" "cloudflare_tunnel" {
  metadata {
    name      = "cloudflare-tunnel-credentials"
    namespace = var.namespace
  }

  type = "Opaque"

  data = {
    # Tunnel credentials JSON from Cloudflare
    # Format: {"AccountTag":"...","TunnelID":"...","TunnelSecret":"..."}
    credentials = base64encode(var.tunnel_credentials_json)
  }
}

resource "kubernetes_config_map_v1" "cloudflare_tunnel_config" {
  metadata {
    name      = "cloudflare-tunnel-config"
    namespace = var.namespace
  }

  data = {
    "config.yaml" = templatefile("${path.module}/tunnel-config.yaml.tpl", {
      tunnel_id         = var.tunnel_id
      ingress_host      = var.ingress_host
      ingress_port      = var.ingress_port
      ingress_service   = var.ingress_service
      ingress_namespace = var.ingress_namespace
      routes            = local.computed_routes
    })
  }
}

resource "kubernetes_deployment_v1" "cloudflare_tunnel" {
  metadata {
    name      = "cloudflare-tunnel"
    namespace = var.namespace
    labels = {
      app = "cloudflare-tunnel"
    }
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = "cloudflare-tunnel"
      }
    }

    template {
      metadata {
        labels = {
          app = "cloudflare-tunnel"
        }
      }

      spec {
        # Spread across nodes for high availability (when replicas > 1)
        dynamic "topology_spread_constraint" {
          for_each = var.replicas > 1 ? [1] : []
          content {
            max_skew           = 1
            topology_key       = "kubernetes.io/hostname"
            when_unsatisfiable = "DoNotSchedule"
            label_selector {
              match_labels = {
                app = "cloudflare-tunnel"
              }
            }
          }
        }

        container {
          name  = "cloudflared"
          image = "${var.image_repository}:${var.image_tag}"

          command = [
            "cloudflared",
            "tunnel",
            "--config",
            "/etc/cloudflared/config.yaml",
            "run"
          ]

          volume_mount {
            name       = "credentials"
            mount_path = "/etc/cloudflared/credentials.json"
            sub_path   = "credentials"
            read_only  = true
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/cloudflared/config.yaml"
            sub_path   = "config.yaml"
            read_only  = true
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
        }

        volume {
          name = "credentials"
          secret {
            secret_name = kubernetes_secret_v1.cloudflare_tunnel.metadata[0].name
            items {
              key  = "credentials"
              path = "credentials.json"
            }
          }
        }

        volume {
          name = "config"
          config_map {
            name = kubernetes_config_map_v1.cloudflare_tunnel_config.metadata[0].name
          }
        }

        restart_policy = "Always"
      }
    }
  }

  depends_on = [
    kubernetes_secret_v1.cloudflare_tunnel,
    kubernetes_config_map_v1.cloudflare_tunnel_config
  ]
}

