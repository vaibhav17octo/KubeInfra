# Bootstrap

The root config stores its state in S3, but that bucket has to exist before `terraform init` can run there — a chicken-and-egg problem.
This config breaks the cycle: run it **once** with local state (`terraform init && terraform apply -var bucket_suffix=<your-account-id>`) to create the state bucket.
Its own local `terraform.tfstate` is gitignored; after the one-time apply, all real infra work happens in the repo root.
