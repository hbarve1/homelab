variable "release_name" {
  type        = string
  description = "Helm release name"
}

variable "namespace" {
  type        = string
  description = "Kubernetes namespace"
}

variable "chart_version" {
  type        = string
  description = "Bitnami Neo4j chart version"
  default     = "0.4.3"
}

variable "neo4j_password" {
  type        = string
  description = "Neo4j admin password"
}

variable "neo4j_db" {
  type        = string
  description = "Default database name"
  default     = "neo4j"
}

variable "storage_size" {
  type        = string
  description = "Persistent volume size"
  default     = "8Gi"
}

variable "advertised_host" {
  type        = string
  description = "External advertised host for Neo4j"
  default     = "neo4j-dev.databases.svc.cluster.local"
}

variable "neo4j_host" {
  type        = string
  description = "External DNS host for Neo4j Ingress (e.g. neo4j.example.com)"
  default     = "neo4j.example.com"
}
