project = "hashitalk-deploy-aws"

app "hello-app-aws" {
  runner {
    profile = "kubernetes-aws"
  }

  build {
    use "docker" {}
    registry {
      use "docker" {
        image = var.image
        tag = var.tag
        // Credentials for authentication to push to docker registry
        auth {
          username = var.username
          password = var.password
        }
      }
    }
  }

  deploy {
    use "kubernetes" {
      service_port = 5300
      namespace = "default"
    }
    workspace "production" {
      use "kubernetes" {}
    }
  }

  release {
    use "kubernetes" {
      load_balancer = true
      port          = 5300
    }
  }
}

variable "image" {
  type = string
  default = "hashicassie/hashitalk-deploy"
}
variable "tag" {
  type = string
  default = "aws"
}
variable "username" {
  type = string
  default = "hashicassie"
}
variable "password" {
  type = string
  env = ["DOCKER_PWD"]
  sensitive = true
}