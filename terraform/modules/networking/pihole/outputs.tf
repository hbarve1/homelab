output "service_name" {
  description = "Name of the Pi-hole service"
  value       = kubernetes_service_v1.pihole.metadata[0].name
}

output "service_namespace" {
  description = "Namespace of the Pi-hole service"
  value       = kubernetes_service_v1.pihole.metadata[0].namespace
}

output "dns_service_ip" {
  description = "DNS service IP (if LoadBalancer) or NodePort"
  value       = var.service_type == "LoadBalancer" ? try(kubernetes_service_v1.pihole.status[0].load_balancer[0].ingress[0].ip, kubernetes_service_v1.pihole.status[0].load_balancer[0].ingress[0].hostname, "") : ""
}

output "web_url" {
  description = "Web interface URL"
  value       = var.ingress_enabled ? "http://${var.ingress_host}" : "http://${try(kubernetes_service_v1.pihole.status[0].load_balancer[0].ingress[0].ip, "localhost")}:80"
}

