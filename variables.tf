variable "region" {
  description = "AWS region for all cluster infrastructure."
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "Name of the Kubernetes cluster; used to name and tag resources."
  type        = string
  default     = "kubeinfra"
}
