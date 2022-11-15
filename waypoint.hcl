project = "hashitalk-deploy"

app "hello-app" {
  runner {
    profile = "aws"
  }

  build {
    use "docker" {}
    registry {
      use "docker" {
        image = "${var.image}:${var.tag}"
#        auth {
#          username = "hashicassie"
#          password = ""
#        }
      }
    }
  }
  deploy {
    use "kubernetes" {
      probe_path = "/"
      namespace  = "cassie-hashitalk-deploy"
    }
    workspace "production" {
      use "kubernetes" {
        namespace = "cassie-hashitalk-deploy"
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