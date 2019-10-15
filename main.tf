resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-resources"
  location = var.location
}

module "ssh-key" {
  source         = "./modules/ssh-key"
  public_ssh_key = var.public_ssh_key == "" ? "" : var.public_ssh_key
}

module "kubernetes" {
  source                          = "./modules/kubernetes-cluster"
  prefix                          = var.prefix
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location
  admin_username                  = var.admin_username
  admin_public_ssh_key            = var.public_ssh_key == "" ? module.ssh-key.public_ssh_key : var.public_ssh_key
  agents_size                     = var.agents_size
  agents_count                    = var.agents_count
  kubernetes_version              = var.kubernetes_version
  service_principal_client_id     = var.CLIENT_ID
  service_principal_client_secret = var.CLIENT_SECRET
  }
  
  #### Terraform Backend State ###
  terraform {
  backend "azurerm" {
    storage_account_name  = "roshazure"
    container_name        = "roshazure"
    key                   = "terraform.tfstate"
  }
}

resource "azurerm_resource_group" "state-demo-secure" {
  name     = "state-demo"
  location = "eastus"
}
