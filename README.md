# Setup Jump Server

1. [Sign in with Azure CLI](https://docs.microsoft.com/en-us/cli/azure/authenticate-azure-cli)
1. Copy `terraform.tfvars.example` to `terraform.tfvars`
1. Edit `terraform.tfvars` with your information
1. Run `terraform plan`
1. Run `terraform apply -auto-approve`
1. Get the public IP of the Jump Server from the Azure portal
1. SSH into the Jump Server
1. On the Jump Server, you will have sample TKG cluster config files in the directory `clusterconfigs`
1. Edit the following fields in each cluster config file
```yaml
AZURE_TENANT_ID: 
AZURE_SUBSCRIPTION_ID: 
AZURE_CLIENT_ID: 
AZURE_CLIENT_SECRET: 
AZURE_LOCATION: 
AZURE_SSH_PUBLIC_KEY_B64: 
```

Docker, kubectl, and the tanzu cli are all installed on the Jump Server.
