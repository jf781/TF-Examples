resource_group = {
  name     = "joefecht-harness-webapp"
  location = "East US 2"
}

tags = {
  Environment = "Dev"
  Owner       = "Joe Fecht"
}

app_service_plan = {
  name     = "my-app-service-plan"
  os_type  = "Linux"
  sku_name = "S1"
}

app_service = {
  name = "jf-harness-webapp-03"
  site_settings = {
    http2_enabled = false
    always_on     = true
    worker_count  = 1
  }
  application_stack = {
    docker_image_name   = "library/nginx:latest"
    docker_registry_url = "https://index.docker.io"
  }
}
