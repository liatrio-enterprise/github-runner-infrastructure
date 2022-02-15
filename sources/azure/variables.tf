variable "dns_zone_name" {
  type        = string
  description = "Existing DNS zone to create CNAME record in"
}

variable "dns_zone_resource_group" {
  type        = string
  description = "Resource group holding the base DNS zone"
}

variable "cname_target_value" {
  type        = string
  description = "DNS record to create CNAME for"
}

variable "webhook_domain" {
  type        = string
  description = "DNS record to create as CNAME"
}