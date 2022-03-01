terraform {
    required_providers {
        google = {
            source = "hashicorp/google"
            version = "3.5.0"
        }
    }
}

provider "google" {
    credentials = file("gogox-analytics-non-prod-a087b798bad5.json")
    project = "gogox-analytics-non-prod"
    region = "asia-southeast1"
    zone = "asia-southeast1-a"
}

resource "google_compute_network" "vpc_network" {
    name = "fu-ming-poc-vpc-subnet"
}


