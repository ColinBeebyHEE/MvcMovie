variable "Location" {
    type        = string
    default     = "WestEurope"  
}

variable "ResourceGroup" {
    type        = string
    default     = "MvcMovieRG"   
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

variable "client_id" {
    type      = string
}

variable "client_secret" {
    type      = string
	sensitive = true
}

variable "tenant_id" {
    type      = string
}
