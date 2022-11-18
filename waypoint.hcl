project = "hashitalk-deploy"

app "hello-app" {
#  config {
#    runner {
#      // All config in here is exposed only on runners.
#      profile = "kubernetes-aws"
#
#      env = {
#        DOCKER_PWD = var.password
#      }
#    }

    // App config is here...
#  }

#  runner {
#    profile = "kubernetes-aws"
#  }

  build {
    use "docker" {}
    registry {
      use "docker" {
        image = var.image
        tag = var.tag
        auth { //to push to dockerhub
          username = "hashicassie"
          password = var.password
        }
      }
    }
  }
  deploy {
    use "kubernetes" {
#      probe_path = "/SayHello"
      service_port = 8080
      namespace = "default"
    }
    workspace "production" {
      use "kubernetes" {}
    }
  }
}

variable "image" {
  type = string
  default = "hashicassie/hashitalk-deploy"
}
variable "tag" {
  type = string
  default = "2022"
}
variable "password" {
  type = string
  env = ["DOCKER_PWD"]
  sensitive = true
}