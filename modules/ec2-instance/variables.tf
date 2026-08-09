variable "name" {
  description = "Name tag for the instance."
  type        = string
}

variable "ami" {
  description = "AMI ID to launch the instance from."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet to launch the instance in."
  type        = string
}

variable "private_ip" {
  description = "Static private IP address to assign to the instance. Must be within the subnet's CIDR and outside AWS-reserved addresses."
  type        = string

  validation {
    condition     = can(cidrnetmask("${var.private_ip}/32"))
    error_message = "private_ip must be a valid IPv4 address (e.g. 10.0.1.10)."
  }
}

variable "vpc_security_group_ids" {
  description = "List of security group IDs to attach to the instance."
  type        = list(string)
}

variable "key_name" {
  description = "Name of an EC2 key pair for SSH access. Null to launch without one."
  type        = string
  default     = null
}

variable "root_volume_size" {
  description = "Size of the gp3 root volume in GiB."
  type        = number
  default     = 200
}

variable "source_dest_check" {
  description = "Whether to enable source/destination checking. Defaults to false because Kubernetes nodes route pod (CNI) traffic that is not addressed to the node itself."
  type        = bool
  default     = false
}

variable "user_data" {
  description = "User data script to run at first boot. Null for none."
  type        = string
  default     = null
}

variable "extra_tags" {
  description = "Additional tags merged with the Name tag (e.g. Kubernetes cluster-membership tags)."
  type        = map(string)
  default     = {}
}
