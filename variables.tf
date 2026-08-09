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

variable "vpc_cidr" {
  description = "CIDR block for the cluster VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet."
  type        = string
  default     = "10.0.0.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet."
  type        = string
  default     = "10.0.1.0/24"
}

variable "az_index" {
  description = "Index into the region's available AZ list for subnet placement."
  type        = number
  default     = 0
}
