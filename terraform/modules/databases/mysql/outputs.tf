output "mysql_service_name" {
  value = helm_release.mysql.name
}

output "mysql_namespace" {
  value = helm_release.mysql.namespace
}
