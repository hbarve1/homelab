# Docker Swarm Multi-Machine Setup

This directory contains the complete Docker Swarm setup for multiple local machines (Ubuntu/macOS).

## Architecture Overview

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Manager Node  │    │   Worker Node   │    │   Worker Node   │
│   (Ubuntu/macOS)│    │   (Ubuntu/macOS)│    │   (Ubuntu/macOS)│
│                 │    │                 │    │                 │
│ - Swarm Manager │    │ - Swarm Worker  │    │ - Swarm Worker  │
│ - Load Balancer │    │ - App Services  │    │ - App Services  │
│ - Monitoring    │    │ - Databases     │    │ - Storage       │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
                    ┌─────────────────┐
                    │  Overlay Network │
                    │  (swarm-network)│
                    └─────────────────┘
```

## Quick Start

1. **Initialize Swarm on Manager Node:**
   ```bash
   cd docker-swarm
   ./scripts/init-swarm.sh
   ```

2. **Join Worker Nodes:**
   ```bash
   ./scripts/join-worker.sh <manager-ip>
   ```

3. **Deploy Services:**
   ```bash
   ./scripts/deploy-stack.sh production
   ```

## Directory Structure

```
docker-swarm/
├── README.md                    # This file
├── docker-compose.yml           # Main stack definition
├── docker-compose.override.yml  # Local overrides
├── .env                         # Environment variables
├── .env.example                 # Environment template
├── configs/                     # Configuration files
│   ├── nginx/
│   ├── traefik/
│   ├── prometheus/
│   └── grafana/
├── secrets/                     # Docker secrets
│   ├── db-passwords/
│   ├── ssl-certificates/
│   └── api-keys/
├── networks/                    # Network definitions
│   ├── frontend-network.yml
│   ├── backend-network.yml
│   └── database-network.yml
├── volumes/                     # Volume definitions
│   ├── postgres-data.yml
│   ├── redis-data.yml
│   └── app-data.yml
├── services/                    # Service definitions
│   ├── web/
│   ├── api/
│   ├── databases/
│   ├── monitoring/
│   ├── storage/
│   └── utilities/
├── scripts/                     # Management scripts
│   ├── init-swarm.sh
│   ├── join-worker.sh
│   ├── deploy-stack.sh
│   ├── update-service.sh
│   ├── backup-volumes.sh
│   └── health-check.sh
├── environments/                # Environment-specific configs
│   ├── development/
│   ├── staging/
│   └── production/
└── docs/                        # Documentation
    ├── setup-guide.md
    ├── troubleshooting.md
    └── best-practices.md
```

## Features

- **Multi-Node Setup**: Support for Ubuntu and macOS nodes
- **Service Discovery**: Built-in DNS resolution
- **Load Balancing**: Automatic load balancing across nodes
- **Secrets Management**: Secure handling of sensitive data
- **Volume Management**: Persistent storage across nodes
- **Monitoring**: Prometheus + Grafana stack
- **Reverse Proxy**: Traefik for automatic SSL and routing
- **Backup**: Automated backup of volumes and configurations
- **Health Checks**: Service health monitoring and auto-recovery

## Prerequisites

- Docker Engine 20.10+ on all nodes
- Docker Compose 2.0+
- Network connectivity between nodes
- SSH access for remote management (optional)

## Security Considerations

- Use Docker secrets for sensitive data
- Enable TLS for swarm communication
- Implement network segmentation
- Regular security updates
- Access control and RBAC

## Monitoring & Logging

- **Prometheus**: Metrics collection
- **Grafana**: Visualization and dashboards
- **ELK Stack**: Centralized logging
- **Health Checks**: Service monitoring

## Backup & Recovery

- Automated volume backups
- Configuration versioning
- Disaster recovery procedures
- Data migration tools

---

For detailed setup instructions, see [docs/setup-guide.md](docs/setup-guide.md)
