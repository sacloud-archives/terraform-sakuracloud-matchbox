module "matchbox" {
  source = "sacloud/matchbox/sakuracloud"

  /*** Required variables ***/
  server_password = "put-your-server-password"
  switch_id       = "put-your-switch-id"

  /*** For server ***/
  # server_name           = "matchbox-server"
  # server_core           = 1
  # server_memory         = 2
  # server_public_key     = "put-your-ssh-public-key"
  # server_private_key    = "put-your-ssh-public-key"
  # server_enable_forward = true
  # disk_size             = 20

  /*** For generate TLS certs ***/
  # tls_dns_names             = ["matchbox.localdomain"]
  # tls_ip_addresses          = ["192.168.0.1"]
  # tls_common_name           = "matchbox.localdomain"
  # tls_organization          = "Sacloud"
  # tls_validity_period_hours = 17520
  # tls_early_renewal_hours   = 8760

  # ca_cert     = ""
  # client_cert = ""
  # client_key  = ""
  # server_cert = ""
  # server_key  = ""

  /*** For matchbox's Network/DHCP settings ***/

  # matchbox_ipaddress     = "192.168.0.1"
  # matchbox_nw_mask_len   = "24"
  # matchbox_gateway       = "192.168.0.1"
  # matchbox_http_api_port = 8080
  # matchbox_grpc_api_port = 8081
  # dhcp_start             = "192.168.0.101"
  # dhcp_end               = "192.168.0.200"

  /*** Prefetch CoreOS Images ***/
  # prefetch_coreos_assets_keys = ["current"]
  # prefetch_coreos_assets_channel = "stable" # allowed values are: current/beta/alpha/custom
  # prefetch_coreos_assets_custom_url = ""
  # coreos_filenames = {
  #    image = "coreos_production_image.bin.bz2"
  #    kernel = "coreos_production_pxe.vmlinuz"
  #    initrd = "coreos_production_pxe_image.cpio.gz"
  # }
}
