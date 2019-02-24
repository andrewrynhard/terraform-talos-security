variable "talos_target" {
  description = "The default target to use"
  type        = "string"
}

variable "talos_context" {
  description = "The name of the osctl context to use when generating the config output."
  type        = "string"
}

variable "talos_validity_period_hours" {
  description = "The duration in hours that all generated certificates are valid for."
  default     = 8760
}
