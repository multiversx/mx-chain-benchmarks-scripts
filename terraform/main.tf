provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}


data "google_compute_image" "ubuntu" {
  family  = var.boot_image
  project = "ubuntu-os-cloud"
}


data "google_compute_network" "vpc_network" {
  name = var.vpc_name
}


data "google_compute_subnetwork" "subnetwork" {
  name   = var.subnetwork_name
  region = var.region
}


resource "google_compute_instance" "validator_instances" {
  count        = var.instance_number
  name         = "validator-${count.index}"
  machine_type = "custom-${var.vcpu_count}-${var.memory_mb}"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = data.google_compute_image.ubuntu.self_link
      size  = var.disk_size_gb
      type  = "pd-standard" 
    }
  }

  network_interface {
    network    = data.google_compute_network.vpc_network.self_link
    subnetwork = data.google_compute_subnetwork.subnetwork.self_link
    access_config {}
  }

  tags = ["validator"]


  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.ssh_public_key_path)}"
  }


  metadata_startup_script = <<-EOT
    #!/bin/bash
    sudo apt-get update
    sudo apt-get install -y python3 python3-pip
    sudo pip3 install ansible
  EOT
}