output "postgresql_service_name" {
  value = helm_release.postgresql.name
}

output "postgresql_namespace" {
  value = helm_release.postgresql.namespace
}
