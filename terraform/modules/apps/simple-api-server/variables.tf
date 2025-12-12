variable "namespace" {
  description = "Kubernetes namespace"
  type        = string
}

variable "image_registry" {
  description = "Docker registry host"
  type        = string
  default     = "ghcr.io"
}

variable "image_name" {
  description = "Docker image name (without registry)"
  type        = string
}

variable "image_tag" {
  description = "Docker image tag"
  type        = string
  default     = "latest"
}
variable "environment" {
  description = "Environment name (development, staging, production)"
  type        = string
  default     = "development"
}

variable "image_pull_secret_name" {
  description = "Image pull secret name"
  type        = string
  default     = ""
}

variable "ingress_hosts" {
  description = "List of ingress hostnames"
  type        = list(string)
  default     = []
}

variable "autoscaling_enabled" {
  description = "Enable horizontal pod autoscaling"
  type        = bool
  default     = true
}

variable "min_replicas" {
  description = "Minimum number of replicas"
  type        = number
  default     = 1
}

variable "max_replicas" {
  description = "Maximum number of replicas"
  type        = number
  default     = 50
}

variable "target_cpu_utilization" {
  description = "Target CPU utilization percentage"
  type        = number
  default     = 70
}

