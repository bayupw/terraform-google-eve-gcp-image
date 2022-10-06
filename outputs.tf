output "bucket_id" {
  description = "Storage bucket ID."
  value       = var.create_storage_bucket ? google_storage_bucket.this[0].id : null
}

output "bucket_url" {
  description = "Storage bucket URL."
  value       = var.create_storage_bucket ? google_storage_bucket.this[0].url : null
}

output "vm_public_ip" {
  description = "VM public IP."
  value       = var.create_vpc_vm ? google_compute_instance.this[0].network_interface[0].access_config[0].nat_ip : null
}

output "service_account_email" {
  description = "Service account email."
  value       = var.create_service_account ? google_service_account.this[0].email : null
}

output "compute_image_name" {
  description = "GCP imported image name."
  value       = var.create_gcp_image ? google_compute_image.this[0].name : null
}

output "compute_image_id" {
  description = "GCP imported image id (path)."
  value       = var.create_gcp_image ? google_compute_image.this[0].id : null
}
