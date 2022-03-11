# How can we delete default_node_pool??
- At the begining, we need to have default_node_pool in gke.tf

```
....
....

# GKE cluster
resource "google_container_cluster" "primary" {
  name     = "${var.project_id}-${var.my_name}-gke"
  location = var.zone
  min_master_version = var.gke_version
  # node_version = var.gke_version
  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = false
  initial_node_count       = 1
  node_config {
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
  } 

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

....
....
```

- Execute terraform apply to create a GKE cluster

```
$ terraform apply
```

- Wait for several minutes, we will get a GKE cluster like `gogox-analytics-non-prod-fuming-gke`

- Ensure the remote cluster status is sync with local tfstate file

```
$ terraform apply -refresh-only
```

- Remove default_node_pool on GCP console (eg: https://console.cloud.google.com/kubernetes/list/overview?project=gogox-analytics-non-prod)

- Modify `terraform.tfstate` and change `remove_default_node_pool` in it.

```
...
...
   "remove_default_node_pool": true, # original value is null, we need to use true here
...
...
```

- update gke.tf 1) remove_default_node_pool = true 2) comment out node_config in default_node_pool

```
resource "google_container_cluster" "primary" {
  name     = "${var.project_id}-${var.my_name}-gke"
  location = var.zone
  min_master_version = var.gke_version
  # node_version = var.gke_version
  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true # modify remove_default_node_pool = true
  initial_node_count       = 1

  /* comment out node_config
  node_config {
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

....

```

- execute `terraform plan`. 
```
$ terraform plan
google_compute_network.vpc: Refreshing state... [id=projects/gogox-analytics-non-prod/global/networks/gogox-analytics-non-prod-fuming-vpc]
google_compute_subnetwork.subnet: Refreshing state... [id=projects/gogox-analytics-non-prod/regions/asia-southeast1/subnetworks/gogox-analytics-non-prod-fuming-subnet]
google_compute_firewall.firewall: Refreshing state... [id=projects/gogox-analytics-non-prod/global/firewalls/gogox-analytics-non-prod-fuming-vpc-fw]
google_container_cluster.primary: Refreshing state... [id=projects/gogox-analytics-non-prod/locations/asia-southeast1-a/clusters/gogox-analytics-non-prod-fuming-gke]
google_container_node_pool.primary_nodes: Refreshing state... [id=projects/gogox-analytics-non-prod/locations/asia-southeast1-a/clusters/gogox-analytics-non-prod-fuming-gke/nodePools/gogox-analytics-non-prod-fuming-npl]
google_container_node_pool.primary_nodes2: Refreshing state... [id=projects/gogox-analytics-non-prod/locations/asia-southeast1-a/clusters/gogox-analytics-non-prod-fuming-gke/nodePools/gogox-analytics-non-prod-fuming-npl2]

No changes. Your infrastructure matches the configuration.


```
