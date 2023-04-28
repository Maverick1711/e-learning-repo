# Create route 53 record for the domain
resource "aws_route53_zone" "elearning_hosted_zone" {
  name = var.domain_name
}


resource "aws_route53_record" "domain_record" {
  zone_id = aws_route53_zone.elearning_hosted_zone.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = var.alb-hostname
    zone_id                = var.alb-zone_id
    evaluate_target_health = true
  }
}