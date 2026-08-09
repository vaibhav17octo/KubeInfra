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

variable "master_instance_type" {
  description = "EC2 instance type for control-plane nodes. kubeadm requires >= 2 vCPU / 2 GiB; sized generously for development."
  type        = string
  default     = "t3.large"
}

variable "master_key_name" {
  description = "EC2 key pair name for SSH access to control-plane nodes. Null to launch without one."
  type        = string
  default     = null
}
