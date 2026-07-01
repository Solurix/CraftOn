variable "project_id" {
  type        = string
  description = "GCP project ID."
}

variable "bucket_name" {
  type        = string
  description = "Globally-unique bucket name for uploads."
}

variable "location" {
  type        = string
  description = "Bucket location."
  default     = "asia-northeast1"
}

variable "uploads_retention_days" {
  type        = number
  description = "Days to retain uploaded documents before lifecycle deletion. Tune per legal guidance."
  default     = 365
}

variable "cors_origins" {
  type        = list(string)
  description = "Web origins allowed to PUT/GET directly to the bucket via signed URLs (browser uploads). Empty disables CORS."
  default     = []
}

variable "writer_service_account" {
  type        = string
  description = "Service account granted object read/write on the bucket (the identity that signs the v4 URLs). null to skip."
  default     = null
}
