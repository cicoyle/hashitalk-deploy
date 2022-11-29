project = "hashitalk-deploy-azure"

pipeline "deploy-and-notify" {
  step "my-build" {
    use "build" {}
  }

  step "my-deploy" {
    use "deploy" {}
  }

  step "notify-slack" {
    image_url = "alpine/curl:3.14"
    use "exec" {
      # executes a binary test with some arguments
      # Imagine this is hitting slack and not httpstat.us
      command = "curl"
      args    = ["-d", "text=App deployment succeeded!", "-d", "channel=C123456", "-H", "Authorization: Bearer <test>", "-X", "POST", "httpstat.us/200"]
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