auth:
  username: ${postgres_user}
  password: ${postgres_password}
  database: ${postgres_db}

primary:
  persistence:
    enabled: true
    size: ${storage_size}
