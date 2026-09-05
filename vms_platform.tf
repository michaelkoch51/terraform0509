### Task 6: Optimized Map Variables

variable "vms_resources" {
  type = map(object({
    cores         = number
    memory        = number
    core_fraction = number
    hdd_size      = number
    hdd_type      = string
  }))
  default = {
    web = {
      cores         = 2
      memory        = 1
      core_fraction = 5
      hdd_size      = 10
      hdd_type      = "network-hdd"
    }
    db = {
      cores         = 2
      memory        = 2
      core_fraction = 20
      hdd_size      = 20
      hdd_type      = "network-hdd"
    }
  }
}

variable "vms_metadata" {
  type = map(string)
  default = {
    serial-port-enable = "1"
  }
}

variable "vm_web_image_family" {
  type    = string
  default = "ubuntu-2004-lts"
}

