# this is getting complex, so skipping the module for now
# module "knative" {
#   source = "../serverless/knative"
#   namespace = var.namespace
#   # name = "knative-serving"

#   # Note: If your knative module supports a namespace variable, add it to the module's variables.tf and use it here.
#   # For now, remove the unsupported 'namespace' argument to avoid errors.
# }

# module "kubeless" {
#   source = "../serverless/kubeless"
#   namespace = var.namespace
#   # name = "kubeless"

#   # Note: If your kubeless module supports a namespace variable, add it to the module's variables.tf and use it here.
#   # For now, remove the unsupported 'namespace' argument to avoid errors.
# }

# module "fission" {
#   source = "../serverless/fission"
#   # namespace = var.namespace
#   # name = "fission"

#   # Note: If your fission module supports a namespace variable, add it to the module's variables.tf and use it here.
#   # For now, remove the unsupported 'namespace' argument to avoid errors.
# }

module "openfaas" {
  source = "./openfaas"
  namespace = var.namespace
}
