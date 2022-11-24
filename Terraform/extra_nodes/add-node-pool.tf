provider "oci" {
  region = var.region
}


data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_id
}

locals {
  # Gather a list of availability domains for use in configuring placement_configs
  azs = data.oci_identity_availability_domains.ads.availability_domains[*].name
}

data "oci_core_images" "latest_image" {
  compartment_id = var.compartment_id
  operating_system = "Oracle Linux"
  operating_system_version = "8"
  filter {
    name   = "display_name"
    values = ["^.*aarch64-.*$"]
    regex = true
  }
}

resource "oci_containerengine_node_pool" "k8s_node_pool" {
  cluster_id         = var.oke_cluster_id
  compartment_id     = var.compartment_id
  kubernetes_version = "v1.24.1"
  name               = "extra-node-pool"
  node_config_details {
    dynamic placement_configs {
      for_each = local.azs
      content {
        availability_domain = placement_configs.value
        subnet_id           = var.extra_node_pool_subnet
      }
    }
    size = 2

  }
  node_shape = "VM.Standard.A1.Flex"

  node_shape_config {
    memory_in_gbs = 16
    ocpus         = 2
  }

  node_source_details {
    image_id    = data.oci_core_images.latest_image.images.0.id
    source_type = "image"
  }

  initial_node_labels {
    key   = "name"
    value = "extra_workload"
  }

  ssh_public_key = var.ssh_public_key
}
