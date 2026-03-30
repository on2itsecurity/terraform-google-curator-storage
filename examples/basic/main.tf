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
}
