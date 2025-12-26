variable "cluster_nodes" {
  description = "Home Lab cluster nodes configuration"
  type = map(object({
    mac_address = string
    static_ip   = string
    hostname    = string
    role        = string
    os_version  = string
    os_name     = string
    tags        = list(string)
  }))
  default = {
    "pi5" = {
      mac_address = "2c:cf:67:f0:5e:8e"
      static_ip   = "192.168.88.5/24"
      hostname    = "pi5"
      role        = ""
      os_version  = "24.04.3"
      os_name     = "ubuntu-24.04.3-preinstalled-server-arm64+raspi"
      tags        = ["pi"]
    },
    "pi3" = {
      mac_address = "b8:27:eb:ef:91:bc"
      static_ip   = "192.168.88.3/24"
      hostname    = "pi3"
      role        = ""
      os_version  = "24.04.3"
      os_name     = "ubuntu-24.04.3-preinstalled-server-arm64+raspi"
      tags        = ["pi"]
    },
  }
}

variable "cluster_config" {
  description = "Global cluster configuration"
  type = object({
    domain          = string
    gateway         = string
    dns_servers     = list(string)
    timezone        = string
    ssh_public_keys = list(string)
  })
  default = {
    domain      = "homelab.local"
    gateway     = "192.168.88.1"
    dns_servers = ["192.168.88.1"]
    timezone    = "UTC"
    ssh_public_keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO1y75bxiLzetHQthElV+4cj3G6ZSf5aHrDkIVNd+dSz ansible home lab eurocom",
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKafBr+1LWBjzhg7AZ9vFtbuUmOoB0wajUZm19f/4/hJ bigbox ansible homelab",
    ]
  }
}
