output "service_name" {
  description = "Name of the Kubernetes service"
  value       = kubernetes_service_v1.simple_api_server.metadata[0].name
}

output "service_namespace" {
  description = "Namespace of the Kubernetes service"
  value       = kubernetes_service_v1.simple_api_server.metadata[0].namespace
}

output "ingress_hosts" {
  description = "List of ingress hostnames"
  value       = var.ingress_enabled ? var.ingress_hosts : null
}

