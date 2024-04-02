terraform {
  required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.53.0"
    }
  }
}

provider "openstack" {
  cloud = "openstack"
}

resource "openstack_compute_instance_v2" "terraform-test" {
  name            = "terraform-test"
  image_name      = "cirros-0.6.2-x86_64-disk"
  flavor_id       = "2"
  security_groups = ["default"]

  network {
    name = "public"    
  }
}

output "hello_world" {
  value = "Hello World"
}
