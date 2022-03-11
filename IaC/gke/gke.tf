variable "gke_username" {
  default     = ""
  description = "gke username"
}

variable "gke_password" {
  default     = ""
  description = "gke password"
}

variable "gke_num_nodes" {
  description = "number of gke nodes"
}

variable "service_account" {
  description = "service account we use to create GKE clusters"
}

variable "zone" {
  description = "zone"
}

variable "gke_version" {
  description = "GKE version"
}

# GKE cluster
resource "google_container_cluster" "primary" {
  name     = "${var.project_id}-${var.my_name}-gke"
  location = var.zone
  min_master_version = var.gke_version
  # node_version = var.gke_version
  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1
/*  node_config {
    service_account = var.service_account
    machine_type = "e2-micro"
    # image_type   = "COS" # GKE does not support COS
    image_type = "COS_CONTAINERD"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    labels = {
      foo = "qqq"
    }
  } */

  release_channel {
    channel = "RAPID"
  }
  timeouts {
    create = "10m"
    update = "20m"
  }
  
  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name
}

# Separately Managed Node Pool
resource "google_container_node_pool" "primary_nodes" {
  name       = "${var.project_id}-${var.my_name}-npl"
  location   = var.zone
  cluster    = google_container_cluster.primary.name
  node_count = var.gke_num_nodes

  node_config {
    service_account = var.service_account
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels = {
      env = var.project_id
      foo = "ppp"
    }

    # preemptible  = true
    machine_type = "n1-standard-2"
    # image_type   = "COS" # GKE does not support COS
    image_type   = "COS_CONTAINERD"
    tags         = ["gke-node", "${var.project_id}-${var.my_name}-gke"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
  timeouts {
    create = "10m"
    update = "20m"
  }
}

resource "google_container_node_pool" "primary_nodes2" {
  name       = "${var.project_id}-${var.my_name}-npl2"
  location   = var.zone
  cluster    = google_container_cluster.primary.name
  node_count = 1

  node_config {
    service_account = var.service_account
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels = {
      env = var.project_id
      foo = "ppp"
    }

    # preemptible  = true
    machine_type = "n1-standard-2"
    # image_type   = "COS" # GKE does not support COS
    image_type   = "COS_CONTAINERD"
    tags         = ["gke-node", "${var.project_id}-${var.my_name}-gke"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
  timeouts {
    create = "10m"
    update = "20m"
  }
}


# # Kubernetes provider
# # The Terraform Kubernetes Provider configuration below is used as a learning reference only. 
# # It references the variables and resources provisioned in this file. 
# # We recommend you put this in another file -- so you can have a more modular configuration.
# # https://learn.hashicorp.com/terraform/kubernetes/provision-gke-cluster#optional-configure-terraform-kubernetes-provider
# # To learn how to schedule deployments and services using the provider, go here: https://learn.hashicorp.com/tutorials/terraform/kubernetes-provider.

# provider "kubernetes" {
#   load_config_file = "false"

#   host     = google_container_cluster.primary.endpoint
#   username = var.gke_username
#   password = var.gke_password

#   client_certificate     = google_container_cluster.primary.master_auth.0.client_certificate
#   client_key             = google_container_cluster.primary.master_auth.0.client_key
#   cluster_ca_certificate = google_container_cluster.primary.master_auth.0.cluster_ca_certificate
# }

