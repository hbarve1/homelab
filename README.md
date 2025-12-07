# Homelab

Homelab is an open-source project to help you set up, manage, and run self-hosted services using Docker and Kubernetes. It provides templates, scripts, and best practices for deploying a wide range of applications at home or in small-scale environments.

## Features
- Pre-built Docker Compose and Kubernetes manifests for popular services
- Automated setup scripts for infrastructure (reverse proxy, SSL, storage, etc.)
- Terraform modules for infrastructure as code
- Guides and documentation for setup and troubleshooting
- Open to community contributions

## Getting Started
1. Clone this repository
2. Explore the `docs/` folder for setup guides and requirements
3. Use provided templates to deploy your services

## Local Network Access

Want to access your services from your local network using friendly domain names (e.g., `app.homelab.local`) while maintaining Cloudflare access for external connections?

See the [Local Network Access Guide (Kubernetes/Terraform)](docs/local-network-access-k8s.md) for complete setup instructions, including:
- Setting up local DNS servers (Pi-hole or AdGuard Home) using Terraform
- Configuring Kubernetes ingress for dual-domain support
- Router and device DNS configuration
- SSL/TLS options for local domains

## Contributing
We welcome contributions! Please see `docs/CONTRIBUTING.md` for guidelines.

## License
This project is licensed under the MIT License.

---
