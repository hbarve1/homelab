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
  description = "Bitnami Postgres chart version"
  default     = "18.1.13"
}

variable "postgres_user" {
  type        = string
  description = "Postgres admin username"
  default     = "admin"
}

variable "postgres_password" {
  type        = string
  description = "Postgres admin password"
}

variable "postgres_db" {
  type        = string
  description = "Default database name"
  default     = "appdb"
}

variable "storage_size" {
  type        = string
  description = "Persistent volume size"
  default     = "10Gi"
}

variable "postgres_version" {
  type        = string
  description = "PostgreSQL version tag (e.g., '15', '16', '17', '18')"
  default     = "16"
}
