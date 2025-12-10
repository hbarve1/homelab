variable "postgres_password" {
  type        = string
  description = "Postgres admin password"
  sensitive   = true
  default     = "admin"
}

variable "neo4j_password" {
  type        = string
  description = "Neo4j admin password"
  sensitive   = true
  default     = "admin"
}

variable "mysql_root_password" {
  type        = string
  description = "MySQL root password"
  sensitive   = true
  default     = "admin"
}

variable "redis_password" {
  type        = string
  description = "Redis password"
  sensitive   = true
  default     = "admin"
}

variable "mongodb_root_password" {
  type        = string
  description = "MongoDB root password"
  sensitive   = true
  default = "admin"
}

variable "elasticsearch_password" {
  type        = string
  description = "Elasticsearch password for the elastic user"
  sensitive   = true
  default     = "admin"
}

variable "rabbitmq_password" {
  type        = string
  description = "RabbitMQ default user password"
  sensitive   = true
  default     = "changeme"
}

variable "cloudflare_tunnel_token" {
  type        = string
  description = "Cloudflare Tunnel token (from dashboard - newer token-based auth)"
  sensitive   = true
  default     = "eyJhIjoiYzMyMzBjMDk4ODg1MjY1MzhiYzhiYTc4OGRjOTZmYWEiLCJ0IjoiZmI1NmMxNTItODU0Ni00NjljLWIzZWYtNTUzYjUzZWZlNjdiIiwicyI6IlpUTXhPRGszTkRFdE1XVmpNaTAwT1RFd0xXSm1NV1V0TlRjellURmxZamM0WlRFeCJ9"
}
