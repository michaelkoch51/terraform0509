### Сети и подсети
resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}

resource "yandex_vpc_subnet" "develop" {
  name           = "${var.vpc_name}-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = ["10.0.1.0/24"]
}

# Подсеть в зоне B для базы данных
resource "yandex_vpc_subnet" "develop_b" {
  name           = "${var.vpc_name}-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = ["10.0.2.0/24"]
}

### Источник образа ОС
data "yandex_compute_image" "ubuntu" {
  family = var.vm_web_image_family
}

### ВМ 1: Web (Использует ключ "web")
resource "yandex_compute_instance" "platform" {
  name        = local.web_name
  platform_id = "standard-v1"
  zone        = "ru-central1-a"

  resources {
    cores         = var.vms_resources["web"].cores
    memory        = var.vms_resources["web"].memory
    core_fraction = var.vms_resources["web"].core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = var.vms_resources["web"].hdd_size
      type     = var.vms_resources["web"].hdd_type
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }
  metadata = {
    serial-port-enable = var.vms_metadata["serial-port-enable"]
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }
}

### ВМ 2: Database (Использует ключ "db")
resource "yandex_compute_instance" "db" {
  name        = local.db_name
  platform_id = "standard-v1"
  zone        = "ru-central1-b"

  resources {
    cores         = var.vms_resources["db"].cores
    memory        = var.vms_resources["db"].memory
    core_fraction = var.vms_resources["db"].core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = var.vms_resources["db"].hdd_size
      type     = var.vms_resources["db"].hdd_type
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop_b.id
    nat       = true
  }
  metadata = {
    serial-port-enable = var.vms_metadata["serial-port-enable"]
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }
}

