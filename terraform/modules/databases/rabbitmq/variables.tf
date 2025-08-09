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
  description = "Bitnami RabbitMQ chart version"
  default     = "12.7.1"
}

variable "rabbitmq_password" {
  type        = string
  description = "RabbitMQ default user password"
  default     = "changeme"
}

variable "storage_size" {
  type        = string
  description = "Persistent volume size"
  default     = "8Gi"
}
