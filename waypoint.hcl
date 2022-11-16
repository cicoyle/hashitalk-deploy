project = "hashitalk-deploy"

app "hello-app" {
#  config {
#    runner {
#      // All config in here is exposed only on runners.
#      profile = "kubernetes-aws"
#
##      env = {
##        DOCKER_PWD = var.password
##      }
#    }

    // App config is here...
  #}

  runner {
    profile = "kubernetes-aws"
  }

  build {
    use "docker" {}
    registry {
      use "docker" {
        image = var.image
        tag = var.tag
#        auth {
#          username = "hashicassie"
#          password = var.password
#        }
      }
    }
  }
  deploy {
    use "kubernetes" {
      probe_path = "/"
#      namespace  = "cassie-hashitalk-deploy"
    }
    workspace "production" {
      use "kubernetes" {
#        namespace = "cassie-hashitalk-deploy"
      }
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
#variable "password" {
#  type = string
#  env = ["DOCKER_PWD"]
#}