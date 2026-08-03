terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# 1. Resource Group Module
module "resource_group" {
  source      = "./modules/resource_group"
  name        = var.rg_name
  location    = var.location
  environment = var.environment
}

# 2. Azure Container Registry
module "acr" {
  source              = "./modules/acr"
  acr_name            = var.acr_name
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  environment         = var.environment
}

# 3. Azure Kubernetes Service
module "aks" {
  source              = "./modules/aks"
  aks_cluster_name    = var.aks_name
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  node_count          = 2
  acr_id              = module.acr.id
  environment         = var.environment
}

# 4. Jenkins VM Module
module "jenkins_vm" {
  source              = "./modules/jenkins_vm"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  environment         = var.environment
  vm_size             = "Standard_D2s_v3"
  ssh_public_key      = var.ssh_public_key
}