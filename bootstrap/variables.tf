variable "bucket_suffix" {
  description = "Unique suffix for the state bucket name (e.g. AWS account ID), since S3 bucket names are globally unique."
  type        = string
}

variable "region" {
  description = "AWS region for the state bucket."
  type        = string
  default     = "us-east-1"
}
