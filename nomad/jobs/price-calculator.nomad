job "springboot-app" {
  datacenters = ["dc1"]
  type = "service"

  group "springboot" {
    count = 1

    task "app" {
      driver = "docker"

      config {
        image = "localhost:5000/pfg-price-calculator:0.0.2-SNAPSHOT"
        network_mode = "bridge"
        port_map {
          http = 8080
        }
      }

      resources {
        cpu = 500
        memory = 256
        network {
          port "http" {
            static = 8090
          }
        }
      }

      service {
        name = "price-calculator"
        tags = ["price-calculator"]
        check {
          type = "http"
          path = "/actuator/health"
          interval = "10s"
          timeout = "2s"
          port = "http"
        }
      }
    }
  }
}
