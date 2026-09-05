locals {
  env       = "develop"
  project   = "platform"
  
  web_name  = "netology-${local.env}-${local.project}-web"
  db_name   = "netology-${local.env}-${local.project}-db"
}

