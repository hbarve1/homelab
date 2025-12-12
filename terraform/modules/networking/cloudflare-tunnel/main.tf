# Cloudflare Tunnel (cloudflared) Module
# Provides stable, IP-independent access to your Kubernetes services
# No need to expose ports or worry about IP changes

# Compute routes: if subdomains provided, create routes for each
# Otherwise use provided routes or default to ingress controller
locals {
  ingress_service_url = "http://${var.ingress_host}:${var.ingress_port}"
  
  computed_http_routes = length(var.http_routes) > 0 ? var.http_routes : (
    length(var.subdomains) > 0 && var.domain != "" ? [
      for subdomain in var.subdomains : {
        hostname = "${subdomain}.${var.domain}"
        service  = local.ingress_service_url
      }
    ] : (
      length(var.routes) > 0 ? var.routes : []
    )
  )
  
  tcp_routes = var.tcp_routes
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

  data = var.tunnel_token != "" ? {
    # Token-based authentication (newer method)
    token = base64encode(var.tunnel_token)
  } : {
    # Legacy credentials JSON from Cloudflare
    # Format: {"AccountTag":"...","TunnelID":"...","TunnelSecret":"..."}
    credentials = base64encode(var.tunnel_credentials_json)
  }
}

resource "kubernetes_config_map_v1" "cloudflare_tunnel_config" {
  count = var.tunnel_token == "" ? 1 : 0
  
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
      http_routes        = local.computed_http_routes
      tcp_routes         = local.tcp_routes
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

          command = var.tunnel_token != "" ? [
            "cloudflared",
            "tunnel",
            "run"
          ] : [
            "cloudflared",
            "tunnel",
            "--config",
            "/etc/cloudflared/config.yaml",
            "run"
          ]

          dynamic "env" {
            for_each = var.tunnel_token != "" ? [1] : []
            content {
              name  = "TUNNEL_TOKEN"
              value_from {
                secret_key_ref {
                  name = kubernetes_secret_v1.cloudflare_tunnel.metadata[0].name
                  key  = "token"
                }
              }
            }
          }

          dynamic "volume_mount" {
            for_each = var.tunnel_token == "" ? [1] : []
            content {
              name       = "credentials"
              mount_path = "/etc/cloudflared/credentials.json"
              sub_path   = "credentials"
              read_only  = true
            }
          }

          dynamic "volume_mount" {
            for_each = var.tunnel_token == "" ? [1] : []
            content {
              name       = "config"
              mount_path = "/etc/cloudflared/config.yaml"
              sub_path   = "config.yaml"
              read_only  = true
            }
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

        dynamic "volume" {
          for_each = var.tunnel_token == "" ? [1] : []
          content {
            name = "credentials"
            secret {
              secret_name = kubernetes_secret_v1.cloudflare_tunnel.metadata[0].name
              items {
                key  = "credentials"
                path = "credentials.json"
              }
            }
          }
        }

        dynamic "volume" {
          for_each = var.tunnel_token == "" ? [1] : []
          content {
            name = "config"
            config_map {
              name = kubernetes_config_map_v1.cloudflare_tunnel_config.metadata[0].name
            }
          }
        }

        restart_policy = "Always"
      }
    }
  }

  depends_on = [
    kubernetes_secret_v1.cloudflare_tunnel
  ]
}

