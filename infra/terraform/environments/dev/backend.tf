# Remote state in GCS. Create the bucket once (versioned) before `terraform init`.
# TODO: set the bucket name, then uncomment.
#
# terraform {
#   backend "gcs" {
#     bucket = "crafton-dev-500709-tfstate" # create this versioned bucket first (globally unique)
#     prefix = "env/dev"
#   }
# }
