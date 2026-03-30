output "storage_url" {
  description = "Base hostname for S3-compatible access"
  value       = "storage.googleapis.com"
}

output "access_key_id" {
  description = "HMAC access ID for S3-compatible authentication"
  value       = google_storage_hmac_key.this.access_id
}

output "secret_access_key" {
  description = "HMAC secret key (sensitive, only shown once)"
  value       = google_storage_hmac_key.this.secret
  sensitive   = true
}

output "bucket" {
  description = "GCS bucket name"
  value       = google_storage_bucket.this.name
}

output "region" {
  description = "Bucket location / region"
  value       = google_storage_bucket.this.location
}

output "project_id" {
  description = "GCP project ID"
  value       = var.project_id
}

output "bucket_id" {
  description = "ID of the GCS bucket"
  value       = google_storage_bucket.this.id
}

output "service_account_email" {
  description = "Service account email used for HMAC credentials"
  value       = local.service_account_email
}
