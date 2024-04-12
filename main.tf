terraform {
  required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.53.0"
    }
  }
}

variable "auth_url" { }
variable "user_name" { }
variable "tenant_name" { }
variable "password" { }

provider "openstack" {
  auth_url    = var.auth_url
  user_name   = var.user_name
  tenant_name = var.tenant_name
  password    = var.password
  region      = "RegionOne"
  max_retries = 200
}

resource "openstack_compute_instance_v2" "flux-terraform-test" {
  name            = "flux-terraform-test"
  image_name      = "fedora-39"
  flavor_id       = "d09592d3-0d3f-4a98-be10-9e2460fbb67a"
  security_groups = ["default"]

  network {
    uuid = openstack_networking_network_v2.openshift-private.id
  }
}

resource "openstack_networking_network_v2" "openshift-private" {
  name           = "flux-deployment-openshift"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "nodes" {
  name            = "flux-deployment-openshift-nodes"
  cidr            = "10.0.0.0/16"
  ip_version      = 4
  network_id      = openstack_networking_network_v2.openshift-private.id
  dns_nameservers = "10.1.6.1"
}

resource "openstack_networking_router_v2" "openshift-external-router" {
  name                = "flux-deployment-external-router"
  admin_state_up      = true
  external_network_id = "7b490a0c-0f5c-4475-a436-e4bcbecc7f5e"
  external_fixed_ip {
    subnet_id = "16bd151c-10e9-4aa0-87b4-9625e203a942"
    ip_address = "10.1.6.63"
  }
}

resource "openstack_networking_router_interface_v2" "nodes_router_interface" {
  router_id = openstack_networking_router_v2.openshift-external-router.id
  subnet_id = openstack_networking_subnet_v2.nodes.id
}

output "hello_world" {
  value = "Hello World"
}
