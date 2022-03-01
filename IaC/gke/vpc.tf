variable "project_id" {
  description = "project id"
}

variable "region" {
  description = "region"
}

variable "my_name" {
  description = "my name"
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# VPC
resource "google_compute_network" "vpc" {
  name                    = "${var.project_id}-${var.my_name}-vpc"
  auto_create_subnetworks = "false"
  routing_mode="GLOBAL"
}

# Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "${var.project_id}-${var.my_name}-subnet"
  region        = var.region
  network       = google_compute_network.vpc.name
  ip_cidr_range = "10.10.12.0/24"
}
