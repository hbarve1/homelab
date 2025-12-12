#!/bin/bash
# Load environment variables from .env file for Terraform
# This script exports TF_VAR_* variables that Terraform automatically picks up
#
# Usage:
#   source scripts/load_env.sh
#   terraform plan
#   terraform apply
#
# Or run directly:
#   ./scripts/load_env.sh terraform plan

set -e

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
ENV_FILE="$ENV_DIR/.env"

# Check if .env file exists
if [ ! -f "$ENV_FILE" ]; then
    echo "Warning: .env file not found at $ENV_FILE"
    echo "Please copy env.example to .env and fill in your values:"
    echo "  cp env.example .env"
    echo "  # Edit .env with your actual values"
    exit 1
fi

# Load .env file and export variables
# This handles comments and empty lines
set -a
source "$ENV_FILE"
set +a

echo "✓ Loaded environment variables from $ENV_FILE"

# If arguments are provided, execute them
if [ $# -gt 0 ]; then
    echo "Executing: $@"
    exec "$@"
fi

