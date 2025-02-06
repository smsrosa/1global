provider "vsphere" {
  user           = "smrosa@vsphere.lab"
  password       = "2L84aD8!"
  vsphere_server = "vaepvwvc001.lab.local"

  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = "CampoGrande"
}

data "vsphere_compute_cluster" "cluster" {
  name          = "CGVWSHR001-New"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "pool" {
  name          = "1G"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "datastore" {
  name          = "CGSGPST002-000"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = "2009-VMWARE_Service_CG"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = "TPL_1G"
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "vms" {
  count = 3

  name             = "${element(["VM1-nginx", "VM2-app", "VM3-db"], count.index)}"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = 2
  memory   = 2048
  guest_id = "ubuntu64Guest"
  firmware = "efi"

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = "vmxnet3"
  }

  disk {
    label            = "disk0"
    size             = 25
    eagerly_scrub    = false
    thin_provisioned = true
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      linux_options {
        host_name = "${element(["VM1-nginx", "VM2-app", "VM3-db"], count.index)}"
        domain    = "localdomain"
      }

      network_interface {
        ipv4_address = "10.150.190.${count.index + 190}"
        ipv4_netmask = 24
      }

      dns_server_list = ["10.255.9.255"]
      ipv4_gateway = "10.150.190.254"
    }
  }
}
