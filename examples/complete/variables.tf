variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "location" {
  description = "GCS bucket location (region or dual-region)"
  type        = string
  default     = "europe-west4"
}

variable "bucket_name" {
  description = "GCS bucket name (globally unique)"
  type        = string
}

variable "labels" {
  description = "Labels applied to all resources"
  type        = map(string)
  default = {
    managedby = "terraform"
  }
}
