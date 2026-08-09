# Kubernetes control-plane ("master") nodes: 3 instances with static private
# IPs in the private subnet, forming an HA kubeadm control plane.

# Latest Amazon Linux 2023 AMI (prior team decision for node OS). Looked up
# directly rather than via the SSM /aws/service parameter, which is
# access-restricted in some accounts.
data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-x86_64"]
  }
}

locals {
  # AWS reserves the first 4 host IPs in each subnet (plus the broadcast
  # address), so starting at .10 is safely outside the reserved range.
  masters = {
    "Master-1" = "10.0.1.10"
    "Master-2" = "10.0.1.11"
    "Master-3" = "10.0.1.12"
  }
}

module "master" {
  source   = "./modules/ec2-instance"
  for_each = local.masters

  name          = each.key
  ami           = data.aws_ami.al2023.id
  instance_type = var.master_instance_type
  subnet_id     = aws_subnet.private.id
  private_ip    = each.value
  key_name      = var.master_key_name

  # SSM Session Manager access (see iam.tf).
  iam_instance_profile = aws_iam_instance_profile.node.name

  vpc_security_group_ids = [aws_security_group.masters.id]
}

resource "aws_security_group" "masters" {
  name        = "${var.cluster_name}-masters"
  description = "Control-plane node traffic."
  vpc_id      = aws_vpc.main.id

  # Broad intra-VPC rule for now; will be tightened to the specific
  # Kubernetes ports (6443, 2379-2380, 10250, ...) later.
  ingress {
    description = "All traffic from within the VPC."
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    description = "All outbound traffic."
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.cluster_name}-masters"
  }
}
