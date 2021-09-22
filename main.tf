terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.77.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {
    resource_group_name = "tf_rg_blobstore"
    storage_account_name = "terraformstorageaccountr"
    container_name = "tfstate"
    key = "terraform.tfstate"
  }
}

variable "imagebuild" {
  type = string
  description = "Latest Image Build"
}

resource "azurerm_resource_group" "tf_test" {
    name = "tfmainrg"
    location = "southindia"
}

resource "azurerm_container_group" "tfcg_test" {
    name = "weatherapi"
    location = azurerm_resource_group.tf_test.location
    resource_group_name = azurerm_resource_group.tf_test.name
    ip_address_type = "public"
    dns_name_label = "binarythistlewapi"
    os_type = "Linux"
    container {
      name = "weatherapi"
      image = "ravindergupta1985/weatherapi:$(var.imagebuild)"
      cpu = "1"
      memory = "1"
      ports {
          port = "80"
          protocol = "TCP"
      }
    }
}

