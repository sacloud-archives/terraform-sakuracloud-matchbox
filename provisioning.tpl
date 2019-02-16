#!/usr/bin/env bash

set -ex
sudo docker run -d --name dnsmasq --restart=always --cap-add=NET_ADMIN --net=host quay.io/coreos/dnsmasq \
  -d -q \
  --dhcp-range=${dhcp_start},${dhcp_end} \
  --dhcp-option=option:router,${dhcp_gateway} \
  --dhcp-option=option:dns-server,${dhcp_dns_servers} \
  --dhcp-match=set:bios,option:client-arch,0 \
  --dhcp-boot=tag:bios,undionly.kpxe \
  --dhcp-match=set:efi32,option:client-arch,6 \
  --dhcp-boot=tag:efi32,ipxe.efi \
  --dhcp-match=set:efibc,option:client-arch,7 \
  --dhcp-boot=tag:efibc,ipxe.efi \
  --dhcp-match=set:efi64,option:client-arch,9 \
  --dhcp-boot=tag:efi64,ipxe.efi \
  --dhcp-userclass=set:ipxe,iPXE \
  --dhcp-boot=tag:ipxe,http://${listen_ip}:${matchbox_http_api_port}/boot.ipxe \
  --strict-order \
  --log-queries \
  --log-dhcp

sudo docker run -d --name matchbox --restart=always --net=host \
  -v /opt/matchbox:/var/lib/matchbox:Z \
  -v /etc/matchbox:/etc/matchbox:Z,ro \
  quay.io/coreos/matchbox:latest \
    -address=${listen_ip}:${matchbox_http_api_port}\
    -rpc-address=${rpc_listen_ip}:${matchbox_grpc_api_port}
