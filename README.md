# nebari-oob-e2-local

1. Install Terraform and AWS CLI
2. Create a new AWS EC2 key pair and/or get the name of an existing key pair to use for SSH
3. Create AWS IAM Access/Private Key for deploying into account and region that you specify in the next step.  Configure CLI to use this key for 'default' profile
4. Create new variables file `env/[your-name]-home.tfvars` - update with your key pair name and public IP when connecting via SSH
5. Run `terraform init`
6. Run `terraform apply --var-file=env/[your-name]-home.tfvars`