project = "hashitalk-deploy-azure"

pipeline "builder" {
  step "build-dev" {
    use "build" {}
  }
  step "build-prod" {
    workspace = "prod"
    use "build" {}
  }
  step "deploy-dev" {
    use "deploy" {
      release = false
    }
  }
}

app "hello-app-azure" {
  runner {
    profile = "kubernetes-azure"
  }

  build {
    use "docker" {}
    registry {
      workspace "prod" {
        use "docker" {
          image = var.image
          tag   = gitrefpretty()
          // Credentials for authentication to push to docker registry
          auth {
            username = var.username
            password = var.password
          }
        }
      }
    }
  }

  deploy {
    use "kubernetes" {
      service_port = 5300
      namespace = "default"
    }
    workspace "prod" {
      use "kubernetes" {}
    }
  }

#  release {
#    use "kubernetes" {
#      port          = 5300
#    }
#  }
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