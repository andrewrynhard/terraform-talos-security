output "kubeadm_token" {
  value = "${format("%s.%s", join("", random_shuffle.kubeadm_token_part_1.result), join("", random_shuffle.kubeadm_token_part_2.result))}"
}

output "kubeadm_certificate_key" {
  value = "${random_string.kubeadm_certificate_key.result}"
}

output "kubernetes_ca_crt" {
  value = "${tls_self_signed_cert.kubernetes_ca.cert_pem}"
}

output "kubernetes_ca_key" {
  value = "${tls_private_key.kubernetes_ca.private_key_pem}"
}

output "talos_admin_config" {
  value = "${data.template_file.admin_config.rendered}"
}

output "talos_ca_crt" {
  value = "${tls_self_signed_cert.talos_ca.cert_pem}"
}

output "talos_ca_key" {
  value = "${tls_private_key.talos_ca.private_key_pem}"
}

output "trustd_password" {
  value = "${random_string.trustd_password.result}"
}

output "trustd_username" {
  value = "${random_string.trustd_username.result}"
}
