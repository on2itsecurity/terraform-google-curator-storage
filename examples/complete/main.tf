terraform {
  required_version = ">= 1.6.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.location
}

module "curator_storage" {
  source  = "on2itsecurity/curator-storage/google"
  version = "~> 1.0"

  project_id  = var.project_id
  bucket_name = var.bucket_name
  location    = var.location

  # Storage
  storage_class = "STANDARD"
  force_destroy = false

  # Access
  allow_public_access         = false
  uniform_bucket_level_access = true

  # Retention
  retention_period_days = 0

  # CORS
  enable_cors          = true
  cors_allowed_origins = ["*"]
  cors_max_age_seconds = 3600

  # Lifecycle management
  enable_object_lifecycle     = true
  transition_to_nearline_days = 30
  transition_to_coldline_days = 90
  expiration_days             = 365

  # Service account
  create_service_account       = true
  service_account_id           = "curator-gcs-sa"
  service_account_display_name = "AUXO Curator GCS Service Account"

  labels = var.labels
}
