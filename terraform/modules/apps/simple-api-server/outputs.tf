output "service_name" {
  value = kubernetes_service_v1.simple_api_server.metadata[0].name
  description = "Name of the Kubernetes service"
}

