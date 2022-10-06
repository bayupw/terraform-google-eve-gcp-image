# Generate random string
resource "random_string" "this" {
  count = var.create_storage_bucket && var.random_suffix ? 1 : 0

  length  = var.random_string_length
  numeric = true
  special = false
  upper   = false
}

# Create cloud storage bucket for eve image
resource "google_storage_bucket" "this" {
  count = var.create_storage_bucket ? 1 : 0

  project                     = var.project_id
  name                        = var.random_suffix ? "${lower(var.bucket_name)}-${random_string.this[0].id}" : lower(var.bucket_name)
  location                    = var.region
  force_destroy               = true
  storage_class               = var.storage_class
  uniform_bucket_level_access = var.uniform_bucket_level_access
}