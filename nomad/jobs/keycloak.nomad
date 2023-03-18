job "keycloak" {
  type = "service"
  datacenters = ["dc1"]

  group "keycloak" {
    count = 1

    task "keycloak" {
      driver = "docker"

      config {
        image = "quay.io/keycloak/keycloak:18.0.0"
        port_map {
          keycloak = 8080
          callback = 8250
        }
        args  = ["start-dev"]
      }

      env {
        KEYCLOAK_USER = "admin"
        KEYCLOAK_PASSWORD = "admin"
      }

      resources {
        memory = 550

        network {
          port "keycloak" {
            static = 18080
          }
          port "callback" {
            static = 18250
          }
        }
      }

      service {
        name = "keycloak"
        tags = ["auth"]

        check {
          type  = "tcp"
          interval = "10s"
          timeout  = "2s"
          port  = "keycloak"
        }
      }
    }
  }
}