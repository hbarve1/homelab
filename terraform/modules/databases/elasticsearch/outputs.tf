output "elasticsearch_service_name" {
  value = helm_release.elasticsearch.name
}

output "elasticsearch_namespace" {
  value = helm_release.elasticsearch.namespace
}
