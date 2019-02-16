# Matchbox basic example

Configuration in this directory creates Matchbox server resources.

## Usage

To run this example you need to execute:

```bash
# set API keys to environment variables
$ export SAKURACLOUD_ACCESS_TOKEN="your-token"
$ export SAKURACLOUD_ACCESS_TOKEN_SECRET="your-secret"
$ export SAKURACLOUD_ZONE="isia or is1b or tk1a"

# Edit parameters
$ vi matchbox.tf

$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.

