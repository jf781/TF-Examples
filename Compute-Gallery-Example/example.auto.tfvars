generalized_vm = {
  name                  = "base-vm"
  resource_group_name  = "testvm_group"
}

resource_group = {
  location  = "centralus"
  name      = "compute-gallery-example"
}

tags = {
  "cost_center" = "1234"
}

image_gallery = {
  description = "Example Image Gallery Descriptoin"
  name        = "exp_image_gallery"
}

shared_image = {
  name                          = "Windows-Server-2019-Datacenter"
  description                   = "This is the base image for the Windows Server 2019 Datacenter"
  os_type                       = "Windows"
  architecture                  = "x64"
  hyper_v_generation            = "V1"
  min_recommended_vcpu_count    = 1
  max_recommended_vcpu_count    = 32
  min_recommended_memory_in_gb  = 3
  max_recommended_memory_in_gb  = 256
  publisher                     = "Customer"
  offer                         = "WindowsServer"
  sku                           = "2019-Datacenter"
}

image_version = {
  name              = "1.0.0"
  target_region = [
    {
      name                    = "centralus"
      regional_replica_count  = 1
      storage_account_type    = "Standard_LRS"
    },
    {
      name                    = "westus2"
      regional_replica_count  = 1
      storage_account_type    = "Standard_LRS"
    }
  ]
}

image_name = "customer-base-server-2019-image"