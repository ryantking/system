variable "unifi_api_key" {
  type      = string
  sensitive = true
}

variable "lan_wifi_password" {
  type      = string
  sensitive = true
}

variable "lab_wifi_password" {
  type      = string
  sensitive = true
}

variable "iot_wifi_password" {
  type      = string
  sensitive = true
}

variable "guest_wifi_password" {
  type      = string
  sensitive = true
}
