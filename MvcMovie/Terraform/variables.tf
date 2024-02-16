variable "Location" {
    type        = string
    default     = "WestEurope"  
}

variable "ResourceGroup" {
    type        = string
    default     = "rg-loganalytics-001"   
}

variable "personal_access_token" {
    type        = string
	sensitive   = true
}

variable "sql_admin_password" {
    type      = string
	sensitive = true
}

variable "branch_name" {
	type      = string
}

variable "safe_branch_name" {
    default   = replace(var.branch_name, "[./-]", "-")
}