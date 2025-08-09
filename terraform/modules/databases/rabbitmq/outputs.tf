output "rabbitmq_service_name" {
  value = helm_release.rabbitmq.name
}

output "rabbitmq_namespace" {
  value = helm_release.rabbitmq.namespace
}
