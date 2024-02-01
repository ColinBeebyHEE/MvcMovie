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
