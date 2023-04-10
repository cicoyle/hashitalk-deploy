project = "hello-gh-actions"

app "hello-gh-actions" {
#app "hello-app-aws" {
#  runner {
#    profile = "kubernetes-aws"
#  }
  labels = {
    "check" = "polling",
    "env"     = "dev"
  }

  runner {
    profile = "kubernetes-test-poll-dockrk8s"
  }

  build {
    use "docker" {}
    registry {
      use "docker" {
        image = var.image
        // returns a humanized version of the git hash, taking into account tags and changes
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
  }

  release {
    use "kubernetes" {
      port          = 5300
    }
  }
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