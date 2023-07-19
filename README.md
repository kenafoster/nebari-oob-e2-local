# nebari-oob-e2-local

1. Install Terraform and AWS CLI
2. Create a new AWS EC2 key pair and/or get the name of an existing key pair to use for SSH
3. Manualy create an unattached Elastic IP for use with EC2
4. Configure domain name (i.e. in route 53) with A record pointing to Elastic IP above
5. Create AWS IAM Access/Private Key for deploying into account and region that you specify in tfvars.  Configure CLI to use this key for 'default' profile
6. Create new variables file `env/[your-name]-home.tfvars` - update with your key pair name and public IP when connecting via SSH
7. Run `terraform init`
8. Run `terraform apply --var-file=env/[your-name]-home.tfvars`