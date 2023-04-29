output "domain_name" {    # we have create this before
    value = var.domain_name
}

output "elearning_cert_arn" {  # we have create this before
    value = aws_acm_certificate.elearning_acm_cert.arn
}