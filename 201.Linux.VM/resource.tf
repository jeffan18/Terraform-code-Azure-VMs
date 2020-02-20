resource "azurerm_resource_group" "projectvm" {
  name = var.resource_group_name
  location = var.location

  tags = {
    environment = var.tag
  }
}

resource "azurerm_virtual_network" "projectvm" {
  name                = var.virtual_network_name
  address_space       = [var.virtual_network_address_prefix]
  location            = var.location
  resource_group_name = azurerm_resource_group.projectvm.name

  tags = {
    environment = var.tag
  }
}

resource "azurerm_subnet" "vmsubnet" {
  name                 = var.subnet_vmpool
  resource_group_name  = azurerm_resource_group.projectvm.name
  virtual_network_name = azurerm_virtual_network.projectvm.name
  address_prefix       = "10.0.2.0/24"
}

resource "azurerm_public_ip" "linuxvm1" {
  name                         = "PublicIP-for-linuxvm-1"
  location                     = azurerm_resource_group.projectvm.location
  resource_group_name          = azurerm_resource_group.projectvm.name
  allocation_method            = "Dynamic"
  tags = {
    environment = var.tag
  }
}

resource "azurerm_network_security_group" "linuxvm1" {
  name                = "NSG-for-linuxvm-1"
  location                     = azurerm_resource_group.projectvm.location
  resource_group_name          = azurerm_resource_group.projectvm.name
  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  tags = {
    environment = var.tag
  }
}

resource "azurerm_network_interface" "linuxvm1" {
  name                        = "NIC-for-linuxvm-1"
  location                     = azurerm_resource_group.projectvm.location
  resource_group_name          = azurerm_resource_group.projectvm.name
  network_security_group_id   = azurerm_network_security_group.linuxvm1.id
  ip_configuration {
    name                          = "NIC-IP-for-linuxvm-1"
    subnet_id                     = azurerm_subnet.vmsubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.linuxvm1.id
  }
  tags = {
    environment = var.tag
  }
}

resource "azurerm_virtual_machine" "linuxvm1" {
  name                  = local.vm1_name
  location                     = azurerm_resource_group.projectvm.location
  resource_group_name          = azurerm_resource_group.projectvm.name
  network_interface_ids = [azurerm_network_interface.linuxvm1.id]
  vm_size               = "Standard_DS1_v2"

  storage_os_disk {
    name              = "OSDisk-for-linuxvm1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04.0-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "fanlinuxvm01"
    admin_username = "elecview"
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/elecview/.ssh/authorized_keys"
      key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAovstHZOqDTjln8Oksv7Hlbcqg4ljPtl5t9ZH3kzdDVlobE76B+PL7h4yTDFevfuFICG1On08XeTC84JNKWSR6/uD1YKfcxNRYBcZTOXglX7yXFYXuCYLZoSiTPzmeGMJQ5UNZu8twnO3Fk6+lkZuA26/UgT+hs29P8AC+BWKDcnaoEwweVxuLF7RRlxt6wymoXnsCIYpmHAMg7h2zX5pOCTkuMRwIQ4S+4m/S/VlOVZqPYFvq936QiSJ68X2eJsSOLcRx2UXVC07q2Diqm/Y0foV1WTP7uzgcX/W9JscRpBquHf9s83g5hhSylltA1vGN3/DJaes1N3sguIJAmLuXQ=="
    }
  }

  tags = {
    environment = var.tag
  }
}

