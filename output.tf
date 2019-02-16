output server_private_key {
  value = "${var.server_private_key == "" ? module.server.ssh_private_key : var.server_private_key}"
}

output server_public_key {
  value = "${var.server_public_key == "" ? module.server.ssh_public_key : var.server_public_key}"
}

output server_ip_address {
  value = "${module.server.server_ipaddress}"
}

output matchbox_http_api_endpoint {
  value = "http://${var.matchbox_ipaddress}:${var.matchbox_http_api_port}"
}

output matchbox_grpc_api_endpoint {
  value = "${module.server.server_ipaddress}:${var.matchbox_grpc_api_port}"
}

output prefetch_coreos_assets_keys {
  value = "${var.prefetch_coreos_assets_keys}"
}

output matchbox_assets_coreos_kernel_path {
  value = "${formatlist(local.assets_coreos_path_format_kernel, var.prefetch_coreos_assets_keys)}"
}

output matchbox_assets_coreos_initrd_path {
  value = "${formatlist(local.assets_coreos_path_format_initrd, var.prefetch_coreos_assets_keys)}"
}

output matchbox_assets_coreos_image_path {
  value = "${formatlist(local.assets_coreos_path_format_image , var.prefetch_coreos_assets_keys)}"
}

output ca_cert {
  value = "${local.ca_cert}"
}

output client_cert {
  value = "${local.client_cert}"
}

output client_key {
  value = "${local.client_key}"
}

output server_cert {
  value = "${local.server_cert}"
}

output server_key {
  value = "${local.server_key}"
}
