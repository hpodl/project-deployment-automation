variable "ansible_dir" {
  type    = string
  default = "./"
}

variable "webserver_ips" {
  type = list(string)
}

variable "pubkey_path" {
  type = string
}