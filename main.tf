resource "tls_private_key" "talos_ca" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P521"
}

resource "tls_self_signed_cert" "talos_ca" {
  key_algorithm   = "ECDSA"
  private_key_pem = "${tls_private_key.talos_ca.private_key_pem}"

  subject {
    common_name  = "Talos CA"
    organization = "Talos"
  }

  is_ca_certificate     = true
  validity_period_hours = "${var.talos_validity_period_hours}"

  allowed_uses = [
    "cert_signing",
    "key_encipherment",
    "digital_signature",
    "server_auth",
    "client_auth",
  ]
}

resource "tls_private_key" "talos_admin" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P521"
}

resource "tls_cert_request" "talos_admin" {
  key_algorithm   = "ECDSA"
  private_key_pem = "${tls_private_key.talos_admin.private_key_pem}"

  ip_addresses = ["127.0.0.1"]

  subject {
    common_name  = "Talos Administrator"
    organization = "Talos"
  }
}

resource "tls_locally_signed_cert" "talos_admin" {
  cert_request_pem   = "${tls_cert_request.talos_admin.cert_request_pem}"
  ca_key_algorithm   = "ECDSA"
  ca_private_key_pem = "${tls_private_key.talos_ca.private_key_pem}"
  ca_cert_pem        = "${tls_self_signed_cert.talos_ca.cert_pem}"

  validity_period_hours = "${var.talos_validity_period_hours}"

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
    "client_auth",
  ]
}

data "template_file" "admin_config" {
  template = <<EOF
context: ${var.talos_context}
contexts:
  ${var.talos_context}:
    target: ${var.talos_target}
    ca: $${talos_ca_crt}
    crt: $${talos_admin_crt}
    key: $${talos_admin_key}
EOF

  vars {
    talos_ca_crt    = "${base64encode(tls_self_signed_cert.talos_ca.cert_pem)}"
    talos_admin_crt = "${base64encode(tls_locally_signed_cert.talos_admin.cert_pem)}"
    talos_admin_key = "${base64encode(tls_private_key.talos_admin.private_key_pem)}"
  }
}

resource "random_string" "trustd_username" {
  length  = 14
  special = true
}

resource "random_string" "trustd_password" {
  length  = 24
  special = true
}

resource "tls_private_key" "kubernetes_ca" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "tls_self_signed_cert" "kubernetes_ca" {
  key_algorithm   = "RSA"
  private_key_pem = "${tls_private_key.kubernetes_ca.private_key_pem}"

  subject {
    common_name  = "Kubernetes CA"
    organization = "Kubernetes"
  }

  is_ca_certificate     = true
  validity_period_hours = "${var.talos_validity_period_hours}"

  allowed_uses = [
    "cert_signing",
    "key_encipherment",
    "digital_signature",
    "server_auth",
    "client_auth",
  ]
}

resource "random_shuffle" "kubeadm_token_part_1" {
  input        = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "a", "b", "c", "d", "e", "f", "g", "h", "i", "t", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
  result_count = 6
}

resource "random_shuffle" "kubeadm_token_part_2" {
  input        = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "a", "b", "c", "d", "e", "f", "g", "h", "i", "t", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
  result_count = 16
}
