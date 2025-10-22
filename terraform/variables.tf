variable "cluster_nodes" {
  description = "Home Lab cluster nodes configuration"
  type = map(object({
    mac_address = string
    static_ip   = string
    hostname    = string
    role        = string
    os_version  = string
    os_name     = string
    services    = list(string)
  }))
  default = {
    "worker-01" = {
      mac_address = "2c:cf:67:f0:5e:8f"
      static_ip   = "192.168.1.105"
      hostname    = "pi5"
      role        = "worker"
      os_version  = "24.04.3"
      os_name     = "ubuntu-24.04.3-preinstalled-server-arm64+raspi"
      services    = ["k3s-agent", "docker", "pi"]
    },
  }
}

variable "cluster_config" {
  description = "Global cluster configuration"
  type = object({
    domain            = string
    wifi_access_point = string
    wifi_password     = string
    gateway           = string
    dns_servers       = list(string)
    timezone          = string
    ssh_public_keys   = list(string)
  })
  default = {
    domain            = "home-lab-cluster.local"
    wifi_access_point = "arty-home-5g"
    wifi_password     = ""
    gateway           = "192.168.1.1"
    dns_servers       = ["192.168.1.1"]
    timezone          = "UTC"
    ssh_public_keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO1y75bxiLzetHQthElV+4cj3G6ZSf5aHrDkIVNd+dSz ansible home lab eurocom",
    ]
  }
}
