variable "private_key_path" {
  description = "path where the newly generated key pair will be saved"
  type        = string
  default     = "./key"
  sensitive   = true
}

variable "db_user" {
  type      = string
  sensitive = true
}

variable "db_passwd" {
  type      = string
  sensitive = true
}
