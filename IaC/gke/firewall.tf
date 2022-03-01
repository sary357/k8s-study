
resource "google_compute_firewall" "firewall" {
  name                    = "${var.project_id}-${var.my_name}-vpc-fw"
  network =google_compute_network.vpc.name
  project  = var.project_id

  allow {
    protocol = "tcp"
    ports = ["80", "443", "8080", "8443"]
  }

  source_tags=["web"]
  source_ranges=["0.0.0.0/0"]
}
