# Private DNS for the cluster: a stable name for the API server endpoint so
# kubeconfigs and kubeadm don't depend on the raw (regeneratable) NLB DNS name.

# Private hosted zone: only resolves inside the associated VPC, via the VPC's
# AmazonProvidedDNS resolver. This requires DNS support + hostnames on the VPC,
# which are already enabled in vpc.tf.
resource "aws_route53_zone" "kube_local" {
  name = "kube.local"

  vpc {
    vpc_id = aws_vpc.main.id
  }
}

# Alias A record (free, auto-tracks the NLB's IPs) instead of a CNAME: Route53
# resolves the NLB's addresses at query time, so if the NLB's underlying IPs
# change the record stays correct with no charge per query.
resource "aws_route53_record" "control_plane" {
  zone_id = aws_route53_zone.kube_local.zone_id
  name    = "control-plane.kube.local"
  type    = "A"

  alias {
    name                   = aws_lb.api.dns_name
    zone_id                = aws_lb.api.zone_id
    evaluate_target_health = true
  }
}
