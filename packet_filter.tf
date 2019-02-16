resource "sakuracloud_packet_filter" "filter" {
  name = "${var.server_name}-filter"

  expressions = {
    protocol    = "tcp"
    dest_port   = "22"
    description = "allow-external:SSH"
  }

  expressions = {
    protocol    = "tcp"
    dest_port   = "${var.matchbox_grpc_api_port}"
    description = "allow-external:for interact to matchbox via gRPC"
  }

  expressions = {
    protocol = "icmp"
  }

  expressions = {
    protocol = "fragment"
  }

  expressions = {
    protocol    = "udp"
    source_port = "123"
  }

  expressions = {
    protocol    = "tcp"
    dest_port   = "32768-61000"
    description = "allow-from-server"
  }

  expressions = {
    protocol    = "udp"
    dest_port   = "32768-61000"
    description = "allow-from-server"
  }

  expressions = {
    protocol    = "ip"
    allow       = false
    description = "Deny ALL"
  }
}
