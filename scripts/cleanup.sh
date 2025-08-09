#!/bin/zsh
# cleanup.sh - Remove Terraform, Helm, and common temp/cache files from the repo

set -e

# Remove Terraform state, backup, plan, and cache files
echo "Removing Terraform state, backup, plan, and cache files..."
find . -type d -name ".terraform" -prune -exec rm -rf {} +
find . -type f \( -name "*.tfstate" -o -name "*.tfstate.*" -o -name "*.tfvars" -o -name "*.tfvars.json" -o -name "*.plan" -o -name "*.backup" -o -name "*.override.tf" -o -name "*.override.tf.json" \) -delete

# Remove Helm chart archives
echo "Removing Helm chart archives (*.tgz)..."
find . -type f -name "*.tgz" -delete

# Remove editor/OS temp files
echo "Removing editor/OS temp files..."
find . -type f \( -name "*~" -o -name "*.swp" -o -name "*.bak" -o -name ".DS_Store" \) -delete

# Remove crash logs
echo "Removing crash logs..."
find . -type f -name "crash.log" -delete

echo "Cleanup complete."
