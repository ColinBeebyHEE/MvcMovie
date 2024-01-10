resource "azurerm_resource_group" "resourcegroups" {
    name        = var.ResourceGroup
    location    = var.Location
}

resource "azurerm_service_plan" "example" {
  name                = "colins-mvc-movie-app-service-plan"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku_name			  = "B1"
  os_type			  = "Linux"
}
