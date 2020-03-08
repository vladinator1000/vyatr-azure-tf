variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}
variable "ssh_key_path" {
  description = "A local path to the public key that will be used to connect to the VM"
}
variable "admin_username" {}
variable "admin_password" {}
