# Generic EC2 instance with a statically assigned private IP.
# Reused for both control-plane and (later) worker nodes.

resource "aws_instance" "this" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.subnet_id

  # Static private IP so cluster members keep stable, predictable addresses
  # (certificates, etcd peers, and kubeconfig endpoints all reference IPs).
  private_ip = var.private_ip

  vpc_security_group_ids = var.vpc_security_group_ids
  key_name               = var.key_name

  # Attaching a profile to a running instance is an in-place update
  # (no replacement). Null means no profile.
  iam_instance_profile = var.iam_instance_profile

  # Kubernetes nodes route pod traffic (CNI), so source/dest check must be off.
  source_dest_check = var.source_dest_check

  user_data = var.user_data

  root_block_device {
    volume_type = "gp3"
    volume_size = var.root_volume_size
    encrypted   = true
  }

  tags = merge(
    { Name = var.name },
    var.extra_tags
  )

  # The AMI data source re-resolves to the newest image on every plan.
  # Without this, a new AMI release would destroy/recreate the instance.
  # OS upgrades are done deliberately (team policy), not via Terraform drift.
  lifecycle {
    ignore_changes = [ami]
  }
}
