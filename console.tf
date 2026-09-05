variable "test_list" {
  type    = list(string)
  default = ["dev", "staging", "prod"]
}

variable "test_map" {
  type = map(string)
  default = {
    admin = "john"
    user  = "alex"
  }
}

variable "servers" {
  type = map(object({
    desc  = string
    image = string
    cpu   = number
    ram   = number
    disks = list(string)
  }))
  default = {
    production = {
      desc  = "Main Production Server"
      image = "ubuntu-2204-lts"
      cpu   = 4
      ram   = 8
      disks = ["disk1", "disk2"]
    }
  }
}

variable "test" {
  type = list(map(list(string)))
  default = [
    {
      "dev1" = ["localhost", "127.0.0.1"]
    }
  ]
}

