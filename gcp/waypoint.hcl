project = "hashitalk-deploy-gcp"

app "hello-app-gcp" {
  runner {
    profile = "kubernetes-gcp"
  }

  config {
    workspace "default" {
      runner_profile = kubernetes-gcp-dev
    }
    workspace "prod" {
      runner_profile = kubernetes-gcp-prod
    }
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
      // Map lookup to change the namespace based on the workspace
      namespace = {
        "default" = "dev"
        "prod"  = "prod"
      }[workspace.name]
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