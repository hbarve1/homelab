
module "minio" {
  source = "./minio"
}

# module "ceph" {
#   source = "./ceph"
# }

module "openebs" {
  source = "./openebs"
}
