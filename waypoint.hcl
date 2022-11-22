project = "hashitalk-deploy-$${var.cloud}"

app "hello-app-$${var.cloud}" {
  runner {
    profile = "kubernetes-$${var.cloud}"
  }

  build {
    use "docker" {}
    registry {
      use "docker" {
        image = var.image
        tag = gitrefpretty()
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
      port          = 5300
    }
  }
}

variable "cloud" {
  type = string
  default = "aws"
}
variable "image" {
  type = string
  default = "hashicassie/hashitalk-deploy"
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