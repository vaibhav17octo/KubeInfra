# Kubernetes worker nodes: 2 instances with static private IPs in the
# private subnet, joined to the cluster with kubeadm.

locals {
  # Masters occupy .10-.12; workers start at .20 to leave room for
  # additional control-plane nodes.
  workers = {
    "Worker-1" = "10.0.1.20"
    "Worker-2" = "10.0.1.21"
  }
}

module "worker" {
  source   = "./modules/ec2-instance"
  for_each = local.workers

  name          = each.key
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.worker_instance_type
  subnet_id     = aws_subnet.private.id
  private_ip    = each.value
  key_name      = var.worker_key_name

  # SSM Session Manager access (see iam.tf).
  iam_instance_profile = aws_iam_instance_profile.node.name

  # No dedicated worker SG yet: reuse the masters' node SG, which already
  # allows all intra-VPC traffic. Will be split per-role when the rules are
  # tightened to specific Kubernetes ports.
  vpc_security_group_ids = [aws_security_group.masters.id]
}
