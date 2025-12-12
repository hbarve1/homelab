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
