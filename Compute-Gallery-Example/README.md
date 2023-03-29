## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.49.0 |

## Modules

No modules.

## Notes

This will create the resources listed below.   It does require an existing VM that has been generalized so that a base image can be created (as referenced by the variable `generalized_vm`).   You can find out more details about how to [generalize a VM here](https://learn.microsoft.com/en-us/azure/virtual-machines/generalize).

THe general process for an Image is defined below. 

| Component | Purpose | Parent |
|-----------|---------|--------|
| Compute Gallery | Stores the images definitions | `n/a` |
| Image Definition | Describes an image that will be defined.  This includes OS type, architecture, and other metadata to help describe the image. | `Compute Gallery` |
| Shared Image Version | Is a specific version of an image definition.  This is based on the . | `Image Definition` |
| Image | This is the image that is created based on the information based in from `generalized_vm`.  This image is used to define the Shared Image Vesion. | `n/a` |

## Resources

| Name | Type |
|------|------|
| [azurerm_image.image](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/image) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_shared_image.shared_image](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/shared_image) | resource |
| [azurerm_shared_image_gallery.gallery](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/shared_image_gallery) | resource |
| [azurerm_shared_image_version.image_version](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/shared_image_version) | resource |
| [azurerm_virtual_machine.existing_vm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_machine) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_base_vm"></a> [base\_vm](#input\_base\_vm) | The name of the virtual machine in which to create the resources. | <pre>object({<br>    name                = string<br>    resource_group_name = string<br>  })</pre> | n/a | yes |
| <a name="input_image_gallery"></a> [image\_gallery](#input\_image\_gallery) | The name of the image gallery in which to create the resources. | <pre>object({<br>    name          = string<br>    description   = string<br>  })</pre> | n/a | yes |
| <a name="input_image_name"></a> [image\_name](#input\_image\_name) | The name of the image in which to create the resources. | `string` | n/a | yes |
| <a name="input_image_version"></a> [image\_version](#input\_image\_version) | The name of the image version in which to create the resources. | <pre>object({<br>    name                = string<br>    target_region      = list(object({<br>      name                    = string<br>      regional_replica_count  = number<br>      storage_account_type    = string<br>    }))<br>  })</pre> | n/a | yes |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | The name of the resource group in which to create the resources. | <pre>object({<br>    name      = string<br>    location  = string<br>  })</pre> | n/a | yes |
| <a name="input_shared_image"></a> [shared\_image](#input\_shared\_image) | The name of the image in which to create the resources. | <pre>object({<br>    name                          = string<br>    description                   = string<br>    os_type                       = string<br>    architecture                  = string<br>    hyper_v_generation            = string<br>    min_recommended_vcpu_count    = number<br>    max_recommended_vcpu_count    = number<br>    min_recommended_memory_in_gb  = number<br>    max_recommended_memory_in_gb  = number<br>    publisher                     = string<br>    offer                         = string<br>    sku                           = string<br>  })</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resource. | `map(string)` | n/a | yes |

## Outputs

No outputs.
