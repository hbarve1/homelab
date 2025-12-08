auth:
  rootPassword: ${mongodb_root_password}
  usernames:
    - ${mongodb_username}
  databases:
    - ${mongodb_user_database}
  database: ${mongodb_database}

persistence:
  enabled: true
  size: ${storage_size}
  storageClass: "openebs-hostpath"
  # storageClass: "openebs-single-replica"  # Use OpenEBS with Immediate binding to avoid scheduling issues
