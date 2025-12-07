auth:
  rootPassword: ${mysql_root_password}
  database: ${mysql_database}

global:
  imageRegistry: docker.io

image:
  registry: docker.io
  repository: mysql
  tag: "${mysql_version}"
  pullPolicy: IfNotPresent

persistence:
  size: ${storage_size}
