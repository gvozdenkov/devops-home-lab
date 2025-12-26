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
  pi_nodes = { for k, v in var.cluster_nodes : k => v if contains(v.tags, "pi") }
}

# Output cluster information
output "cluster_info" {
  description = "Cluster information summary"
  value = {
    pi_nodes = local.pi_nodes
  }
}
