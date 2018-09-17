`Run (Apply)`
terraform apply -var-file=account_variables.tfvars
`Init `
erraform init -backend-config="key=accounts/starzplayukprod.tfstate" -backend-config="access_key=AWS Access Key" -backend-config="secret_key=AWS0 Key" # awsaccounts-terraform
