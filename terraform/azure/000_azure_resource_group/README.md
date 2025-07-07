# Azure Resource Group

In this example, we will create an Azure Resource Group using Terraform.

First we need to define the value for the variables in a `terraform.tfvars` file:

```hcl
resource_group_name = "my-resource-group" # replace with your desired resource group name
location = "East US" # or any other Azure region
subscription_id = "your-subscription-id" # replace with your Azure subscription ID
```

Once you have defined the variables, you can initialize Terraform and apply the configuration:

```bash
terraform init # This will initialize the Terraform working directory
terraform plan -out=tfplan # This will show you the execution plan
terraform apply tfplan # This will apply the changes required to reach the desired state of the configuration
```

An example of output for `terraform plan -out=tfplan` is:

```plaintext
$ terraform plan -out=tfplan

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # azurerm_resource_group.rg will be created
  + resource "azurerm_resource_group" "rg" {
      + id       = (known after apply)
      + location = "westeurope"
      + name     = "something-rg"
    }

Plan: 1 to add, 0 to change, 0 to destroy.

───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Saved the plan to: tfplan

To perform exactly these actions, run the following command to apply:
    terraform apply "tfplan"
```

If it match your expectations, you can proceed with the `terraform apply tfplan` command to create the resource group.

```plaintext
$ terraform apply tfplan

azurerm_resource_group.rg: Creating...
azurerm_resource_group.rg: Still creating... [00m10s elapsed]
azurerm_resource_group.rg: Creation complete after 11s [id=/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/something-rg]
```
