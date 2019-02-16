# terraform-sakuracloud-matchbox

This module deploys [matchbox](https://coreos.com/matchbox/docs/latest/matchbox.html) to SAKURA Cloud.  

## Overview

![overview.png](https://raw.githubusercontent.com/sacloud/terraform-sakuracloud-matchbox/master/images/overview.png)

#### Included resource

- `sakuracloud_server`
- `sakuracloud_disk`
- `sakuracloud_packet_filter`
- (Optional) `sakuracloud_ssh_key`
- (Optional) certificates for Matchbox's CA/Server/Client (by TLS provider)

## Getting Started

### Prerequisites

- [Terraform](https://terraform.io)
- [Terraform for SAKURA Cloud(community provider)](https://github.com/sacloud/terraform-provider-sakuracloud)

### Customize the deployment

Customizations to the base installation are made to the Terraform variables for each deployment.  
Examples of variables are provided in the file [`examples/basic/matchbox.tf`](https://github.com/sacloud/terraform-sakuracloud-matchbox/blob/master/examples/basic/matchbox.tf).

### Initialize and configure Terraform

#### Get Terraform's SAKURA Cloud modules and providers

Get the modules and providers that Terraform will use to create the server resources:

```bash
$ terraform init
```

### Deploy the server

Test the blueprint before deploying:

```bash
$ terraform plan
```

Next, deploy the server:

```bash
$ terraform apply
```

## License

 `terraform-sakuracloud-server` Copyright (C) 2019 Kazumichi Yamamoto.

  This project is published under [Apache 2.0 License](https://github.com/sacloud/terraform-sakuracloud-kubernetes-single-master/blob/master/LICENSE.txt).
  
## Author

  * Kazumichi Yamamoto ([@yamamoto-febc](https://github.com/yamamoto-febc))
