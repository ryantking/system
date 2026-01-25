data "unifi_ap_group" "default" {
  name = "All APs"
}

data "unifi_user_group" "default" {
  name = "Default"
}

resource "unifi_network" "network" {
  name          = var.name
  purpose       = var.purpose
  subnet        = var.subnet
  vlan_id       = var.vlan_id
  dhcp_enabled  = var.dhcp_enabled
  dhcp_start    = var.dhcp_start
  dhcp_stop     = var.dhcp_stop
  multicast_dns = var.multicast_dns
}

resource "unifi_wlan" "wifi" {
  count = var.wifi != null ? 1 : 0

  name       = var.wifi.name
  passphrase = var.wifi.passphrase
  security   = var.wifi.security

  wpa3_support    = var.wifi.wpa3_support
  wpa3_transition = var.wifi.wpa3_transition
  pmf_mode        = var.wifi.pmf_mode
  is_guest        = var.wifi.is_guest

  network_id    = unifi_network.network.id
  ap_group_ids  = [data.unifi_ap_group.default.id]
  user_group_id = data.unifi_user_group.default.id
}
