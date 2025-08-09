// Security-related modules
module "openfga" {
  source = "../../modules/security/openfga"
}

module "kyverno" {
  source = "../../modules/security/kyverno"
}
