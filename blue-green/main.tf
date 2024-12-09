terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

resource "google_container_cluster" "primary" {
  name     = "my-cluster"
  location = "us-central1-a"  # Ensure this location matches your intended region

  initial_node_count = 1  # Start with 2 nodes for initial scalability

  node_config {  # Default Node Pool configuration
    machine_type = "e2-micro"  # Consider resource requirements for your workloads
    disk_size_gb = 30          # Adjust disk size based on expected needs
  }
}



resource "google_container_node_pool" "scaling_pool" {
  cluster  = google_container_cluster.primary.name
  location = google_container_cluster.primary.location

  name             = "scaling-node-pool"
  initial_node_count = 0  # Start with 0 nodes in the scaling pool



  autoscaling {
    min_node_count = 1    # Minimum number of nodes in the pool
    max_node_count = 2    # Maximum number of nodes in the pool (adjust based on needs)
  } 
    
  node_config {
    machine_type = "e2-micro"  # Consider resource requirements for your workloads
    disk_size_gb = 20          # Adjust disk size based on expected needs
    disk_type    = "pd-standard"  # Standard Persistent Disk (adjust if needed)
 }


}

