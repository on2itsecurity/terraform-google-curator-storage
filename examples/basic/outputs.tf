output "bucket" {
  description = "GCS bucket name"
  value       = module.curator_storage.bucket
}

output "storage_url" {
  description = "Base hostname for S3-compatible access"
  value       = module.curator_storage.storage_url
}
