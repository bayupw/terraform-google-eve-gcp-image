# Create VPC
resource "google_compute_network" "this" {
  count = var.create_vpc_vm ? 1 : 0

  project                 = var.project_id
  name                    = var.network_name
  auto_create_subnetworks = false
  routing_mode            = var.routing_mode
}

# Create subnet
resource "google_compute_subnetwork" "this" {
  count = var.create_vpc_vm ? 1 : 0

  project       = var.project_id
  name          = var.subnet_name
  ip_cidr_range = var.subnet_cidr
  region        = var.region
  network       = google_compute_network.this[0].id
}

# Retrieve my public IP
data "http" "myip" {
  url = "http://ifconfig.me"
}

# Create firewall from my public IP
resource "google_compute_firewall" "default" {
  count = var.create_vpc_vm ? 1 : 0

  project = var.project_id
  name    = "${var.network_name}-firewall"
  network = google_compute_network.this[0].name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = [80, 443, 22]
  }

  source_ranges = ["${chomp(data.http.myip.response_body)}/32"]
}

# Create firewall for IAP https://cloud.google.com/iap/docs/tcp-by-host
resource "google_compute_firewall" "iap" {
  count = var.create_vpc_vm ? 1 : 0

  project = var.project_id
  name    = "${var.network_name}-iap"
  network = google_compute_network.this[0].name

  allow {
    protocol = "tcp"
    ports    = [22]
  }

  source_ranges = local.iap_range
}

# Render startup script
data "template_file" "this" {
  count = var.create_vpc_vm ? 1 : 0

  template = file("${path.module}/startup.sh")
  vars = {
    eve    = var.eve_version
    image  = var.eve_image_name
    bucket = local.bucket
    shutdown = var.shutdown_vm ? "sudo shutdown -h now" : ""
  }
}

# Create VM instance with docker
resource "google_compute_instance" "this" {
  count = var.create_vpc_vm ? 1 : 0

  project      = var.project_id
  name         = var.vm_name
  machine_type = var.machine_type
  zone         = "${var.region}-${var.zone}"

  boot_disk {
    initialize_params {
      image = var.gcp_image
    }
  }

  network_interface {
    network    = google_compute_network.this[0].name
    subnetwork = google_compute_subnetwork.this[0].name

    access_config {
      // Ephemeral public IP
    }
  }

  metadata_startup_script = data.template_file.this[0].rendered

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = local.vm_service_account
    scopes = ["cloud-platform"]
  }
}

# Wait for bash script (install docker, download eve-os, upload image to cloud storage) to be completed before throwing output
resource "time_sleep" "this" {
  count = var.create_vpc_vm ? 1 : 0

  create_duration = var.wait_time
  depends_on      = [google_compute_instance.this]
}

# Wait for EVE image to be uploaded to cloud storage before creating compute image 
resource "google_compute_image" "this" {
  count = var.create_gcp_image ? 1 : 0

  project = var.project_id
  name    = var.eve_image_name

  raw_disk {
    source = "https://storage.googleapis.com/${google_storage_bucket.this[0].id}/${var.eve_image_name}.tar.gz"
  }

  guest_os_features {
    type = "SECURE_BOOT"
  }

  depends_on = [time_sleep.this]
}

locals {
  iap_range       = ["35.235.240.0/20"] # https://cloud.google.com/iap/docs/tcp-by-host
  bucket          = var.create_storage_bucket ? google_storage_bucket.this[0].id : var.bucket_name
  service_account = var.create_service_account ? var.service_account_name : var.service_account_email
  vm_service_account = var.create_service_account ? google_service_account.this[0].email : var.service_account_email
}