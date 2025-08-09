
# module "akhq" {
#   source = "../analytics/akhq"
# }

module "clickhouse" {
  source = "../analytics/clickhouse"
  # namespace = var.namespace
}
