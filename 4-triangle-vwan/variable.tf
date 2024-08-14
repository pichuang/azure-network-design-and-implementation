variable "lab-rg" {
  description = "Resource Group for this lab"
  type        = string
  default     = "rg-triangle-vwan"
}

variable "lab-location" {
  description = "Location for this lab"
  type        = string
  default     = "southeastasia"
}

variable "vhub-1-region" {
  description = "Region for vhub-1"
  type        = string
  default     = "southeastasia"
}

variable "vhub-2-region" {
  description = "Region for vhub-2"
  type        = string
  default     = "taiwannorth"
}

variable "vhub-3-region" {
  description = "Region for vhub-3"
  type        = string
  default     = "japaneast"
}

variable "admin_username" {
  description = "Admin username for the VMs"
  type        = string
  default     = "repairman"
}

variable "admin_password" {
  description = "Admin password for the VMs"
  type        = string
  default     = "P@ssw0rd1234!"
}