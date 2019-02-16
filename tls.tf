locals {
  ca_cert     = "${var.ca_cert == "" ? tls_self_signed_cert.root.cert_pem: var.ca_cert}"
  client_cert = "${var.client_cert == "" ? tls_locally_signed_cert.client_cert.cert_pem: var.client_cert}"
  client_key  = "${var.client_key == "" ?  tls_private_key.client_key.private_key_pem: var.client_key}"
  server_cert = "${var.server_cert == "" ? tls_locally_signed_cert.server_cert.cert_pem: var.server_cert}"
  server_key  = "${var.server_key == "" ? tls_private_key.server_key.private_key_pem: var.server_key}"
}

resource "tls_private_key" "ca_key" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P384"
}

resource "tls_private_key" "client_key" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P384"
}

resource "tls_private_key" "server_key" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P384"
}

resource "tls_self_signed_cert" "root" {
  key_algorithm   = "${tls_private_key.ca_key.algorithm}"
  private_key_pem = "${tls_private_key.ca_key.private_key_pem}"

  validity_period_hours = "${var.tls_validity_period_hours}"
  early_renewal_hours   = "${var.tls_early_renewal_hours}"

  is_ca_certificate = true

  # Reasonable set of uses for a server SSL certificate.
  allowed_uses = [
    "digital_signature",
    "crl_signing",
    "cert_signing",
  ]

  dns_names    = ["${var.tls_dns_names}"]
  ip_addresses = ["${concat(var.tls_ip_addresses, list(module.server.server_ipaddress))}"]

  subject {
    common_name  = "${var.tls_common_name}"
    organization = "${var.tls_organization}"
  }
}

resource "tls_cert_request" "server_csr" {
  key_algorithm   = "${tls_private_key.server_key.algorithm}"
  private_key_pem = "${tls_private_key.server_key.private_key_pem}"

  dns_names    = ["${var.tls_dns_names}"]
  ip_addresses = ["${concat(var.tls_ip_addresses, list(module.server.server_ipaddress))}"]

  subject {
    common_name  = "${var.tls_common_name}"
    organization = "${var.tls_organization}"
  }
}

resource "tls_locally_signed_cert" "server_cert" {
  cert_request_pem = "${tls_cert_request.server_csr.cert_request_pem}"

  ca_key_algorithm   = "${tls_private_key.ca_key.algorithm}"
  ca_private_key_pem = "${tls_private_key.ca_key.private_key_pem}"
  ca_cert_pem        = "${tls_self_signed_cert.root.cert_pem}"

  validity_period_hours = "${var.tls_validity_period_hours}"
  early_renewal_hours   = "${var.tls_early_renewal_hours}"

  allowed_uses = [
    "digital_signature",
    "key_encipherment",
    "server_auth",
  ]
}

resource "tls_cert_request" "client_csr" {
  key_algorithm   = "${tls_private_key.client_key.algorithm}"
  private_key_pem = "${tls_private_key.client_key.private_key_pem}"

  subject {
    common_name  = "${var.tls_common_name}"
    organization = "${var.tls_organization}"
  }
}

resource "tls_locally_signed_cert" "client_cert" {
  cert_request_pem = "${tls_cert_request.client_csr.cert_request_pem}"

  ca_key_algorithm   = "${tls_private_key.ca_key.algorithm}"
  ca_private_key_pem = "${tls_private_key.ca_key.private_key_pem}"
  ca_cert_pem        = "${tls_self_signed_cert.root.cert_pem}"

  validity_period_hours = "${var.tls_validity_period_hours}"
  early_renewal_hours   = "${var.tls_early_renewal_hours}"

  allowed_uses = [
    "digital_signature",
    "key_encipherment",
    "client_auth",
  ]
}
