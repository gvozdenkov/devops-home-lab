terraform {
  required_version = ">= 1.13"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
    template = {
      source  = "hashicorp/template"
      version = "~> 2.2"
    }
  }
}

# Local values for templates
locals {
  pi_nodes = { for k, v in var.cluster_nodes : k => v if contains(v.services, "pi") }
}

# Output cluster information
output "cluster_info" {
  description = "Cluster information summary"
  value = {
    total_nodes = length(var.cluster_nodes)
    controllers = { for k, v in var.cluster_nodes : k => v if v.role == "controller" }
    workers     = { for k, v in var.cluster_nodes : k => v if v.role == "worker" }
    ip_range    = [for node in var.cluster_nodes : node.static_ip]
  }
}

output "pi_nodes" {
  description = "Pi nodes in cluster"
  value       = local.pi_nodes
}
