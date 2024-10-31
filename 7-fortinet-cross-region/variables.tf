variable "enable_telemetry" {
  description = "Enable telemetry"
  type        = bool
  default     = false
}

variable "region-a" {
  description = "Region A"
  type        = string
  default     = "japaneast"
}

variable "region-b" {
  description = "Region B"
  type        = string
  default     = "japaneast"
}

variable "admin_username" {
  description = "Admin user"
  type        = string
  default     = "repairman"
}

variable "admin_password" {
  description = "Admin password"
  type        = string
  default     = "Lyc0r!sRec0il"
}
