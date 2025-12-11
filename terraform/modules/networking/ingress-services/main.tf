# Ingress resources for all HTTP services
# This module creates ingress resources for services that need HTTP access via Cloudflare Tunnel

locals {
  ingress_class = "nginx"
  domain        = "hbarve1.com"
}

# IngressClass for nginx ingress controller
resource "kubernetes_ingress_class_v1" "nginx" {
  metadata {
    name = local.ingress_class
  }

  spec {
    controller = "k8s.io/ingress-nginx"
  }
}

# Grafana Ingress
resource "kubernetes_ingress_v1" "grafana" {
  metadata {
    name      = "grafana-ingress"
    namespace = "observability"
    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
    }
  }

  spec {
    ingress_class_name = local.ingress_class

    rule {
      host = "grafana.${local.domain}"

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "kube-prom-stack-grafana"
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

# Prometheus Ingress
resource "kubernetes_ingress_v1" "prometheus" {
  metadata {
    name      = "prometheus-ingress"
    namespace = "observability"
    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
    }
  }

  spec {
    ingress_class_name = local.ingress_class

    rule {
      host = "prometheus.${local.domain}"

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "kube-prom-stack-kube-prome-prometheus"
              port {
                number = 9090
              }
            }
          }
        }
      }
    }
  }
}

# Loki Ingress
resource "kubernetes_ingress_v1" "loki" {
  metadata {
    name      = "loki-ingress"
    namespace = "observability"
    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
    }
  }

  spec {
    ingress_class_name = local.ingress_class

    rule {
      host = "loki.${local.domain}"

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "loki"
              port {
                number = 3100
              }
            }
          }
        }
      }
    }
  }
}

# Tempo Ingress
resource "kubernetes_ingress_v1" "tempo" {
  metadata {
    name      = "tempo-ingress"
    namespace = "observability"
    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
    }
  }

  spec {
    ingress_class_name = local.ingress_class

    rule {
      host = "tempo.${local.domain}"

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "tempo"
              port {
                number = 3100
              }
            }
          }
        }
      }
    }
  }
}

# OpenFaaS Gateway Ingress
resource "kubernetes_ingress_v1" "openfaas" {
  metadata {
    name      = "faas-ingress"
    namespace = "openfaas"
    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
    }
  }

  spec {
    ingress_class_name = local.ingress_class

    rule {
      host = "faas.${local.domain}"

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "gateway"
              port {
                number = 8080
              }
            }
          }
        }
      }
    }
  }
}

# MinIO Console Ingress
resource "kubernetes_ingress_v1" "minio" {
  metadata {
    name      = "minio-console-ingress"
    namespace = "minio"
    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
    }
  }

  spec {
    ingress_class_name = local.ingress_class

    rule {
      host = "minio.${local.domain}"

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "minio-console"
              port {
                number = 9001
              }
            }
          }
        }
      }
    }
  }
}

# N8N Ingress
resource "kubernetes_ingress_v1" "n8n" {
  metadata {
    name      = "n8n-ingress"
    namespace = "automation"
    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
    }
  }

  spec {
    ingress_class_name = local.ingress_class

    rule {
      host = "n8n.${local.domain}"

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "n8n"
              port {
                number = 5678
              }
            }
          }
        }
      }
    }
  }
}

# Pi-hole Ingress (if needed)
resource "kubernetes_ingress_v1" "pihole" {
  metadata {
    name      = "pihole-ingress"
    namespace = "networking"
    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
    }
  }

  spec {
    ingress_class_name = local.ingress_class

    rule {
      host = "pihole.${local.domain}"

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "pihole"
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

