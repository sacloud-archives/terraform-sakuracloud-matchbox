module "server" {
  source             = "sacloud/server/sakuracloud"
  version            = "0.1.1"
  os_type            = "rancheros"
  server_name        = "${var.server_name}"
  password           = "${var.server_password}"
  server_core        = "${var.server_core}"
  server_memory      = "${var.server_memory}"
  disk_size          = "${var.disk_size}"
  ssh_public_key     = "${var.server_public_key}"
  startup_script_ids = ["${sakuracloud_note.server.id}"]
  packet_filter_ids  = ["${sakuracloud_packet_filter.filter.id}"]
  additional_nics    = ["${var.switch_id}"]
}

resource "sakuracloud_note" "server" {
  name  = "${var.server_name}"
  class = "yaml_cloud_config"

  content = <<EOF
#cloud-config
rancher:
  network:
    interfaces:
      eth1:
        address: ${var.matchbox_ipaddress}/${var.matchbox_nw_mask_len}
        mtu: 1500
        dhcp: false
${var.server_enable_forward ? local.rancher_config_sysctl : ""}
EOF
}

locals {
  rancher_config_sysctl = <<EOF
    pre_cmds:
    - iptables -P FORWARD DROP
    - iptables -A FORWARD -i eth1 -o eth0 -m iprange --src-range ${var.dhcp_start}-${var.dhcp_end} -j ACCEPT
    - iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
    - iptables -t nat -A POSTROUTING -o eth0 -m iprange --src-range ${var.dhcp_start}-${var.dhcp_end} -j MASQUERADE
    - iptables -A OUTPUT -o eth0 -d 10.0.0.0/8 -j DROP
    - iptables -A OUTPUT -o eth0 -d 176.16.0.0/12 -j DROP
    - iptables -A OUTPUT -o eth0 -d 192.168.0.0/16 -j DROP
    - iptables -A OUTPUT -o eth0 -d 127.0.0.0/8 -j DROP
  sysctl:
    net.ipv4.ip_forward: 1
EOF
}

resource null_resource "server_provisioning" {
  triggers {
    server_id = "${module.server.server_id}"
  }

  connection {
    type        = "ssh"
    user        = "rancher"
    host        = "${module.server.server_ipaddress}"
    private_key = "${var.server_private_key == "" ? module.server.ssh_private_key : var.server_private_key}"
  }

  provisioner "file" {
    content     = "${data.template_file.server_provisioning.rendered}"
    destination = "/home/rancher/run-matchbox.sh"
  }

  provisioner "file" {
    content     = "${local.ca_cert}"
    destination = "/home/rancher/ca.crt"
  }

  provisioner "file" {
    content     = "${local.server_cert}"
    destination = "/home/rancher/server.crt"
  }

  provisioner "file" {
    content     = "${local.server_key}"
    destination = "/home/rancher/server.key"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p /etc/matchbox",
      "sudo mv /home/rancher/ca.crt /etc/matchbox/",
      "sudo mv /home/rancher/server.crt /etc/matchbox/",
      "sudo mv /home/rancher/server.key /etc/matchbox/",
      "sudo chown root. /etc/matchbox/*",
      "sudo chmod 0600 /etc/matchbox/*",
      "sudo mkdir -p /opt/matchbox/assets",
      "chmod +x /home/rancher/run-matchbox.sh",
      "/home/rancher/run-matchbox.sh",
    ]
  }
}

resource null_resource "assets" {
  count = "${length(var.prefetch_coreos_assets_keys)}"

  triggers {
    server_id   = "${module.server.server_id}"
    provisioned = "${null_resource.server_provisioning.id}"
    assets      = "${var.prefetch_coreos_assets_keys[count.index]}"
  }

  connection {
    type        = "ssh"
    user        = "rancher"
    host        = "${module.server.server_ipaddress}"
    private_key = "${var.server_private_key == "" ? module.server.ssh_private_key : var.server_private_key}"
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p /home/rancher/prefetch/${var.prefetch_coreos_assets_keys[count.index]}",
    ]
  }

  provisioner "file" {
    content     = "${data.template_file.prefetch_assets.*.rendered[count.index]}"
    destination = "/home/rancher/prefetch/${var.prefetch_coreos_assets_keys[count.index]}/fetch.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/rancher/prefetch/${var.prefetch_coreos_assets_keys[count.index]}/fetch.sh",
      "sudo /home/rancher/prefetch/${var.prefetch_coreos_assets_keys[count.index]}/fetch.sh",
    ]
  }
}

data template_file "prefetch_assets" {
  count    = "${length(var.prefetch_coreos_assets_keys)}"
  template = "${file("${path.module}/prefetch.tpl")}"

  vars {
    version    = "${var.prefetch_coreos_assets_keys[count.index]}"
    kernel     = "${var.coreos_filenames["kernel"]}"
    initrd     = "${var.coreos_filenames["initrd"]}"
    image      = "${var.coreos_filenames["image"]}"
    url_prefix = "${local.coreos_image_url_prefix}"
  }
}

data template_file "server_provisioning" {
  template = "${file("${path.module}/provisioning.tpl")}"

  vars {
    dhcp_start             = "${var.dhcp_start}"
    dhcp_end               = "${var.dhcp_end}"
    dhcp_gateway           = "${var.matchbox_gateway}"
    dhcp_dns_servers       = "${join(",", module.server.server_dns_servers)}"
    listen_ip              = "${var.matchbox_ipaddress}"
    rpc_listen_ip          = "${module.server.server_ipaddress}"
    matchbox_http_api_port = "${var.matchbox_http_api_port}"
    matchbox_grpc_api_port = "${var.matchbox_grpc_api_port}"
  }
}
