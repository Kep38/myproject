terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.131.0"
    }
  }
}

resource "yandex_mdb_postgresql_cluster" "db_cluster" {
  name        = "earthquake-db"
  environment = "PRODUCTION"
  network_id  = var.vpc_network_id
  folder_id   = var.folder_id

  config {
    version = "13"
    resources {
      resource_preset_id = "b2.medium"
      disk_size          = 20
      disk_type_id       = "network-ssd"
    }
  }

  host {
    zone      = var.zone
    subnet_id = var.vpc_subnet_id
  }

  maintenance_window {
    type = "ANYTIME"
  }
}

resource "yandex_mdb_postgresql_user" "db_user" {
  cluster_id = yandex_mdb_postgresql_cluster.db_cluster.id
  name       = var.database_user
  password   = var.database_password

  depends_on = [yandex_mdb_postgresql_cluster.db_cluster]
}

resource "yandex_mdb_postgresql_database" "db" {
  cluster_id = yandex_mdb_postgresql_cluster.db_cluster.id
  name       = var.database_name
  owner      = yandex_mdb_postgresql_user.db_user.name

  depends_on = [yandex_mdb_postgresql_user.db_user]
}