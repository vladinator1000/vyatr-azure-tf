provider "azurerm" {
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id

  features {}
}

resource "azurerm_resource_group" "vyatr" {
  name     = "vyatr"
  location = "uksouth"
}

variable "prefix" {
  default = "vyatr"
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/25"]
  location            = azurerm_resource_group.vyatr.location
  resource_group_name = azurerm_resource_group.vyatr.name
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.vyatr.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefix       = "10.0.0.0/26"
}

resource "azurerm_public_ip" "perforce_server_ip" {
  name                = "${var.prefix}-perforce-server"
  location            = azurerm_resource_group.vyatr.location
  resource_group_name = azurerm_resource_group.vyatr.name
  allocation_method   = "Static"
}


resource "azurerm_network_interface" "main" {
  name                = "${var.prefix}-nic"
  location            = azurerm_resource_group.vyatr.location
  resource_group_name = azurerm_resource_group.vyatr.name

  ip_configuration {
    name                          = "vyatr-ip-config"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.internal.id
    public_ip_address_id          = azurerm_public_ip.perforce_server_ip.id
  }
}

resource "azurerm_virtual_machine" "main" {
  name                  = "${var.prefix}-vm"
  location              = azurerm_resource_group.vyatr.location
  resource_group_name   = azurerm_resource_group.vyatr.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "vyatr-os-disk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "vyatr-machine"
    admin_username = var.admin_username
    admin_password = var.admin_password
  }
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = file(var.ssh_key_path)
      path     = "/home/${var.admin_username}/.ssh/authorized_keys"
    }
  }
  tags = {
    owner = "Vlady Veselinov"
  }
}
