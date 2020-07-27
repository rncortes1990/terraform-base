provider "google" {
    version = "3.5.0"
    credentials = file("lab4.json")
    project = var.project
    region = var.region
    zone = var.zone
}

resource "google_compute_network" "vpc_network" {
    name= "my-network"
}

resource "google_compute_instance" "mytfinstance"{
    name = "mytfinstance"
    machine_type = "f1-micro"
    zone = "${var.zone}"
    boot_disk {
        initialize_params{
            image = "centos-cloud/centos-7"
        }
    }

    network_interface {
        network = google_compute_network.vpc_network.name
        access_config{

        }
    }

}