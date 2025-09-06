#!/bin/bash

# Docker Swarm Worker Join Script
# This script joins a worker node to the Docker Swarm cluster

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

# Join the swarm
join_swarm() {
    local manager_ip="$1"
    
    if [ -z "$manager_ip" ]; then
        print_error "Manager IP address is required"
        echo "Usage: $0 <manager-ip>"
        echo "Example: $0 192.168.1.100"
        exit 1
    fi
    
    print_status "Joining Docker Swarm cluster at $manager_ip..."
    
    # Check if already in swarm mode
    if docker info --format '{{.Swarm.LocalNodeState}}' | grep -q "active"; then
        print_warning "This node is already part of a Docker Swarm cluster"
        return 0
    fi
    
    # Get the join token from the manager
    print_status "Retrieving join token from manager..."
    
    # Try to get the join token via SSH or API
    # For simplicity, we'll prompt the user to get it from the manager
    print_warning "Please run the following command on the manager node to get the join token:"
    echo "  docker swarm join-token worker"
    echo ""
    read -p "Enter the join token: " join_token
    
    if [ -z "$join_token" ]; then
        print_error "Join token is required"
        exit 1
    fi
    
    # Join the swarm
    docker swarm join --token "$join_token" "$manager_ip:2377"
    
    print_success "Successfully joined Docker Swarm cluster"
}

# Label the worker node
label_worker() {
    print_status "Labeling worker node..."
    
    # Get the current node ID
    NODE_ID=$(docker info --format '{{.Swarm.NodeID}}')
    
    # Add common labels for worker nodes
    docker node update --label-add role=worker "$NODE_ID"
    
    # Ask user for specific node labels
    echo ""
    print_status "Would you like to add specific labels to this node?"
    echo "Available options:"
    echo "  - database: For database services"
    echo "  - storage: For storage services"
    echo "  - logging: For logging services"
    echo "  - compute: For compute-intensive services"
    echo ""
    
    read -p "Add database label? (y/n): " add_db
    if [[ $add_db =~ ^[Yy]$ ]]; then
        docker node update --label-add database=true "$NODE_ID"
        print_success "Added database label"
    fi
    
    read -p "Add storage label? (y/n): " add_storage
    if [[ $add_storage =~ ^[Yy]$ ]]; then
        docker node update --label-add storage=true "$NODE_ID"
        print_success "Added storage label"
    fi
    
    read -p "Add logging label? (y/n): " add_logging
    if [[ $add_logging =~ ^[Yy]$ ]]; then
        docker node update --label-add logging=true "$NODE_ID"
        print_success "Added logging label"
    fi
    
    read -p "Add compute label? (y/n): " add_compute
    if [[ $add_compute =~ ^[Yy]$ ]]; then
        docker node update --label-add compute=true "$NODE_ID"
        print_success "Added compute label"
    fi
}

# Display node information
show_node_info() {
    print_status "Node information:"
    echo ""
    echo "Node ID: $(docker info --format '{{.Swarm.NodeID}}')"
    echo "Node Role: $(docker info --format '{{.Swarm.ControlAvailable}}')"
    echo "Node Labels:"
    docker node inspect "$(docker info --format '{{.Swarm.NodeID}}')" --format '{{range $key, $value := .Spec.Labels}}{{$key}}={{$value}}{{"\n"}}{{end}}'
    echo ""
}

# Main execution
main() {
    local manager_ip="$1"
    
    print_status "Starting Docker Swarm worker join process..."
    
    check_docker
    join_swarm "$manager_ip"
    label_worker
    show_node_info
    
    print_success "Worker node setup completed successfully!"
    print_status "This node is now ready to run Docker Swarm services"
}

# Run main function
main "$@"
