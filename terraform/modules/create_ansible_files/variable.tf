variable "ansible_dir" {
  type    = string
  default = "../ansible"
}

variable "webserver_ips" {
  type = list(string)
}

variable "private_key_path" {
  type = string
}

variable "db_user" {
  type = string
}

variable "db_passwd" {
  type = string
}

variable "db_url" {
  type = string
}