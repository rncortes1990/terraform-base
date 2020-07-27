provider "google" {
  version = "3.5.0"

  credentials = file("raulcortes.json")

  project = var.project
  region = var.region
  zone = "${var.region}-c"
}
variable "project" {
    default ="devops-260319"
}
variable "region" {
    default = "us-central1"
}
variable "zone" {
    default ="devops-260319"
}
resource "google_compute_network" "vpc_network" {
  name = "new-terraform-network"
}
resource "google_compute_instance" "vm_instance" {
  name = "new-terraform-cei"
  metadata_startup_script=file("init.sh")
  machine_type = "f1-micro"
  tags =["web"]
  zone = "${var.region}-c"
  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-7"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
    }
  }
}

resource "google_compute_firewall" "default" {
  name    = "test-firewall"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "1000-2000"]
  }

  source_tags = ["web"]
  source_ranges = ["0.0.0.0/0"]
}