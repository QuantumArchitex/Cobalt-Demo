data "aws_elb_hosted_zone_id" "current" {}

resource "aws_route53_record" "tenant_dns" {
  zone_id = var.zone_id
  name    = var.domain
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = data.aws_elb_hosted_zone_id.current.id
    evaluate_target_health = true
  }
}