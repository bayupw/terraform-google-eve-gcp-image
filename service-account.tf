# Create service account for accessing storage bucket
resource "google_service_account" "this" {
  count = var.create_service_account ? 1 : 0

  project      = var.project_id
  account_id   = local.service_account_name
  display_name = "Storage Service Account for EVE Image Upload"
}

# Assign roles and condition to the service account
resource "google_project_iam_member" "this" {
  count = var.create_service_account ? 1 : 0

  project = var.project_id
  role    = "roles/storage.objectAdmin"
  member  = "serviceAccount:${google_service_account.this[0].email}"

  condition {
    title      = "restrict_specific_resource"
    expression = "resource.name.startsWith('projects/_/buckets/${google_storage_bucket.this[0].id}')"
  }
}