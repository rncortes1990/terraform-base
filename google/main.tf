provider "google" {
  version = "3.5.0"
  credentials = file("lab3.json")
  project = "using-terraf-156-c5b0f1"
  region  = "us-central1"
  zone    = "us-central1-c"
}
resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
}
variable "subnetwork" {
  default="misubred"
}
resource "google_compute_subnetwork" "public-subnetwork" {
  name          = var.subnetwork
  ip_cidr_range = "10.2.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.vpc_network.name
  }