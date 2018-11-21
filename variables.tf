variable "talos_identity_ip_addresses" {
  description = "A list of the master node IP addresses."
  type        = "list"
}

variable "talos_context" {
  description = "The name of the osctl context to use when generating the config output."
}

variable "talos_validity_period_hours" {
  description = "The duration in hours that all generated certificates are valid for."
  default     = 8760
}
