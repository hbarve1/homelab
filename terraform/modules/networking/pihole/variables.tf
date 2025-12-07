variable "namespace" {
  description = "Kubernetes namespace for Pi-hole"
  type        = string
}

variable "create_namespace" {
  description = "Whether to create the namespace"
  type        = bool
  default     = false
}

variable "timezone" {
  description = "Timezone for Pi-hole"
  type        = string
  default     = "UTC"
}

variable "web_password" {
  description = "Web interface password for Pi-hole"
  type        = string
  sensitive   = true
}

variable "dns_servers" {
  description = "Upstream DNS servers (semicolon-separated)"
  type        = string
  default     = "8.8.8.8;1.1.1.1"
}

variable "local_domain" {
  description = "Local domain for conditional forwarding"
  type        = string
  default     = "homelab.local"
}

variable "router_ip" {
  description = "Router IP for conditional forwarding"
  type        = string
  default     = "192.168.1.1"
}

variable "enable_conditional_forwarding" {
  description = "Enable conditional forwarding"
  type        = bool
  default     = true
}

variable "conditional_forwarding_reverse" {
  description = "Reverse DNS zone for conditional forwarding"
  type        = string
  default     = "1.168.192.in-addr.arpa"
}

variable "image_repository" {
  description = "Pi-hole Docker image repository"
  type        = string
  default     = "pihole/pihole"
}

variable "image_tag" {
  description = "Pi-hole Docker image tag"
  type        = string
  default     = "latest"
}

variable "replicas" {
  description = "Number of replicas"
  type        = number
  default     = 1
}

variable "service_type" {
  description = "Kubernetes service type"
  type        = string
  default     = "LoadBalancer"
}

variable "persistence_enabled" {
  description = "Enable persistent storage"
  type        = bool
  default     = true
}

variable "storage_class" {
  description = "Storage class for persistent volume (empty string uses default, set to null to skip)"
  type        = string
  default     = ""  # Empty string will use default storage class
}

variable "storage_size" {
  description = "Size of persistent volume"
  type        = string
  default     = "1Gi"
}

variable "resources_requests_memory" {
  description = "Memory request"
  type        = string
  default     = "128Mi"
}

variable "resources_requests_cpu" {
  description = "CPU request"
  type        = string
  default     = "100m"
}

variable "resources_limits_memory" {
  description = "Memory limit"
  type        = string
  default     = "512Mi"
}

variable "resources_limits_cpu" {
  description = "CPU limit"
  type        = string
  default     = "500m"
}

variable "ingress_enabled" {
  description = "Enable ingress"
  type        = bool
  default     = false
}

variable "ingress_class_name" {
  description = "Ingress class name"
  type        = string
  default     = "nginx"
}

variable "ingress_host" {
  description = "Ingress host"
  type        = string
  default     = "pihole.homelab.local"
}

