output "domain_name" {    # we have create this before
    value = var.domain_name
}

output "elearning_cert_arn" {  # we have create this before
    value = aws_acm_certificate_validation.acm_certificate_validation.certificate_arn
}