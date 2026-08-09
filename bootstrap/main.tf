# State bucket for the root KubeInfra configuration.
#
# Chicken-and-egg: the S3 backend needs this bucket to exist before
# `terraform init` can run in the root config, so this bootstrap config
# is applied once with LOCAL state. No DynamoDB table is needed —
# Terraform >= 1.10 locks natively via an S3 lockfile (use_lockfile).

resource "aws_s3_bucket" "tfstate" {
  bucket = "kubeinfra-tfstate-${var.bucket_suffix}"

  # The state bucket must never be destroyed by accident — losing it
  # means losing the cluster's source of truth.
  lifecycle {
    prevent_destroy = true
  }
}

# Versioning lets us recover previous state versions after a bad write.
resource "aws_s3_bucket_versioning" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# State files contain secrets (resource attributes, sometimes credentials);
# block every form of public access.
resource "aws_s3_bucket_public_access_block" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
