#!/bin/bash

# Docker Swarm Stack Deployment Script
# This script deploys the complete Docker Swarm stack

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we're in swarm mode
check_swarm() {
    print_status "Checking Docker Swarm status..."
    
    if ! docker info --format '{{.Swarm.LocalNodeState}}' | grep -q "active"; then
        print_error "Docker Swarm is not active. Please initialize swarm first."
        echo "Run: ./scripts/init-swarm.sh"
        exit 1
    fi
    
    print_success "Docker Swarm is active"
}

# Check if we're on a manager node
check_manager() {
    print_status "Checking if this is a manager node..."
    
    if ! docker info --format '{{.Swarm.ControlAvailable}}' | grep -q "true"; then
        print_error "This is not a manager node. Stack deployment must be run on a manager node."
        exit 1
    fi
    
    print_success "This is a manager node"
}

# Check environment file
check_env() {
    print_status "Checking environment configuration..."
    
    if [ ! -f .env ]; then
        print_warning ".env file not found. Creating from template..."
        cp env.example .env
        print_warning "Please edit .env file with your actual values before proceeding"
        print_warning "Run: nano .env"
        exit 1
    fi
    
    # Source environment variables
    source .env
    
    # Check required variables
    required_vars=("DOMAIN" "ACME_EMAIL" "POSTGRES_DB" "POSTGRES_USER" "REDIS_PASSWORD" "MINIO_ROOT_USER")
    
    for var in "${required_vars[@]}"; do
        if [ -z "${!var}" ]; then
            print_error "Required environment variable $var is not set"
            exit 1
        fi
    done
    
    print_success "Environment configuration is valid"
}

# Create secrets if they don't exist
create_secrets() {
    print_status "Creating Docker secrets..."
    
    # Create secrets if they don't exist
    if ! docker secret ls --format "{{.Name}}" | grep -q "postgres_password"; then
        echo "${POSTGRES_PASSWORD:-$(openssl rand -base64 32)}" | docker secret create postgres_password -
        print_success "Created postgres_password secret"
    else
        print_warning "postgres_password secret already exists"
    fi
    
    if ! docker secret ls --format "{{.Name}}" | grep -q "grafana_password"; then
        echo "${GRAFANA_PASSWORD:-$(openssl rand -base64 32)}" | docker secret create grafana_password -
        print_success "Created grafana_password secret"
    else
        print_warning "grafana_password secret already exists"
    fi
    
    if ! docker secret ls --format "{{.Name}}" | grep -q "minio_password"; then
        echo "${MINIO_ROOT_PASSWORD:-$(openssl rand -base64 32)}" | docker secret create minio_password -
        print_success "Created minio_password secret"
    else
        print_warning "minio_password secret already exists"
    fi
}

# Deploy the stack
deploy_stack() {
    local stack_name="${1:-homelab}"
    local environment="${2:-production}"
    
    print_status "Deploying Docker Swarm stack: $stack_name"
    print_status "Environment: $environment"
    
    # Check if stack already exists
    if docker stack ls --format "{{.Name}}" | grep -q "$stack_name"; then
        print_warning "Stack $stack_name already exists. Updating..."
        docker stack deploy -c docker-compose.yml "$stack_name"
    else
        print_status "Creating new stack: $stack_name"
        docker stack deploy -c docker-compose.yml "$stack_name"
    fi
    
    print_success "Stack deployment initiated"
}

# Wait for services to be ready
wait_for_services() {
    local stack_name="${1:-homelab}"
    
    print_status "Waiting for services to be ready..."
    
    # Wait for all services to be running
    timeout=300  # 5 minutes
    elapsed=0
    
    while [ $elapsed -lt $timeout ]; do
        running_services=$(docker service ls --filter "name=${stack_name}_" --format "{{.Replicas}}" | grep -c "1/1\|2/2\|3/3" || true)
        total_services=$(docker service ls --filter "name=${stack_name}_" --format "{{.Name}}" | wc -l)
        
        if [ "$running_services" -eq "$total_services" ] && [ "$total_services" -gt 0 ]; then
            print_success "All services are running"
            break
        fi
        
        print_status "Waiting for services... ($running_services/$total_services ready)"
        sleep 10
        elapsed=$((elapsed + 10))
    done
    
    if [ $elapsed -ge $timeout ]; then
        print_warning "Timeout waiting for services to be ready"
        print_status "Current service status:"
        docker service ls --filter "name=${stack_name}_"
    fi
}

# Display service information
show_services() {
    local stack_name="${1:-homelab}"
    
    print_status "Service information:"
    echo ""
    docker service ls --filter "name=${stack_name}_"
    echo ""
    
    print_status "Service details:"
    echo ""
    for service in $(docker service ls --filter "name=${stack_name}_" --format "{{.Name}}"); do
        echo "=== $service ==="
        docker service ps "$service" --no-trunc
        echo ""
    done
}

# Display access information
show_access_info() {
    print_status "Access information:"
    echo ""
    echo "Traefik Dashboard: http://localhost:8080"
    echo "Grafana: http://grafana.${DOMAIN:-local}"
    echo "Prometheus: http://prometheus.${DOMAIN:-local}"
    echo "Kibana: http://kibana.${DOMAIN:-local}"
    echo "MinIO: http://minio.${DOMAIN:-local}"
    echo "Web App: http://app.${DOMAIN:-local}"
    echo "API: http://api.${DOMAIN:-local}"
    echo ""
    print_warning "Note: Update your /etc/hosts file to resolve domain names to your manager node IP"
    echo "Example: echo '192.168.1.100 app.local api.local grafana.local' >> /etc/hosts"
}

# Main execution
main() {
    local stack_name="${1:-homelab}"
    local environment="${2:-production}"
    
    print_status "Starting Docker Swarm stack deployment..."
    
    check_swarm
    check_manager
    check_env
    create_secrets
    deploy_stack "$stack_name" "$environment"
    wait_for_services "$stack_name"
    show_services "$stack_name"
    show_access_info
    
    print_success "Docker Swarm stack deployment completed successfully!"
    print_status "Next steps:"
    echo "  1. Update your /etc/hosts file with the domain mappings"
    echo "  2. Access the services using the URLs above"
    echo "  3. Check logs with: docker service logs <service-name>"
    echo "  4. Scale services with: docker service scale <service-name>=<replicas>"
}

# Run main function
main "$@"
