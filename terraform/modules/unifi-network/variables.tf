variable "name" {
  type = string
}

variable "purpose" {
  type = string
}

variable "subnet" {
  type = string
}

variable "vlan_id" {
  type = number
}

variable "dhcp_enabled" {
  type = bool
}

variable "dhcp_start" {
  type = string
}

variable "dhcp_stop" {
  type = string
}

variable "multicast_dns" {
  type = bool
}

variable "wifi" {
  type = object({
    name       = string
    passphrase = string
    security   = string
    wpa3_support    = bool
    wpa3_transition = bool
    pmf_mode        = string
    is_guest        = optional(bool, false)
  })
  default = null
}