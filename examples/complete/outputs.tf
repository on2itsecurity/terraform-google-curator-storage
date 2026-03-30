output "bucket" {
  description = "GCS bucket name"
  value       = module.curator_storage.bucket
}

output "storage_url" {
  description = "Base hostname for S3-compatible access"
  value       = module.curator_storage.storage_url
}

output "access_key_id" {
  description = "HMAC access ID"
  value       = module.curator_storage.access_key_id
}

output "region" {
  description = "Bucket location / region"
  value       = module.curator_storage.region
}

output "project_id" {
  description = "GCP project ID"
  value       = module.curator_storage.project_id
}

output "bucket_id" {
  description = "ID of the GCS bucket"
  value       = module.curator_storage.bucket_id
}

output "service_account_email" {
  description = "Service account email used for HMAC credentials"
  value       = module.curator_storage.service_account_email
}
