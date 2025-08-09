// Automation, CI/CD, and workflow modules
module "n8n" {
  source = "../automation/n8n"
  namespace = var.namespace
}

module "argo_workflows" {
  source = "../automation/argo-workflows"
}

module "argocd" {
  source = "../../modules/ci-cd/argocd"
}

module "localstack" {
  source = "../../modules/emulators/localstack"
}
