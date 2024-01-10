resource "azurerm_resource_group" "MvcMovieResourceGroup" {
    name        = var.ResourceGroup
    location    = var.Location
}

resource "azurerm_service_plan" "MvcMovieServicePlan" {
  name                = "colins-mvc-movie-app-service-plan"
  location            = azurerm_resource_group.MvcMovieResourceGroup.location
  resource_group_name = azurerm_resource_group.MvcMovieResourceGroup.name
  sku_name			  = "B1"
  os_type			  = "Linux"
}

resource "azurerm_linux_web_app" "MvcMovieLinuxWebApp" {
  name                = "colins-mvc-movie-linux-web-app"
  location            = azurerm_resource_group.MvcMovieResourceGroup.location
  resource_group_name = azurerm_resource_group.MvcMovieResourceGroup.name
  service_plan_id     = azurerm_service_plan.MvcMovieServicePlan.id
  site_config {
	app_command_line  = "dotnet MvcMovie.dll"
	application_stack {
	  dotnet_version = "6.0"
	}
  }
}

resource "azurerm_mssql_server" "MvcMovieMssqlServer" {
  name                          = "colins-mvc-movie-mssql-server"
  location                      = azurerm_resource_group.MvcMovieResourceGroup.location
  version                       = "12.0"
  administrator_login           = "exampleadmin"
  administrator_login_password  = "Ex@mpleP@ssword123"
  resource_group_name		    = azurerm_resource_group.MvcMovieResourceGroup.name
}

resource "azurerm_mssql_database" "MvcMovieMssqlDatabase" {
  name                = "colins-mvc-movie-mssql-database"
  collation           = "SQL_Latin1_General_CP1_CI_AS"
  server_id			  = azurerm_mssql_server.MvcMovieMssqlServer.id
}

resource "azurerm_mssql_firewall_rule" "appServiceIP" {
  name                = "GitHubActionsIP"
  server_id			  = azurerm_mssql_server.MvcMovieMssqlServer.id
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}
