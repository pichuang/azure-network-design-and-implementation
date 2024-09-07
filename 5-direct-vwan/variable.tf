variable "lab-rg" {
  description = "Resource Group for this lab"
  type        = string
  default     = "rg-direct-vwan"
}

variable "lab-location" {
  description = "Location for this lab"
  type        = string
  default     = "taiwannorth"
}

variable "vhub-1-region" {
  description = "Region for vhub-1"
  type        = string
  default     = "taiwannorth"
}

variable "vhub-2-region" {
  description = "Region for vhub-2"
  type        = string
  default     = "swedencentral"
}

variable "admin_username" {
  description = "Admin username for the VMs"
  type        = string
  default     = "repairman"
}

variable "admin_password" {
  description = "Admin password for the VMs"
  type        = string
  default     = "m3Pgf5FdQC2N4sjLV7XkBJ"
}