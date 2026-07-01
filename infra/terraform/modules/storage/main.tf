# Cloud Storage bucket for uploaded documents/images (IDs, residence cards, job photos).
# Access is via signed URLs from the API; the bucket is private. Encrypted at rest.
# Retention/lifecycle keeps sensitive docs only as long as needed
# (see ../../../../docs/08-compliance-legal.md).

resource "google_storage_bucket" "uploads" {
  name                        = var.bucket_name
  project                     = var.project_id
  location                    = var.location
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"

  versioning {
    enabled = true
  }

  # TODO: tune retention for ID documents per legal guidance. Example lifecycle:
  lifecycle_rule {
    condition {
      age = var.uploads_retention_days
    }
    action {
      type = "Delete"
    }
  }

  # Allow the browser to PUT (upload) and GET (display) objects directly via the
  # signed URLs the API mints. Without this, cross-origin uploads are blocked.
  dynamic "cors" {
    for_each = length(var.cors_origins) > 0 ? [1] : []
    content {
      origin          = var.cors_origins
      method          = ["GET", "PUT", "HEAD"]
      response_header = ["Content-Type"]
      max_age_seconds = 3600
    }
  }
}

# The identity that signs v4 URLs also needs object read/write on the bucket:
# a signed URL grants the operation as this service account.
resource "google_storage_bucket_iam_member" "writer" {
  count  = var.writer_service_account == null ? 0 : 1
  bucket = google_storage_bucket.uploads.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${var.writer_service_account}"
}
