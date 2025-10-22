# Generate script to download os and write it to raspberry pi sd card
# with proper cloud-init config
resource "local_file" "pi_prepare_os" {
  for_each = local.pi_nodes
  filename = "${path.module}/raspberry-pi/${each.value.hostname}-${each.value.role}-prepare-os.sh"

  content = templatefile("${path.module}/templates/pi-prepare-os.tpl", {
    os_version = each.value.os_version
    os_name    = each.value.os_name
    hostname   = each.value.hostname
    role       = each.value.role
  })

  file_permission = "0700"
}

# Generate cloud-init meta-data config file
resource "local_file" "pi_meta_data" {
  for_each = local.pi_nodes
  filename = "${path.module}/raspberry-pi/${each.value.hostname}-${each.value.role}-meta-data"

  content = templatefile("${path.module}/templates/pi-meta-data.tpl", {
    hostname = each.value.hostname
  })

  file_permission = "0600"
}

# Generate cloud-init network-config file
resource "local_file" "pi_network_config" {
  for_each = local.pi_nodes
  filename = "${path.module}/raspberry-pi/${each.value.hostname}-${each.value.role}-network-config"

  content = templatefile("${path.module}/templates/pi-network-config.tpl", {
    wifi_access_point = var.cluster_config.wifi_access_point
    wifi_password     = var.cluster_config.wifi_password
  })

  file_permission = "0600"
}

# Generate cloud-init user-data config file
resource "local_file" "pi_user_data" {
  for_each = local.pi_nodes
  filename = "${path.module}/raspberry-pi/${each.value.hostname}-${each.value.role}-user-data"

  content = templatefile("${path.module}/templates/pi-user-data.tpl", {
    hostname        = each.value.hostname
    ssh_public_keys = var.cluster_config.ssh_public_keys
  })

  file_permission = "0600"
}
