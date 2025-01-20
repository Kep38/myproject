data "yandex_lockbox_secret_version" "terraform_secrets" {
  secret_id = "e6qfjirmt2vcd35edtdq" # ID секрета
   version_id = "e6q3ks44k5sfittlo04t"
}

terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.131.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.26.0"
    }
    external = {
      source  = "hashicorp/external"
      version = "~> 2.3.2"
    }
  }
}


 provider "yandex" {
  zone = var.zone
 }

# Конфигурируем провайдер Helm
provider "helm" {
  kubernetes {
    host                   = module.k8s.k8s_cluster_external_v4_endpoint
    token                  = module.k8s.k8s_token
    cluster_ca_certificate = base64decode(module.k8s.k8s_cluster_ca_certificate)
  }
}

# Конфигурируем провайдер Kubernetes
provider "kubernetes" {
  host                   = module.k8s.k8s_cluster_external_v4_endpoint
  token                  = module.k8s.k8s_token
  cluster_ca_certificate = base64decode(module.k8s.k8s_cluster_ca_certificate)
}

module "vpc" {
  source      = "../modules/vpc"
  subnet_name = var.subnet_name
  cidr_block  = var.cidr_block
  zone        = var.zone
}

module "k8s" {
  source                   = "../modules/k8s"
  vpc_subnet_id            = module.vpc.vpc_subnet_id
  existing_vpc_network_id  = module.vpc.vpc_network_id
  node_count               = var.node_count
  node_disk_size           = var.node_disk_size
  node_memory              = var.node_memory
  node_cores               = var.node_cores
  master_version           = var.master_version
  service_account_id       = data.yandex_lockbox_secret_version.terraform_secrets.entries[4].text_value # service_account_id
  node_service_account_id  = data.yandex_lockbox_secret_version.terraform_secrets.entries[5].text_value # node_service_account_id
  zone                     = var.zone
  folder_id                = var.k8s_folder_id
  depends_on               = [module.vpc]
}

module "db" {
  source            = "../modules/db"
  vpc_network_id    = module.vpc.vpc_network_id
  vpc_subnet_id     = module.vpc.vpc_subnet_id
  database_name     = var.database_name
  database_user     = var.database_user
  database_password = data.yandex_lockbox_secret_version.terraform_secrets.entries[0].text_value # database_password
  zone              = var.zone
#  token             = data.yandex_lockbox_secret_version.terraform_secrets.entries[3].text_value # token
#  cloud_id          = data.yandex_lockbox_secret_version.terraform_secrets.entries[1].text_value # cloud_id
  folder_id         = data.yandex_lockbox_secret_version.terraform_secrets.entries[2].text_value # folder_id
  depends_on        = [module.k8s]
}

module "monitoring" {
  source                   = "../modules/monitoring"
  grafana_admin_password   = data.yandex_lockbox_secret_version.terraform_secrets.entries[6].text_value # grafana_admin_password
  prometheus_scrape_interval = "30s"
  smtp_server              = data.yandex_lockbox_secret_version.terraform_secrets.entries[10].text_value # smtp_server
  smtp_user                = data.yandex_lockbox_secret_version.terraform_secrets.entries[7].text_value # smtp_user
  smtp_password            = data.yandex_lockbox_secret_version.terraform_secrets.entries[8].text_value # smtp_password
  alertmanager_email       = data.yandex_lockbox_secret_version.terraform_secrets.entries[9].text_value # alertmanager_email
  depends_on               = [module.k8s]
}

module "app" {
  source          = "../modules/app"
  vpc_subnet_id   = module.vpc.vpc_subnet_id
  k8s_cluster_id  = module.k8s.cluster_id
  app_image       = var.app_image
  database_url    = "postgres://${module.db.username}:${module.db.password}@${module.db.hostname}:${module.db.port}/${module.db.name}"
  depends_on      = [module.db, module.k8s]
}

module "logging" {
  source                     = "../modules/logging"
  log_server                 = var.log_server
  log_port                   = var.log_port
  k8s_host                   = module.k8s.k8s_cluster_external_v4_endpoint
  k8s_token                  = module.k8s.k8s_token
  k8s_cluster_ca_certificate = base64decode(module.k8s.k8s_cluster_ca_certificate)
  folder_id                  = data.yandex_lockbox_secret_version.terraform_secrets.entries[2].text_value # folder_id
  token                      = data.yandex_lockbox_secret_version.terraform_secrets.entries[3].text_value # token
  cloud_id                   = data.yandex_lockbox_secret_version.terraform_secrets.entries[1].text_value # cloud_id
  depends_on                 = [module.k8s]
}