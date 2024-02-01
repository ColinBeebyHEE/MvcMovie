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
  }
  backend "azurerm" {
    resource_group_name     = "NE-ELFH-HUB-STOR-RG"
    storage_account_name    = "elfhhubdevstor"
    container_name          = "tfstate"
    key                     = "colin.terraform.tfstate"
  }
}
provider "azurerm" {
  features {}
}
provider "github" {
  token = "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"
}
