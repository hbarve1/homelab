#!/bin/bash

# Docker Swarm Initialization Script
# This script initializes a Docker Swarm cluster on the manager node

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

# Check if Docker is installed and running
check_docker() {
    print_status "Checking Docker installation..."
    
    if ! command -v docker &> /dev/null; then
        print_error "Docker is not installed. Please install Docker first."
        exit 1
    fi
    
    if ! docker info &> /dev/null; then
        print_error "Docker daemon is not running. Please start Docker first."
        exit 1
    fi
    
    print_success "Docker is installed and running"
}

# Check if Docker Compose is available
check_docker_compose() {
    print_status "Checking Docker Compose..."
    
    if ! docker compose version &> /dev/null; then
        print_error "Docker Compose is not available. Please install Docker Compose."
        exit 1
    fi
    
    print_success "Docker Compose is available"
}

# Initialize Docker Swarm
init_swarm() {
    print_status "Initializing Docker Swarm..."
    
    # Check if already in swarm mode
    if docker info --format '{{.Swarm.LocalNodeState}}' | grep -q "active"; then
        print_warning "Docker Swarm is already initialized"
        return 0
    fi
    
    # Get the current machine's IP address
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        MANAGER_IP=$(ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}' | head -n1)
    else
        # Linux
        MANAGER_IP=$(hostname -I | awk '{print $1}')
    fi
    
    print_status "Using IP address: $MANAGER_IP"
    
    # Initialize swarm
    docker swarm init --advertise-addr "$MANAGER_IP"
    
    print_success "Docker Swarm initialized successfully"
    
    # Save the join token for workers
    echo "MANAGER_IP=$MANAGER_IP" > .swarm-info
    echo "JOIN_TOKEN=$(docker swarm join-token worker -q)" >> .swarm-info
    echo "MANAGER_TOKEN=$(docker swarm join-token manager -q)" >> .swarm-info
    
    print_success "Swarm information saved to .swarm-info"
}

# Create Docker secrets
create_secrets() {
    print_status "Creating Docker secrets..."
    
    # Check if .env file exists
    if [ ! -f .env ]; then
        print_warning ".env file not found. Creating from template..."
        cp env.example .env
        print_warning "Please edit .env file with your actual values before proceeding"
        return 1
    fi
    
    # Source environment variables
    source .env
    
    # Create secrets if they don't exist
    if ! docker secret ls --format "{{.Name}}" | grep -q "postgres_password"; then
        echo "${POSTGRES_PASSWORD:-$(openssl rand -base64 32)}" | docker secret create postgres_password -
        print_success "Created postgres_password secret"
    fi
    
    if ! docker secret ls --format "{{.Name}}" | grep -q "grafana_password"; then
        echo "${GRAFANA_PASSWORD:-$(openssl rand -base64 32)}" | docker secret create grafana_password -
        print_success "Created grafana_password secret"
    fi
    
    if ! docker secret ls --format "{{.Name}}" | grep -q "minio_password"; then
        echo "${MINIO_ROOT_PASSWORD:-$(openssl rand -base64 32)}" | docker secret create minio_password -
        print_success "Created minio_password secret"
    fi
}

# Create overlay networks
create_networks() {
    print_status "Creating overlay networks..."
    
    # Create networks if they don't exist
    networks=("frontend" "backend" "database" "monitoring" "logging" "storage")
    
    for network in "${networks[@]}"; do
        if ! docker network ls --format "{{.Name}}" | grep -q "$network"; then
            docker network create \
                --driver overlay \
                --attachable \
                --opt encrypted=true \
                "$network"
            print_success "Created network: $network"
        else
            print_warning "Network $network already exists"
        fi
    done
}

# Label the manager node
label_manager() {
    print_status "Labeling manager node..."
    
    MANAGER_NODE_ID=$(docker info --format '{{.Swarm.NodeID}}')
    docker node update --label-add role=manager "$MANAGER_NODE_ID"
    docker node update --label-add database=true "$MANAGER_NODE_ID"
    docker node update --label-add storage=true "$MANAGER_NODE_ID"
    docker node update --label-add logging=true "$MANAGER_NODE_ID"
    
    print_success "Manager node labeled successfully"
}

# Display join commands
show_join_commands() {
    print_status "Docker Swarm join commands:"
    echo ""
    echo "To join worker nodes, run the following command on each worker:"
    echo ""
    echo "  docker swarm join --token $(docker swarm join-token worker -q) $MANAGER_IP:2377"
    echo ""
    echo "To join manager nodes, run the following command on each manager:"
    echo ""
    echo "  docker swarm join --token $(docker swarm join-token manager -q) $MANAGER_IP:2377"
    echo ""
    echo "Join commands have been saved to .swarm-info file"
}

# Main execution
main() {
    print_status "Starting Docker Swarm initialization..."
    
    check_docker
    check_docker_compose
    init_swarm
    create_secrets
    create_networks
    label_manager
    show_join_commands
    
    print_success "Docker Swarm initialization completed successfully!"
    print_status "Next steps:"
    echo "  1. Join worker nodes using the commands above"
    echo "  2. Edit .env file with your actual values"
    echo "  3. Run './scripts/deploy-stack.sh' to deploy services"
}

# Run main function
main "$@"
