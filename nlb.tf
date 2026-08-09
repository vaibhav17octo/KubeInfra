# Network Load Balancer fronting the Kubernetes API server (port 6443).
# This is the HA control-plane endpoint: kubeadm's controlPlaneEndpoint and
# kubeconfigs will point at its DNS name rather than any single master.

resource "aws_lb" "api" {
  # NLB names are limited to 32 characters, so keep the suffix short.
  name               = "${var.cluster_name}-api"
  load_balancer_type = "network"

  # Internal: the masters live in the private subnet and all clients (nodes,
  # kubectl from within the VPC) are intra-VPC. Flip to internet-facing later
  # if kubectl access from outside the VPC is ever needed.
  internal = true
  subnets  = [aws_subnet.private.id]

  # Harmless with a single subnet today, but the correct setting once the
  # cluster spans more AZs: masters in any AZ stay reachable from any zone.
  enable_cross_zone_load_balancing = true

  tags = {
    Name = "${var.cluster_name}-api"
  }
}

resource "aws_lb_target_group" "api" {
  name        = "${var.cluster_name}-api"
  port     = 6443
  protocol = "TCP"
  vpc_id   = aws_vpc.main.id

  # IP targets instead of instance targets: with instance targets an NLB
  # always preserves the client source IP, so a master connecting to the
  # NLB and getting routed back to ITSELF sees its own IP as the source and
  # the TCP handshake hangs (hairpin/loopback limitation). Masters will talk
  # to the API through this NLB constantly, so use IP targets and disable
  # client IP preservation to sidestep it.
  target_type = "ip"

  # Off by default for instance targets but must be explicit for IP targets
  # to avoid the hairpin problem described above.
  preserve_client_ip = false

  # A plain TCP check on the traffic port is enough until the API server is
  # actually running; an HTTPS /healthz check can replace it later.
  health_check {
    protocol            = "TCP"
    port                = "traffic-port"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    interval            = 10
  }

  tags = {
    Name = "${var.cluster_name}-api"
  }
}

# Register each control-plane node by its static private IP (each.value),
# matching the target group's "ip" target type.
resource "aws_lb_target_group_attachment" "api" {
  for_each = local.masters

  target_group_arn = aws_lb_target_group.api.arn
  target_id        = each.value
  port             = 6443
}

resource "aws_lb_listener" "api" {
  load_balancer_arn = aws_lb.api.arn
  port              = 6443
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api.arn
  }
}
