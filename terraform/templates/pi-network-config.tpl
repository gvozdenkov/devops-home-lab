version: 2
wifis:
  renderer: networkd
  wlan0:
    dhcp4: true
    optional: true
    access-points:
      "${wifi_access_point}":
        password: "${wifi_password}"
