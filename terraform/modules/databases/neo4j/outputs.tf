output "neo4j_service_name" {
  value = helm_release.neo4j.name
}

output "neo4j_namespace" {
  value = helm_release.neo4j.namespace
}
