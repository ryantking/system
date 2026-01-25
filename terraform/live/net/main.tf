module "lan" {
  source = "../../modules/unifi-network"

  name          = "LAN"
  purpose       = "corporate"
  subnet        = "192.168.10.0/24"
  vlan_id       = 10
  dhcp_enabled  = true
  dhcp_start    = "192.168.10.100"
  dhcp_stop     = "192.168.10.200"
  multicast_dns = true

  wifi = {
    name            = "rk-lan"
    passphrase      = var.lan_wifi_password
    security        = "wpapsk"
    wpa3_support    = true
    wpa3_transition = true
    pmf_mode        = "optional"
  }
}

module "lab" {
  source = "../../modules/unifi-network"

  name          = "Lab"
  purpose       = "corporate"
  subnet        = "192.168.20.0/24"
  vlan_id       = 20
  dhcp_enabled  = true
  dhcp_start    = "192.168.20.100"
  dhcp_stop     = "192.168.20.200"
  multicast_dns = true
}

module "iot" {
  source = "../../modules/unifi-network"

  name          = "IoT"
  purpose       = "corporate"
  subnet        = "192.168.30.0/24"
  vlan_id       = 30
  dhcp_enabled  = true
  dhcp_start    = "192.168.30.100"
  dhcp_stop     = "192.168.30.200"
  multicast_dns = true

  wifi = {
    name            = "rk-iot"
    passphrase      = var.iot_wifi_password
    security        = "wpapsk"
    wpa3_support    = false
    wpa3_transition = false
    pmf_mode        = "disabled"
  }
}

module "guest" {
  source = "../../modules/unifi-network"

  name          = "Guest"
  purpose       = "corporate"
  subnet        = "192.168.40.0/24"
  vlan_id       = 40
  dhcp_enabled  = true
  dhcp_start    = "192.168.40.100"
  dhcp_stop     = "192.168.40.200"
  multicast_dns = true

  wifi = {
    name            = "rk-guest"
    passphrase      = var.guest_wifi_password
    security        = "wpapsk"
    wpa3_support    = true
    wpa3_transition = true
    pmf_mode        = "optional"
    is_guest        = true
  }
}
