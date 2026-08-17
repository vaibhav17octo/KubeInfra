# IAM role + instance profile for Kubernetes nodes.
# Named "node" (not "master") because worker nodes will reuse the same
# role/profile later — there is nothing control-plane-specific in it.

resource "aws_iam_role" "node" {
  name = "${var.cluster_name}-node"

  # Allow EC2 instances to assume this role via an instance profile.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Enables SSM Session Manager shell access — no SSH keys or bastion needed;
# Ubuntu AMIs ship the SSM agent preinstalled (as a snap), and NAT egress
# lets it reach the regional SSM endpoints.
resource "aws_iam_role_policy_attachment" "node_ssm" {
  role       = aws_iam_role.node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "node" {
  name = "${var.cluster_name}-node"
  role = aws_iam_role.node.name
}
