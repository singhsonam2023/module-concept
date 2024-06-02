resource "azurerm_network_interface" "networkinterface" {
    for_each = var.linux_vms
  name                = each.value.nic_name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.subnet[each.key].id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "linuxvirtualmachine" {
    for_each = var.linux_vms
  name                = each.value.vmname
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  size                = each.value.size
  admin_username      = data.azurerm_key_vault_secret.keyvaultsecret1.value
   admin_password      = data.azurerm_key_vault_secret.keyvaultsecret2.value
  disable_password_authentication = false
  network_interface_ids = [azurerm_network_interface.networkinterface[each.key].id]
  

   os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}