# Tanzu Kubernetes Grid 1.3.x on Azure

## Setup Jump Server

1. [Sign in with Azure CLI](https://docs.microsoft.com/en-us/cli/azure/authenticate-azure-cli)
1. Copy `terraform.tfvars.example` to `terraform.tfvars`
1. Edit `terraform.tfvars` with your information
1. Run `terraform plan`
1. Run `terraform apply -auto-approve`
1. The Public IP (PIP) of the Jump Server will be outputted

## Setup Tanzu

1. You will have to obtain download links for the Tanzu CLI (Linux) and Kubectl from [My VMware](https://www.vmware.com/go/get-tkg)
    * NOTE: You will have to download the files locally and use your browser's download history to obtain the links
1. SSH into the Jump Server
1. You will have to run `scripts/tanzu-install.sh` and provide the download links
1. You will have to run sample TKG cluster config files in the directory `clusterconfigs`
1. Edit the following fields in each cluster config file
```yaml
AZURE_TENANT_ID: 
AZURE_SUBSCRIPTION_ID: 
AZURE_CLIENT_ID: 
AZURE_CLIENT_SECRET: 
AZURE_LOCATION: 
AZURE_SSH_PUBLIC_KEY_B64: 
```

Docker, kubectl, and the tanzu cli will be installed on the Jump Server.
