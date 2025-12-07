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
