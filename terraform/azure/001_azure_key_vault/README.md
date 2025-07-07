# Azure Key Vault

In this example, we will create an Azure Key Vault using Terraform.

Azure key vault is used to securely store and manage sensitive information such as secrets, keys, and certificates.

First we need to define the value for the variables in a `terraform.tfvars` file:

```hcl
subscription_id     = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" # replace with your Azure subscription ID
key_vault_name      = "xxx-kv" # key vault name must be globally unique
resource_group_name = "xxx-rg" # resource group where the key vault will be created, it must exist
tenant_id           = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" # replace with your Azure tenant ID
```

Note: We will create the Key Vault in an existing resource group, so make sure the resource group is created before running this example. Also the location of the Key Vault is the same as the resource group but it can be changed if necessary.

To run the example, you can initialize Terraform and apply the configuration:

```bash
terraform init # This will initialize the Terraform working directory
terraform plan -out=tfplan # This will show you the execution plan
terraform apply tfplan # This will apply the changes required to reach the desired state of the configuration
```

For example, the output of `terraform plan -out=tfplan` will look like this:

```plaintext
$ terraform plan -out=tfplan
data.azurerm_resource_group.rg: Reading...
data.azurerm_resource_group.rg: Read complete after 1s [id=/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/xxx-rg]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # azurerm_key_vault.key_vault will be created
  + resource "azurerm_key_vault" "key_vault" {
      + access_policy                 = (known after apply)
      + id                            = (known after apply)
      + location                      = "westeurope"
      + name                          = "xxx-kv"
      + public_network_access_enabled = true
      + resource_group_name           = "xxx-rg"
      + sku_name                      = "standard"
      + soft_delete_retention_days    = 90
      + tenant_id                     = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
      + vault_uri                     = (known after apply)

      + contact (known after apply)

      + network_acls (known after apply)
    }

  # azurerm_key_vault_access_policy.access_policy will be created
  + resource "azurerm_key_vault_access_policy" "access_policy" {
      + certificate_permissions = [
          + "Get",
          + "List",
          + "Create",
          + "Update",
          + "Delete",
          + "Purge",
          + "Recover",
        ]
      + id                      = (known after apply)
      + key_permissions         = [
          + "Get",
          + "List",
          + "Create",
          + "Update",
          + "Delete",
          + "Purge",
          + "Recover",
        ]
      + key_vault_id            = (known after apply)
      + object_id               = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
      + secret_permissions      = [
          + "Get",
          + "List",
          + "Set",
          + "Delete",
          + "Purge",
          + "Recover",
        ]
      + tenant_id               = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    }

Plan: 2 to add, 0 to change, 0 to destroy.

───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Saved the plan to: tfpplan

To perform exactly these actions, run the following command to apply:
    terraform apply "tfplan"
```

And an example of output for `terraform apply tfplan` is:

```plaintext
$ terraform apply tfplan
azurerm_key_vault.key_vault: Creating...
azurerm_key_vault.key_vault: Still creating... [00m10s elapsed]
azurerm_key_vault.key_vault: Still creating... [00m20s elapsed]
azurerm_key_vault.key_vault: Still creating... [00m30s elapsed]
azurerm_key_vault.key_vault: Still creating... [00m40s elapsed]
azurerm_key_vault.key_vault: Still creating... [00m50s elapsed]
azurerm_key_vault.key_vault: Still creating... [01m00s elapsed]
azurerm_key_vault.key_vault: Still creating... [01m10s elapsed]
azurerm_key_vault.key_vault: Still creating... [01m20s elapsed]
azurerm_key_vault.key_vault: Still creating... [01m30s elapsed]
azurerm_key_vault.key_vault: Still creating... [01m40s elapsed]
azurerm_key_vault.key_vault: Still creating... [01m50s elapsed]
azurerm_key_vault.key_vault: Still creating... [02m00s elapsed]
azurerm_key_vault.key_vault: Still creating... [02m10s elapsed]
azurerm_key_vault.key_vault: Still creating... [02m20s elapsed]
azurerm_key_vault.key_vault: Still creating... [02m30s elapsed]
azurerm_key_vault.key_vault: Still creating... [02m40s elapsed]
azurerm_key_vault.key_vault: Creation complete after 2m46s [id=/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/xxx-rg/providers/Microsoft.KeyVault/vaults/xxx-kv]
azurerm_key_vault_access_policy.access_policy: Creating...
azurerm_key_vault_access_policy.access_policy: Creation complete after 6s [id=/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/xxx-rg/providers/Microsoft.KeyVault/vaults/xxx-kv/objectId/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx]
```

We successfully created an Azure Key Vault with the specified name and access policies. You can now use this Key Vault to store secrets, keys, and certificates securely.
