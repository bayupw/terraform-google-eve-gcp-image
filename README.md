# Terraform EVE-OS Image for GCP

Terraform module to generate an EVE-OS image, upload it to a GCP storage bucket and store it as a GCP VM image.

This module will perform the following:
1. GCP storage bucket (by default)
2. Service account to access GCP storage bucket (by default)
3. Create VPC and firewall rules
4. Create Ubuntu VM with Docker and gcloud CLI installed
5. Run docker lfedge/eve:<version/latest>-kvm-amd64 -f gcp live > /tmp/<eve_image_name>.tar.gz
6. Copy image to storage bucket via gsutil cp /tmp/<eve_image_name>.tar.gz gs://$<bucket_name>/$<eve_image_name>.tar.gz

<img src="https://github.com/bayupw/terraform-google-eve-gcp-image/raw/main/images/terraform-google-eve-gcp-image.png?raw=true">

```bash
export GOOGLE_APPLICATION_CREDENTIALS=gcp-key.json
export GOOGLE_PROJECT="my-project-id"
export GOOGLE_ZONE="australia-southeast1"
```

## Usage with specific EVE-OS version

```hcl
module "eve-gcp-image" {
  source  = "bayupw/eve-gcp-image/google"
  version = "1.0.0"

  project_id   = "my-project-id"
  region       = "australia-southeast1"
  eve_version  = "8.11.0"
}

output "eve-gcp-image" {
  value       = module.eve-gcp-image
}
```

## Contributing

Report issues/questions/feature requests on in the [issues](https://github.com/bayupw/terraform-google-eve-gcp-image/issues/new) section.

## License

Apache 2 Licensed. See [LICENSE](https://github.com/bayupw/terraform-google-eve-gcp-image/tree/master/LICENSE) for full details.