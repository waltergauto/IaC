terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
        source  = "hashicorp/azurerm"
        version = "3.87.0"
    }
  }
}

provider "azurerm" {
    features {
    }
}

resource "azurerm_resource_group" "example" {
    name      = "example-resource-group"
    location  = "West Europe"
}

resource "azurerm_resource_group" "rg2" {
  name = "rg2"
  location = "West Europe"
  tags = {
    dependency = azurerm_resource_group.example.name
  }
}

resource "azurerm_resource_group" "rg3" {
  name = "rg3"
  location = "West Europe"
  depends_on = [
    azurerm_resource_group.rg2
  ]
}

output "output-example-id" {
  value       = azurerm_resource_group.example.id
}

output "output-example-name" {
  value       = azurerm_resource_group.example.name
}



variable "docker_ports" {
  type = list(object({
    internal = number
    external = number
    protocol = string
  }))
  default = [
    {
      internal = 5000
      external = 4000
      protocol = "tcp"
    }
  ]
}

variable "project_name" {
  type = string
  description = "Nombre del grupo de recursos"
  validation {
    condition = length(var.project_name) > 4
    error_message = "Nombre del grupo de recursos muy corto"
  }
}

resource "azurerm_resource_group" "example-variables" {
  name = "${var.project_name}_main"
  location = "West Europe"
}

resource "azurerm_resource_group" "example-variables2" {
  name = "${var.project_name}_secondary"
  location = "West Europe"
}