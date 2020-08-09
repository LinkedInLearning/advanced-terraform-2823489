# //////////////////////////////
# PROVIDERS
# //////////////////////////////
provider "google" {
  region = var.region
  project = var.project
}

# //////////////////////////////
# DATA
# //////////////////////////////
data "google_project" "current" {}

data "google_compute_default_service_account" "default" {}

data "google_compute_image" "debian_image" {
  family  = "debian-9"
  project = "debian-cloud"
}

# //////////////////////////////
# RESOURCES
# //////////////////////////////

// GCP Virtual Private Cloud (VPC)
resource "google_compute_network" "default" {
  name                    = var.network_name
  auto_create_subnetworks = false
}

resource "google_compute_address" "static" {
  name = "ipv4-address"
}

// Subnet
resource "google_compute_subnetwork" "default" {
  name                     = var.network_name
  ip_cidr_range            = var.network_cidr
  network                  = google_compute_network.default.self_link
  region                   = var.region
  private_ip_google_access = true
}

// VM Instance: Google Compute Engine
resource "google_compute_instance" "nodejs1" {
  name                      = "nodejs1"
  zone                      = var.zone
  machine_type              = var.machine_type
  min_cpu_platform          = var.min_cpu_platform
  allow_stopping_for_update = true

  boot_disk {
    auto_delete = var.disk_auto_delete

    initialize_params {
      image = data.google_compute_image.debian_image.self_link
      size  = var.disk_size_gb
      type  = var.disk_type
    }
  }

  network_interface {
    subnetwork    = google_compute_subnetwork.default.name
    access_config {
      nat_ip        = google_compute_address.static.address
    }
    
  }

  service_account {
    email  = var.service_account_email == "" ? data.google_compute_default_service_account.default.email : var.service_account_email
    scopes = var.service_account_scopes
  }
}

// Firewall rules
resource "google_compute_firewall" "ssh" {
  name    = "firewall-ssh"
  network = google_compute_subnetwork.default.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

output "public_ip" {
  value = google_compute_address.static.address
}

output "instance_name" {
  value = google_compute_instance.nodejs1.name
}

output "ssh" {
  value = "gcloud compute ssh $(terraform output instance_name)"
}