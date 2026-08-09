output "state_bucket_name" {
  description = "Name of the S3 bucket holding remote Terraform state. Use this in the root backend.tf."
  value       = aws_s3_bucket.tfstate.bucket
}
