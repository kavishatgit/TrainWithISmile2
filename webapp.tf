provider "azurerm" {
  features {
   } 
}
# Define the Resource Group
data "azurerm_resource_group" "ResourceGroup" {
  name     = var.TR_my-resource-group
  # location = var.rg_location
}

# Define the App Service Plan
resource "azurerm_app_service_plan" "AppServicePlan" {
  name                = var.TR_my-app-service-plan
  location            = data.azurerm_resource_group.ResourceGroup.location
  resource_group_name = data.azurerm_resource_group.ResourceGroup.name
  sku {
    tier = "Standard"
    size = "S1"
  }
}
# Define the App Service
resource "azurerm_app_service" "AppService" {
  name                = var.TR_my-app-service
  location            = data.azurerm_resource_group.ResourceGroup.location
  resource_group_name = data.azurerm_resource_group.ResourceGroup.name
  app_service_plan_id = azurerm_app_service_plan.AppServicePlan.id

  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
  }

  app_settings = {
    "SOME_KEY" = "some-value"
  }

  connection_string {
    name  = "Database"
    type  = "SQLServer"
    value = "Server=some-server.mydomain.com;Integrated Security=SSPI"
  }
}