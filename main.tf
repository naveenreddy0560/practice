provider "azurerm" {
  features {}
  subscription_id = "b9bbda86-494f-4197-9327-d3a95336f6c5"
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}
module "vnet" {
  source              = "./modules/vnet"
  vnet_name           = var.vnet_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  depends_on          = [azurerm_resource_group.rg]
}



module "keyvault" {
  source              = "./modules/kv"
  kv_name             = var.kv_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tenant_id           = var.tenant_id
  admin_object_id     = var.admin_object_id
}

module "aks" {
  source                     = "./modules/aks"
  aks_name                   = "aks-cluster"
  resource_group_name        = azurerm_resource_group.rg.name
  location                   = azurerm_resource_group.rg.location
  aks_subnet_id              = module.vnet.aks_subnet_id
  log_analytics_workspace_id = module.monitoring.log_analytics_workspace_id
  environment                = var.environment
}
module "monitoring" {
  source                     = "./modules/monitoring"
  resource_group_name        = azurerm_resource_group.rg.name
  location                   = azurerm_resource_group.rg.location
  log_analytics_workspace_id = module.monitoring.log_analytics_workspace_id

}

