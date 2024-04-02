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
    name = "ext_net"
  }
}

output "hello_world" {
  value = "Hello World"
}
