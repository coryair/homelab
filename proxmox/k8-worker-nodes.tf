# Creates a proxmox_vm_qemu entity named blog_demo_test
resource "proxmox_vm_qemu" "worker_nodes" {
  count       = 1
  name        = "worker-node-${count.index}"
  target_node = var.proxmox_host
  memory      = 4096
  scsihw      = "virtio-scsi-single"
  agent       = 1

  cpu {
    cores   = 2
    sockets = 1
    type    = "host"
  }

  disks {
    ide {
      ide2 {
        cdrom {
          iso = "pve-storage:iso/metal-amd64.iso"
        }
      }
    }
    scsi {
      scsi0 {
        disk {
          size    = "32G"
          storage = "local-lvm"
        }
      }
    }
  }

  network {
    id     = 0
    model  = "virtio"
    bridge = var.nic_name
  }

  lifecycle {
    ignore_changes = [
      network,
      tags
    ]
  }
}
