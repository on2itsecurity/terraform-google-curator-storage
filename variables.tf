variable "project_id" {
  description = "Google Cloud project ID for all resources"
  type        = string
}

variable "bucket_name" {
  description = "GCS bucket name (globally unique, 3-63 chars, lowercase letters, numbers, hyphens, and dots)"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9._-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "Bucket name must be 3-63 characters, start and end with a letter or number, and contain only lowercase letters, numbers, hyphens, underscores, and dots."
  }
}

variable "location" {
  description = "GCS bucket location (region or dual-region, e.g. europe-west4 or EU)"
  type        = string
  default     = "europe-west4"
}

variable "labels" {
  description = "Labels applied to all resources"
  type        = map(string)
  default     = {}
}

# Storage
variable "storage_class" {
  description = "Storage class for the bucket (STANDARD, NEARLINE, COLDLINE, ARCHIVE)"
  type        = string
  default     = "STANDARD"

  validation {
    condition     = contains(["STANDARD", "MULTI_REGIONAL", "DURABLE_REDUCED_AVAILABILITY", "NEARLINE", "COLDLINE", "ARCHIVE"], upper(var.storage_class))
    error_message = "Must be one of: STANDARD, MULTI_REGIONAL, DURABLE_REDUCED_AVAILABILITY, NEARLINE, COLDLINE, ARCHIVE."
  }
}

variable "force_destroy" {
  description = "Allow Terraform to delete non-empty buckets"
  type        = bool
  default     = false
}

variable "uniform_bucket_level_access" {
  description = "Enable uniform bucket-level access (recommended)"
  type        = bool
  default     = true
}

variable "allow_public_access" {
  description = "Allow public access (set false to enforce public access prevention)"
  type        = bool
  default     = false
}

variable "retention_period_days" {
  description = "Retention policy duration in days (0 disables retention)"
  type        = number
  default     = 0
}

# CORS
variable "enable_cors" {
  description = "Enable CORS configuration"
  type        = bool
  default     = true
}

variable "cors_allowed_origins" {
  description = "List of allowed origins for CORS"
  type        = list(string)
  default     = ["*"]
}

variable "cors_max_age_seconds" {
  description = "Maximum age in seconds for CORS preflight responses"
  type        = number
  default     = 3600
}

# Lifecycle
variable "enable_object_lifecycle" {
  description = "Enable lifecycle management rules for cost optimization"
  type        = bool
  default     = true
}

variable "transition_to_nearline_days" {
  description = "Days before transitioning objects to NEARLINE (0 disables)"
  type        = number
  default     = 30
}

variable "transition_to_coldline_days" {
  description = "Days before transitioning objects to COLDLINE (0 disables)"
  type        = number
  default     = 90
}

variable "expiration_days" {
  description = "Days before objects are deleted (0 disables)"
  type        = number
  default     = 0
}

# Service account
variable "create_service_account" {
  description = "Create a dedicated service account for HMAC credentials"
  type        = bool
  default     = true
}

variable "service_account_id" {
  description = "Service account ID (without domain) when creating a new account"
  type        = string
  default     = "curator-gcs-sa"
}

variable "service_account_display_name" {
  description = "Display name for the new service account"
  type        = string
  default     = "AUXO Curator GCS Service Account"
}

variable "existing_service_account_email" {
  description = "Email of an existing service account to reuse (required when create_service_account = false)"
  type        = string
  default     = ""
}
