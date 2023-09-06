variable "resourse_group_name" {
  description = "Resource group name"
  type        = string
  default     = "jf-lab"
}

variable "tags" {
  description = "Tags for the resources"
  type        = map(string)
  default = {
    environment = "dev"
    owner       = "jf"
  }
}