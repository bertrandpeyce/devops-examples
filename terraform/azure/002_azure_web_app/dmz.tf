
resource "azurerm_public_ip" "dmz_landing" {
  name                = "${var.dmz_landing_vm_name}-pip"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "dmz_landing" {
  name                = "${var.dmz_landing_vm_name}-nic"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "${var.dmz_landing_vm_name}-ipconfig"
    subnet_id                     = azurerm_subnet.dmz.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.dmz_landing.id
  }


  depends_on = [azurerm_subnet.dmz]
}

resource "random_password" "dmz_landing_vm_admin_password" {
  length  = 16
  special = true
}

resource "azurerm_key_vault_secret" "dmz_landing_vm_admin_password" {
  name         = "dmz-landing-vm-admin-password"
  value        = random_password.dmz_landing_vm_admin_password.result
  key_vault_id = data.azurerm_key_vault.key_vault.id
}

resource "tls_private_key" "dmz_landing_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "azurerm_key_vault_secret" "dmz_admin_ssh_private_key" {
  name         = "dmz-landing-vm-ssh-private-key"
  value        = tls_private_key.dmz_landing_ssh_key.private_key_openssh
  key_vault_id = data.azurerm_key_vault.key_vault.id
}

resource "azurerm_key_vault_secret" "dmz_admin_ssh_public_key" {
  name         = "dmz-landing-vm-ssh-public-key"
  value        = tls_private_key.dmz_landing_ssh_key.public_key_openssh
  key_vault_id = data.azurerm_key_vault.key_vault.id
}

resource "azurerm_linux_virtual_machine" "dmz_landing_vm" {
  name                  = var.dmz_landing_vm_name
  resource_group_name   = data.azurerm_resource_group.rg.name
  location              = data.azurerm_resource_group.rg.location
  size                  = var.dmz_landing_vm_size
  admin_username        = var.dmz_landing_vm_admin_username
  admin_password        = random_password.dmz_landing_vm_admin_password.result
  network_interface_ids = [azurerm_network_interface.dmz_landing.id]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
  admin_ssh_key {
    username   = var.dmz_landing_vm_admin_username
    public_key = azurerm_key_vault_secret.dmz_admin_ssh_public_key.value
  }
  #custom_data = file(var.custom_data_file)
}

resource "azurerm_network_security_group" "dmz_landing_nic_nsg" {
  name                = "${var.dmz_landing_vm_name}-nsg"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_network_security_rule" "dmz_landing_nsg_authorize_ssh" {
  name                        = "AllowSshFromAuthorizedIPs"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefixes     = var.dmz_landing_authorized_ip_addresses
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.dmz_landing_nic_nsg.name
  resource_group_name         = data.azurerm_resource_group.rg.name
}

resource "azurerm_network_security_rule" "dmz_landing_nsg_block_internet_access" {
  name                        = "BlockInternetAccess"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "Internet"
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.dmz_landing_nic_nsg.name
  resource_group_name         = data.azurerm_resource_group.rg.name
}

resource "azurerm_network_security_rule" "dmz_landing_nsg_allow_virtual_network_access" {
  name                        = "AllowVirtualNetworkAccess"
  priority                    = 300
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.dmz_landing_nic_nsg.name
  resource_group_name         = data.azurerm_resource_group.rg.name
}

resource "azurerm_network_interface_security_group_association" "dmz_landing_nic_nsg_association" {
  network_interface_id      = azurerm_network_interface.dmz_landing.id
  network_security_group_id = azurerm_network_security_group.dmz_landing_nic_nsg.id
}
