# request public certificates from the amazon certificate manager.
resource "aws_acm_certificate" "elearning_acm_cert" {
  domain_name       = "${var.domain_name}"
  subject_alternative_names = ["*.${var.domain_name}"]
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}


# create a record set in route 53 for domain validatation
resource "aws_route53_record" "elearning_cert_dns" {
  allow_overwrite = true
  name =  tolist(aws_acm_certificate.elearning_acm_cert.domain_validation_options)[0].resource_record_name
  records = [tolist(aws_acm_certificate.elearning_acm_cert.domain_validation_options)[0].resource_record_value]
  type = tolist(aws_acm_certificate.elearning_acm_cert.domain_validation_options)[0].resource_record_type
  zone_id = var.aws_route53_zone_id

  ttl = 60
}

resource "aws_acm_certificate_validation" "elearning_cert_validate" {
  certificate_arn = aws_acm_certificate.elearning_acm_cert.arn
  validation_record_fqdns = [aws_route53_record.elearning_cert_dns.fqdn]
}