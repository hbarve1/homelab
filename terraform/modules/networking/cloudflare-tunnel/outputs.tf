output "tunnel_id" {
  description = "Cloudflare Tunnel ID"
  value       = var.tunnel_id
}

output "namespace" {
  description = "Namespace where tunnel is deployed"
  value       = var.namespace
}

output "deployment_name" {
  description = "Name of the tunnel deployment"
  value       = kubernetes_deployment_v1.cloudflare_tunnel.metadata[0].name
}

