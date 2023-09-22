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


terraform {
    required_providers {
        google = {
            source = "hashicorp/google"
            version = "4.51.0"

        }
    }
}

provider "google" {
    credentials = file("/Users/sary357/Desktop/gogox/gogox-analytics-non-prod-2a93cdbfc33e.json")
    project = var.project_id
    region = var.region #"asia-southeast1"
    zone = var.zone #"asia-southeast1-a"
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
  initial_node_count=1
  release_channel {
    channel = "RAPID"
  }
  timeouts {
    create = "10m"
    update = "20m"
  }

  network    = google_compute_network.vpc_network.name
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
      functions = "fuming-poc"
    }

    # preemptible  = true
    machine_type = "e2-standard-2"
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

