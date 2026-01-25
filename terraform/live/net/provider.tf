provider "unifi" {
  api_url        = "https://udm-01"
  api_key        = var.unifi_api_key
  allow_insecure = true
}
