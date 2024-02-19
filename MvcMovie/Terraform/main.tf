resource "azurerm_resource_group" "MvcMovieResourceGroup" {
    name        = var.ResourceGroup
    location    = var.Location
}

resource "azurerm_service_plan" "MvcMovieServicePlan" {
  name                = "colins-mvc-movie-app-service-plan-${var.branch_name}"
  location            = azurerm_resource_group.MvcMovieResourceGroup.location
  resource_group_name = azurerm_resource_group.MvcMovieResourceGroup.name
  sku_name			  = "B1"
  os_type			  = "Linux"
}

resource "azurerm_linux_web_app" "MvcMovieLinuxWebApp" {
  name                = "colins-mvc-movie-app-${var.branch_name}"
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
  name                          = "colins-mvc-movie-mssql-server-${var.branch_name}"
  location                      = azurerm_resource_group.MvcMovieResourceGroup.location
  version                       = "12.0"
  administrator_login           = "exampleadmin"
  administrator_login_password  = var.sql_admin_password
  resource_group_name		    = azurerm_resource_group.MvcMovieResourceGroup.name
}

resource "azurerm_mssql_database" "MvcMovieMssqlDatabase" {
  name                = "colins-mvc-movie-mssql-database-${var.branch_name}"
  collation           = "SQL_Latin1_General_CP1_CI_AS"
  server_id			  = azurerm_mssql_server.MvcMovieMssqlServer.id
}

resource "mssql_user" "MvcMovieMssqlUser" {
  server {
    host = "${azurerm_mssql_server.MvcMovieMssqlServer.fully_qualified_domain_name}"
    azure_login {
    }
  }
  database            = "${azurerm_mssql_database.MvcMovieMssqlDatabase.name}"
  username            = "MvcMovieUser"
  password            = "TestPassword1234!"
  roles               = ["sysadmin"]
}

resource "github_actions_environment_secret" "MvcMovieConnectionString" {
  repository      = "MvcMovie"
  environment     = "dev"
  secret_name     = "MOVIE_DB_CONNECTION_${replace(var.branch_name, "-", "_")}"
  plaintext_value = "Server=tcp:${azurerm_mssql_server.MvcMovieMssqlServer.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.MvcMovieMssqlDatabase.name};Persist Security Info=False;User ID=exampleadmin;Password=${var.sql_admin_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
}

resource "github_actions_environment_variable" "MvcMovieUrl" {
  repository     = "MvcMovie"
  environment    = "dev"
  variable_name  = "MOVIE_URL_${replace(var.branch_name, "-", "_")}"
  value          = "https://${azurerm_linux_web_app.MvcMovieLinuxWebApp.default_hostname}"
}

resource "github_actions_environment_variable" "MvcMovieConnectionString" {
  repository     = "MvcMovie"
  environment    = "dev"
  variable_name  = "MOVIE_DB_CONNECTION_${replace(var.branch_name, "-", "_")}"
  value          = "Server=tcp:${azurerm_mssql_server.MvcMovieMssqlServer.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.MvcMovieMssqlDatabase.name};Persist Security Info=False;User ID=exampleadmin;Password=${var.sql_admin_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
}

resource "azurerm_mssql_firewall_rule" "appServiceIP" {
  name                = "GitHubActionsIP"
  server_id			  = azurerm_mssql_server.MvcMovieMssqlServer.id
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

resource "azurerm_mssql_firewall_rule" "localIP" {
  name                = "LocalIP"
  server_id			  = azurerm_mssql_server.MvcMovieMssqlServer.id
  start_ip_address    = "86.28.98.175"
  end_ip_address      = "86.28.98.175"
}
