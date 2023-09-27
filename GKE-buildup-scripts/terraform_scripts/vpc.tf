variable "project_id" {
  description = "project id"
}

variable "region" {
  description = "region"
}

variable "my_name" {
  description = "my name"
}

variable "network_range" {
  description = "network range"
}

# VPC
resource "google_compute_network" "vpc_network" {
  name                    = "${var.project_id}-${var.my_name}-vpc"
  auto_create_subnetworks = "false"
  routing_mode="GLOBAL"
}

# Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "${var.project_id}-${var.my_name}-subnet"
  region        = var.region
  network       = google_compute_network.vpc_network.name
  ip_cidr_range = "${var.network_range}"
}
