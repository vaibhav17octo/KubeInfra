terraform {
  # >= 1.10 required project-wide: the root config relies on native
  # S3 state locking (use_lockfile), introduced in Terraform 1.10.
  required_version = ">= 1.10"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Project = "KubeInfra"
    }
  }
}
