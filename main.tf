# Service Account
locals {
  service_account_email = var.create_service_account ? google_service_account.this[0].email : var.existing_service_account_email
}

resource "google_service_account" "this" {
  count        = var.create_service_account ? 1 : 0
  account_id   = var.service_account_id
  display_name = var.service_account_display_name
  project      = var.project_id
}

# GCS Bucket
resource "google_storage_bucket" "this" {
  name          = var.bucket_name
  location      = var.location
  project       = var.project_id
  storage_class = var.storage_class
  force_destroy = var.force_destroy

  uniform_bucket_level_access = var.uniform_bucket_level_access

  public_access_prevention = var.allow_public_access ? "inherited" : "enforced"

  # Disable object versioning - every file written by Curator is unique except
  # the index file, and versioning prevents immediate re-creation of deleted objects
  versioning {
    enabled = false
  }

  # Retention policy
  dynamic "retention_policy" {
    for_each = var.retention_period_days > 0 ? [1] : []
    content {
      retention_period = var.retention_period_days * 86400
    }
  }

  # CORS configuration
  dynamic "cors" {
    for_each = var.enable_cors ? [1] : []
    content {
      origin          = var.cors_allowed_origins
      method          = ["GET", "HEAD", "PUT", "POST", "DELETE"]
      response_header = ["*"]
      max_age_seconds = var.cors_max_age_seconds
    }
  }

  # Lifecycle rules - transition to NEARLINE
  dynamic "lifecycle_rule" {
    for_each = var.enable_object_lifecycle && var.transition_to_nearline_days > 0 ? [1] : []
    content {
      action {
        type          = "SetStorageClass"
        storage_class = "NEARLINE"
      }
      condition {
        age = var.transition_to_nearline_days
      }
    }
  }

  # Lifecycle rules - transition to COLDLINE
  dynamic "lifecycle_rule" {
    for_each = var.enable_object_lifecycle && var.transition_to_coldline_days > 0 ? [1] : []
    content {
      action {
        type          = "SetStorageClass"
        storage_class = "COLDLINE"
      }
      condition {
        age = var.transition_to_coldline_days
      }
    }
  }

  # Lifecycle rules - object expiration
  dynamic "lifecycle_rule" {
    for_each = var.enable_object_lifecycle && var.expiration_days > 0 ? [1] : []
    content {
      action {
        type = "Delete"
      }
      condition {
        age = var.expiration_days
      }
    }
  }

  labels = var.labels
}

# IAM - grant the service account Object Admin on the bucket
resource "google_storage_bucket_iam_member" "this" {
  bucket = google_storage_bucket.this.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${local.service_account_email}"
}

# HMAC key for S3-compatible access
resource "google_storage_hmac_key" "this" {
  service_account_email = local.service_account_email
  project               = var.project_id
}
