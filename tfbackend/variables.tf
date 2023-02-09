variable "root_id" {
  type    = string
  default = "es"
}

variable "root_name" {
  type    = string
  default = "Schillman Group"
}

variable "location" {
  type    = string
  default = "swedencentral"
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "rg_tfbackend" {
  type    = string
  default = "rg-prod-tfstate"
}

variable "management_subscription_id" {
  type = string
}

variable "st_tfbackend" {
  type    = string
  default = "stprodschilltfstate01"
}

variable "containers" {
  type    = list(any)
  default = ["platform", "backend", "governance", "lz-keyvault"]
}

variable "spn_object_id" {
  type    = string
  default = ""
}
