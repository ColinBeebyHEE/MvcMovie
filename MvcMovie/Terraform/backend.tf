terraform {
  required_providers {
    azurerm = {
        source  = "hashicorp/azurerm"
        version = "=3.0.0"
    }
	github = {
	source = "integrations/github"
	version = "~> 5.0"
	}
	mssql = {
      source = "betr-io/mssql"
      version = "0.3.0"
    }
  }
  backend "azurerm" {
    resource_group_name     = "NE-ELFH-HUB-STOR-RG"
    storage_account_name    = "elfhhubdevstor"
    container_name          = "tfstate"
    key                     = ""
  }
}
provider "azurerm" {
  features {}
}
provider "github" {
  owner = "ColinBeebyHEE"
  token = var.personal_access_token
}
provider "mssql"{
}