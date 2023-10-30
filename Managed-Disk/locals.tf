locals {
  current_date = formatdate("MM/DD/YYYY", timestamp())
  local_tags = {
    Deployed_on = local.current_date
  }
  tags = merge(var.tags, local.local_tags)
}