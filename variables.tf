variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}
variable "ssh_key_path" {
  description = "A local path to the public key that will be used to connect to the VM"
}
variable "admin_username" {
  description = "The Azure virtual machine admin login name"
}
variable "admin_password" {
  description = "The Azure virtual machine admin password"
}

# https://www.perforce.com/manuals/p4sag/Content/P4SAG/install.linux.packages.configure.html"
variable "p4_service_name" {
  default = "perforce"
}

variable "p4_root_directory" {
  default     = "perforce"
  description = "Perforce Server's root directory"
}
variable "p4_username" {
  description = "Perforce super-user login name"
}
variable "p4_password" {
  description = "Perforce super-user password"
}
