module "eve-gcp-image" {
  source = "bayupw/eve-gcp-image/google"
  version = "1.0.0"

  project_id  = "bwibowo-01"
  region      = "australia-southeast1"
  eve_version = "8.11.0"
}

output "eve-gcp-image" {
  value = module.eve-gcp-image
}