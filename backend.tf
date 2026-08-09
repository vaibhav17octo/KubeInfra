terraform {
  backend "s3" {
    # Bucket created by bootstrap/ — replace the suffix with the value
    # you passed as bucket_suffix there (e.g. your AWS account ID).
    bucket = "kubeinfra-tfstate-452630323308"
    key    = "kubeinfra/terraform.tfstate"
    region = "us-east-1"

    # Native S3 locking (Terraform >= 1.10): a .tflock object is written
    # next to the state via S3 conditional writes, so concurrent applies
    # are blocked without needing a DynamoDB table.
    use_lockfile = true
    encrypt      = true
  }
}
