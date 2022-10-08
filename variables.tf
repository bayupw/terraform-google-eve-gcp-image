variable "project_id" {
  description = "The ID of the project in which the resource belongs."
  type        = string
}

variable "random_suffix" {
  description = "Set to true to append random suffix."
  type        = bool
  default     = true
}

# Length of random string to be appended to the name
variable "random_string_length" {
  description = "Random string length."
  type        = number
  default     = 4
}

variable "create_storage_bucket" {
  description = "Set to true to create a new storage bucket."
  type        = bool
  default     = true
}

variable "create_service_account" {
  description = "Set to true to create a new service account for accessing storage bucket."
  type        = bool
  default     = true
}

variable "create_vpc_vm" {
  description = "Set to true to create vm and vpc."
  type        = bool
  default     = true
}

variable "create_gcp_image" {
  description = "Set to true to create gcp image."
  type        = bool
  default     = true
}

variable "shutdown_vm" {
  description = "Set to true to shutdown gcp vm after uploading image."
  type        = bool
  default     = false
}

variable "service_account_name" {
  description = "New service account name."
  type        = string
  default     = "eve-storage-sa"
}

variable "service_account_email" {
  description = "Existing service account email format: name@email."
  type        = string
  default     = null
}

variable "bucket_name" {
  description = "Existing or new cloud storage bucket name/id without gs://."
  type        = string
  default     = "eve-image"
}

variable "uniform_bucket_level_access" {
  description = "Set to true to enable Uniform Bucket Level Access."
  type        = bool
  default     = true
}

variable "vm_name" {
  description = "GCP VM name."
  type        = string
  default     = "eve-installer-vm1"
}

variable "region" {
  description = "GCP region."
  type        = string
  default     = "australia-southeast1"
}

variable "routing_mode" {
  description = "Routing mode."
  type        = string
  default     = "REGIONAL"
}

variable "zone" {
  description = "GCP zone."
  type        = string
  default     = "a"
}

variable "storage_class" {
  description = "Cloud storage class."
  type        = string
  default     = "STANDARD"
}

variable "network_name" {
  description = "VPC name."
  type        = string
  default     = "eve-installer-vpc"
}

variable "subnet_name" {
  description = "Subnet name."
  type        = string
  default     = "eve-installer-subnet"
}

variable "subnet_cidr" {
  description = "Subnet CIDR."
  type        = string
  default     = "10.1.0.0/24"
}

variable "machine_type" {
  description = "GCP VM type."
  type        = string
  default     = "e2-micro"
}

variable "gcp_image" {
  description = "GCP VM image."
  type        = string
  default     = "ubuntu-2004-lts"
}

variable "eve_version" {
  description = "EVE-OS version."
  type        = string
  default     = "latest"
}

variable "eve_image_name" {
  description = "EVE-OS image name.tar.gz."
  type        = string
  default     = "gcp-image"
}

variable "network_tier" {
  description = "Network tier: PREMIUM, FIXED_STANDARD or STANDARD"
  type        = string
  default     = "STANDARD"
}

variable "wait_time" {
  description = "Wait time before creating GCP image."
  type        = string
  default     = "12m"
}