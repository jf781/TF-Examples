variable "rg_name" {
  default = "demo-rg"
}

variable "region" {
  default = "central us"
}

variable "key_vault_name" {
  default = "jf-demo-test-vault"
}

variable "pip_name" {
  default = "demo-pip"
}

variable "laws_name" {
  default = "demo-laws"
}

variable "eh_namespace" {
  default = "demo-ehns"
}

variable "eh_name" {
  default = "demo-eh"
}

variable "key_vault_diag_settings" {
  type = map(string)
  default = {
    name                         = "Demo Diag Settings Name"
    auditEvent                   = "true"
    azurePolicyEvaulationDetails = "true"
    allMetrics                   = "false"
  }
}

variable "tags" {
  type = map(string)
  default = {
    "tag key 1" = "tag value 1"
    "tag key 2" = "tag value 2"
    "tag key 3" = "tag value 3"
  }
}