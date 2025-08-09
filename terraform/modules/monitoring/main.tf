// Monitoring and logging modules
module "grafana" {
  source = "../monitoring/grafana"
}

# module "prometheus" {
#   source = "../monitoring/prometheus"
# }

# module "opentelemetry" {
#   source     = "../monitoring/opentelemetry"
#   depends_on = [module.cert_manager]
# }

module "cert_manager" {
  source = "../monitoring/cert-manager"
}

# no official module available
# module "logstash" {
#   source = "../monitoring/logstash"
# }

# module "kibana" {
#   source = "../../modules/monitoring/kibana"
# }

# module "fluentd" {
#   source = "../../modules/monitoring/fluentd"
# }

# module "fluent_bit" {
#   source = "../../modules/monitoring/fluent-bit"
# }

# module "jaeger" {
#   source = "../../modules/monitoring/jaeger"
# }

# module "zipkin" {
#   source = "../../modules/monitoring/zipkin"
# }

# module "datadog" {
#   source = "../../modules/monitoring/datadog"
# }

# module "newrelic" {
#   source = "../../modules/monitoring/newrelic"
# }
