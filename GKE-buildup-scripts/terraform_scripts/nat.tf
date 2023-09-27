resource "google_compute_address" "address" {
  count  = 2
  name   = "${var.project_id}-${var.my_name}-ip${count.index}"
}


resource "google_compute_router" "nat_router" {
  name    = "${var.project_id}-${var.my_name}-nat-router"
  network = google_compute_network.vpc_network.name
}

resource "google_compute_router_nat" "cloud_nat" {
  name           = "${var.project_id}-${var.my_name}-cloud-nat"
  router         = google_compute_router.nat_router.name
  nat_ips                            = google_compute_address.address.*.self_link
  nat_ip_allocate_option             = "MANUAL_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

