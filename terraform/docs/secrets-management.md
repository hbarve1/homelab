# Secrets Management with .env Files

This document describes how to manage secret credentials for Terraform using `.env` files that are not tracked in git.

## Overview

The Terraform setup uses environment variables with the `TF_VAR_*` prefix to pass sensitive values to Terraform. These variables are loaded from `.env` files that are git-ignored.

## Setup

### 1. Create your .env file

For each environment (dev/prod), copy the example file:

```bash
# For development
cd environments/dev
cp env.example .env

# For production
cd environments/prod
cp env.example .env
```

### 2. Edit .env with your actual values

Open the `.env` file and replace all placeholder values with your actual secrets:

```bash
# Example .env file
TF_VAR_postgres_password=my_secure_password_123
TF_VAR_redis_password=another_secure_password
TF_VAR_cloudflare_tunnel_token=your_actual_token_here
```

**Important:** Never commit the `.env` file to git. It's already in `.gitignore`.

## Usage

### Method 1: Source the script (Recommended)

Load environment variables and then run Terraform commands:

```bash
cd environments/dev  # or environments/prod

# Load environment variables
source scripts/load_env.sh

# Now run Terraform commands
terraform init
terraform plan
terraform apply
```

### Method 2: Run Terraform through the script

The script can also execute Terraform commands directly:

```bash
cd environments/dev  # or environments/prod

# Run terraform commands through the script
./scripts/load_env.sh terraform init
./scripts/load_env.sh terraform plan
./scripts/load_env.sh terraform apply
```

### Method 3: Manual export (Alternative)

If you prefer to manually export variables:

```bash
# Load .env file manually
set -a
source .env
set +a

# Run Terraform
terraform plan
terraform apply
```

## How It Works

1. **TF_VAR_* Prefix**: Terraform automatically reads environment variables prefixed with `TF_VAR_` and maps them to variables. For example:
   - `TF_VAR_postgres_password` → `var.postgres_password`
   - `TF_VAR_redis_password` → `var.redis_password`

2. **Variable Definition**: In `variables.tf`, variables are defined as:
   ```hcl
   variable "postgres_password" {
     type        = string
     description = "Postgres admin password"
     sensitive   = true
     default     = "admin"  # Fallback if not set
   }
   ```

3. **Security**: The `sensitive = true` flag ensures Terraform doesn't print these values in logs.

## Available Variables

### Development Environment (`environments/dev/`)

- `TF_VAR_postgres_password` - PostgreSQL admin password
- `TF_VAR_neo4j_password` - Neo4j admin password
- `TF_VAR_mysql1_root_password` - MySQL 1 root password
- `TF_VAR_mysql2_root_password` - MySQL 2 root password
- `TF_VAR_redis_password` - Redis password
- `TF_VAR_mongodb_root_password` - MongoDB root password
- `TF_VAR_elasticsearch_password` - Elasticsearch password
- `TF_VAR_rabbitmq_password` - RabbitMQ password
- `TF_VAR_pihole_password` - Pi-hole web interface password
- `TF_VAR_cloudflare_tunnel_token` - Cloudflare Tunnel token (optional)

### Production Environment (`environments/prod/`)

- `TF_VAR_postgres_password` - PostgreSQL admin password
- `TF_VAR_neo4j_password` - Neo4j admin password
- `TF_VAR_mysql_root_password` - MySQL root password
- `TF_VAR_redis_password` - Redis password
- `TF_VAR_mongodb_root_password` - MongoDB root password
- `TF_VAR_elasticsearch_password` - Elasticsearch password
- `TF_VAR_rabbitmq_password` - RabbitMQ password
- `TF_VAR_pihole_password` - Pi-hole web interface password
- `TF_VAR_cloudflare_tunnel_token` - Cloudflare Tunnel token (required for prod)

## MicroK8s Configuration

If you're using MicroK8s, you may need to configure the Kubernetes config path:

```bash
# Option 1: Export kubeconfig in .env
KUBECONFIG=~/.kube/config

# Option 2: Generate kubeconfig from MicroK8s
microk8s kubectl config view --raw > ~/.kube/config
```

The Terraform providers are configured to use `~/.kube/config` by default, but you can override this in your `.env` file.

## Security Best Practices

1. **Never commit .env files**: They are git-ignored, but double-check before committing
2. **Use strong passwords**: Generate secure, unique passwords for each service
3. **Rotate credentials regularly**: Update passwords periodically
4. **Limit access**: Only share `.env` files with trusted team members through secure channels
5. **Use secrets management**: For production, consider using:
   - HashiCorp Vault
   - AWS Secrets Manager
   - Kubernetes Secrets
   - Other enterprise secrets management solutions

## Troubleshooting

### Variables not being picked up

1. Check that variables are prefixed with `TF_VAR_`
2. Verify the `.env` file exists and is readable
3. Ensure you've sourced the script: `source scripts/load_env.sh`
4. Check for typos in variable names (they must match exactly)

### Script not found

Make sure you're in the correct directory:
```bash
cd environments/dev  # or environments/prod
```

### Permission denied

Make the script executable:
```bash
chmod +x scripts/load_env.sh
```

## Example Workflow

```bash
# 1. Navigate to environment
cd environments/dev

# 2. Create .env from example (first time only)
cp env.example .env

# 3. Edit .env with your secrets
nano .env  # or use your preferred editor

# 4. Load environment variables
source scripts/load_env.sh

# 5. Initialize Terraform (first time only)
terraform init

# 6. Plan changes
terraform plan

# 7. Apply changes
terraform apply
```

## Files Structure

```
environments/
├── dev/
│   ├── .env                    # Git-ignored, contains secrets
│   ├── env.example            # Template file (tracked in git)
│   ├── .gitignore            # Excludes .env files
│   ├── scripts/
│   │   └── load_env.sh        # Script to load .env
│   ├── variables.tf          # Variable definitions
│   └── main.tf               # Terraform configuration
└── prod/
    ├── .env                   # Git-ignored, contains secrets
    ├── env.example           # Template file (tracked in git)
    ├── .gitignore            # Excludes .env files
    ├── scripts/
    │   └── load_env.sh       # Script to load .env
    ├── variables.tf          # Variable definitions
    └── main.tf               # Terraform configuration
```

---

*Last Updated: Generated for Terraform secrets management*

