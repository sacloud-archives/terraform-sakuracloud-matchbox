variable server_password {}
variable switch_id {}

variable server_core {
  default = 1
}

variable server_memory {
  default = 2
}

variable server_public_key {
  default = ""
}

variable server_private_key {
  default = ""
}

variable disk_size {
  default = 20
}

variable "server_name" {
  default = "matchbox-server"
}

variable "server_enable_forward" {
  default = true
}

variable tls_dns_names {
  type    = "list"
  default = ["matchbox.localdomain"]
}

variable tls_ip_addresses {
  type    = "list"
  default = ["192.168.0.1"]
}

variable tls_common_name {
  default = "matchbox.localdomain"
}

variable tls_organization {
  type    = "string"
  default = "Sacloud"
}

variable tls_validity_period_hours {
  default = 17520
}

variable tls_early_renewal_hours {
  default = 8760
}

variable matchbox_ipaddress {
  default = "192.168.0.1"
}

variable matchbox_nw_mask_len {
  default = "24"
}

variable matchbox_http_api_port {
  default = 8080
}

variable matchbox_grpc_api_port {
  default = 8081
}

variable matchbox_gateway {
  default = "192.168.0.1"
}

variable dhcp_start {
  default = "192.168.0.101"
}

variable dhcp_end {
  default = "192.168.0.200"
}

variable ca_cert {
  default = ""
}

variable client_cert {
  default = ""
}

variable client_key {
  default = ""
}

variable server_cert {
  default = ""
}

variable server_key {
  default = ""
}

variable prefetch_coreos_assets_keys {
  type    = "list"
  default = ["current"]
}

variable prefetch_coreos_assets_channel {
  default = "stable"
}

variable prefetch_coreos_assets_custom_url {
  default = ""
}

variable coreos_filenames {
  type = "map"

  default = {
    image  = "coreos_production_image.bin.bz2"
    kernel = "coreos_production_pxe.vmlinuz"
    initrd = "coreos_production_pxe_image.cpio.gz"
  }
}

locals {
  coreos_release_channels = {
    "stable" = "https://stable.release.core-os.net/amd64-usr"
    "beta"   = "https://beta.release.core-os.net/amd64-usr"
    "alpha"  = "https://alpha.release.core-os.net/amd64-usr"
    "custom" = "${var.prefetch_coreos_assets_custom_url}"
  }

  coreos_image_url_prefix = "${local.coreos_release_channels[var.prefetch_coreos_assets_channel]}"

  assets_coreos_path_format_kernel = "/assets/coreos/%s/${var.coreos_filenames["kernel"]}"
  assets_coreos_path_format_initrd = "/assets/coreos/%s/${var.coreos_filenames["initrd"]}"
  assets_coreos_path_format_image  = "/assets/coreos/%s/${var.coreos_filenames["image"]}"
}
