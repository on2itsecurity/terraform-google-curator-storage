variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "location" {
  description = "GCP region for deployment"
  type        = string
  default     = "europe-west4"
}

variable "bucket_name" {
  description = "GCS bucket name (globally unique)"
  type        = string
}
