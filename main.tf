data "terraform_remote_state" "network" {
  backend = "atlas"

  config = {
    name = "jlinn/azure-vm-network-test"
  }
}

resource "azurerm_virtual_machine" "main" {
  name                  = "${var.prefix}-vm"
  location              = "${data.terraform_remote_state.network.resource_group.location}"
  resource_group_name   = "${data.terraform_remote_state.network.resource_group.name}"
  network_interface_ids = ["${data.terraform_remote_state.network.network_interface_id}"]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
   delete_os_disk_on_termination = true


  # Uncomment this line to delete the data disks automatically when deleting the VM
   delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}

resource "azurerm_network_security_group" "test" {
  name                = "acceptanceTestSecurityGroup1"
  location            = "${data.terraform_remote_state.network.resource_group.location}"
  resource_group_name = "${data.terraform_remote_state.network.resource_group.name}"

  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Production"
  }
}
