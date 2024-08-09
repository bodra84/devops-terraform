terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
  required_version = "~>1.8.4" /*Многострочный комментарий.
 Требуемая версия terraform */
}
provider "docker" {
  host     = "ssh://davlat@89.169.163.106:22"
  ssh_opts = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null"]
}

#однострочный комментарий

resource "random_password" "root_pass" {
  length      = 16
  special     = false
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
}

resource "random_password" "user_pass" {
  length      = 16
  special     = false
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
}

resource "docker_image" "mysql"{
  name         = "mysql:8"
}

resource "docker_container" "mysql" {
  image = docker_image.mysql.image_id
  name  = "mysql"

  ports {
    internal = 3306
    external = 3306
  }
  
   env = [
    "MYSQL_ROOT_PASSWORD=${random_password.root_pass.result}",
    "MYSQL_DATABASE=wordpress",
    "MYSQL_USER=wordpress",
    "MYSQL_PASSWORD=${random_password.user_pass.result}",
    "MYSQL_ROOT_HOST=%"
   ]
}

