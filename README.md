# AUXO Curator - GCP Storage Module

Terraform/OpenTofu module for deploying Google Cloud Storage (GCS) for AUXO Curator log ingestion. This module creates a storage bucket with configurable lifecycle policies, a dedicated service account, and S3-compatible HMAC credentials for cross-cloud access.

## Prerequisites

- GCP project with Cloud Storage API enabled
- Authenticated `gcloud` CLI (`gcloud auth application-default login`)
- Terraform >= 1.6.0 or OpenTofu >= 1.6.0

## Usage

```hcl
module "curator_storage" {
  source  = "on2itsecurity/curator-storage/google"
  version = "~> 1.0"

  project_id  = var.project_id
  bucket_name = "mycompany-curator-logs"
}
```

## Requirements

| Name                 | Version  |
| -------------------- | -------- |
| terraform / opentofu | >= 1.6.0 |
| google               | >= 6.0.0 |

## Inputs

| Name                           | Description                                                                 | Type           | Default                             | Required |
| ------------------------------ | --------------------------------------------------------------------------- | -------------- | ----------------------------------- | -------- |
| project_id                     | Google Cloud project ID for all resources                                   | `string`       | n/a                                 | **yes**  |
| bucket_name                    | GCS bucket name (globally unique, 3-63 chars, lowercase alphanumeric)       | `string`       | n/a                                 | **yes**  |
| location                       | GCS bucket location (region or dual-region)                                 | `string`       | `"europe-west4"`                    | no       |
| labels                         | Labels applied to all resources                                             | `map(string)`  | `{}`                                | no       |
| storage_class                  | Storage class (STANDARD, NEARLINE, COLDLINE, ARCHIVE)                       | `string`       | `"STANDARD"`                        | no       |
| force_destroy                  | Allow Terraform to delete non-empty buckets                                 | `bool`         | `false`                             | no       |
| uniform_bucket_level_access    | Enable uniform bucket-level access (recommended)                            | `bool`         | `true`                              | no       |
| allow_public_access            | Allow public access (false enforces public access prevention)               | `bool`         | `false`                             | no       |
| retention_period_days          | Retention policy duration in days (0 disables)                              | `number`       | `0`                                 | no       |
| enable_cors                    | Enable CORS configuration                                                   | `bool`         | `true`                              | no       |
| cors_allowed_origins           | List of allowed origins for CORS                                            | `list(string)` | `["*"]`                             | no       |
| cors_max_age_seconds           | Maximum age in seconds for CORS preflight responses                         | `number`       | `3600`                              | no       |
| enable_object_lifecycle        | Enable lifecycle management rules                                           | `bool`         | `true`                              | no       |
| transition_to_nearline_days    | Days before transitioning to NEARLINE (0 disables)                          | `number`       | `30`                                | no       |
| transition_to_coldline_days    | Days before transitioning to COLDLINE (0 disables)                          | `number`       | `90`                                | no       |
| expiration_days                | Days before objects are deleted (0 disables)                                | `number`       | `0`                                 | no       |
| create_service_account         | Create a dedicated service account for HMAC credentials                     | `bool`         | `true`                              | no       |
| service_account_id             | Service account ID when creating a new account                              | `string`       | `"curator-gcs-sa"`                  | no       |
| service_account_display_name   | Display name for the new service account                                    | `string`       | `"AUXO Curator GCS Service Account"`| no       |
| existing_service_account_email | Email of an existing service account (when create_service_account = false)  | `string`       | `""`                                | no       |

## Outputs

| Name                  | Description                                     |
| --------------------- | ----------------------------------------------- |
| storage_url           | Base hostname for S3-compatible access           |
| access_key_id         | HMAC access ID for S3-compatible authentication  |
| secret_access_key     | HMAC secret key (sensitive)                      |
| bucket                | GCS bucket name                                  |
| region                | Bucket location / region                         |
| project_id            | GCP project ID                                   |
| bucket_id             | ID of the GCS bucket                             |
| service_account_email | Service account email used for HMAC credentials  |

## Lifecycle Management

By default, the module enables cost-optimization lifecycle rules:

| Tier     | After Days   | Cost Impact                     |
| -------- | ------------ | ------------------------------- |
| Nearline | 30           | ~50% cheaper storage            |
| Coldline | 90           | ~80% cheaper storage            |
| Delete   | disabled (0) | Set `expiration_days` to enable |

## Design Decisions

- **Object versioning is disabled.** Every file written by Curator is unique except the index file. Versioning prevents immediate re-creation of deleted objects, which causes problems for the solution.

## Examples

- [Basic](https://github.com/on2itsecurity/terraform-google-curator-storage/tree/main/examples/basic) - Minimal deployment with required variables only
- [Complete](https://github.com/on2itsecurity/terraform-google-curator-storage/tree/main/examples/complete) - Full deployment with lifecycle, CORS, and service account options

## License

MIT
