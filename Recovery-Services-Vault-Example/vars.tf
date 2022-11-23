variable rg_name {
  default = "demo-rg"
}

variable region {
  default = "central us"
}

variable tags {
  type    = map(string)
  default = {
    "tag key 1" = "tag value 1"
    "tag key 2" = "tag value 2"
    "tag key 3" = "tag value 3"
  }
}

variable recovery_vault {
  type    = map(string)
  default = {
    "name"                  = "jf-demo-recovery-vault"
    "sku"                   = "Standard"
    "storage_mode"          = "ZoneRedundant" # Possible values are GeoRedundant, LocallyRedundant and ZoneRedundant
    "cross_region_restore"  = "false" # Requires storage_mode to be set to GeoRedundant
    "soft_delete"           = "true"
  }
}

variable vm_backup_policies {
  type = list(object({
    name                            = string
    timezone                        = string
    policy_type                     = string # V1 or V2
    backup_frequency                = string # Hourly, Daily, or Weekly
    backup_start_time               = string
    backup_hour_interval            = number # Used if backup frequency is set to hourly
    backup_window_duration          = number # Used if backup frequency is set to houlry
    backup_weekdays                 = string # Used of backup frequency is set to weekly
    instant_restore_retention_days  = number
    retention_daily_count           = number
    retention_weekly_count          = number
    retention_weekly_weekeday       = string 
    retention_monthly_count         = number
    retention_monthly_weekday       = string
    retention_monthly_week          = string
    retention_yearly_count          = number
    retention_yearly_weekday        = string
    retention_yearly_week           = string
    retention_yearly_month          = string
  }))
  default = [
    {
      name                            = "Policy1"
      timezone                        = "Pacific Standard Time"
      policy_type                     = "V2"
      backup_frequency                = "Daily" # Hourly, Daily, or Weekly
      backup_start_time               = "22:00"
      backup_hour_interval            = null # Used if backup frequency is set to hourly
      backup_window_duration          = null # Used if backup frequency is set to houlry
      backup_weekdays                 = null # Used of backup frequency is set to weekly
      instant_restore_retention_days  = 3
      retention_daily_count           = 10
      retention_weekly_count          = 12
      retention_weekly_weekeday       = "Sunday" 
      retention_monthly_count         = 60
      retention_monthly_weekday       = "Sunday"
      retention_monthly_week          = "Last"
      retention_yearly_count          = 10
      retention_yearly_weekday        = "Sunday"
      retention_yearly_week           = "Last"
      retention_yearly_month          = "December"
    },
    {
      name                            = "Policy2"
      timezone                        = "Pacific Standard Time"
      policy_type                     = "V2"
      backup_frequency                = "Hourly" # Hourly, Daily, or Weekly
      backup_start_time               = "22:00"
      backup_hour_interval            = 4 # Used if backup frequency is set to hourly
      backup_window_duration          = 8 # Used if backup frequency is set to houlry
      backup_weekdays                 = null # Used of backup frequency is set to weekly
      instant_restore_retention_days  = 3
      retention_daily_count           = 10
      retention_weekly_count          = 12
      retention_weekly_weekeday       = "Sunday" 
      retention_monthly_count         = 60
      retention_monthly_weekday       = "Sunday"
      retention_monthly_week          = "Last"
      retention_yearly_count          = 10
      retention_yearly_weekday        = "Sunday"
      retention_yearly_week           = "Last"
      retention_yearly_month          = "December"
    },
    {
      name                            = "Policy3"
      timezone                        = "Pacific Standard Time"
      policy_type                     = "V2"
      backup_frequency                = "Weekly" # Hourly, Daily, or Weekly
      backup_start_time               = "22:00"
      backup_hour_interval            = null # Used if backup frequency is set to hourly
      backup_window_duration          = null # Used if backup frequency is set to houlry
      backup_weekdays                 = "Sunday" # Used of backup frequency is set to weekly
      instant_restore_retention_days  = 3
      retention_daily_count           = null
      retention_weekly_count          = 12
      retention_weekly_weekeday       = "Sunday" 
      retention_monthly_count         = 60
      retention_monthly_weekday       = "Sunday"
      retention_monthly_week          = "Last"
      retention_yearly_count          = 10
      retention_yearly_weekday        = "Sunday"
      retention_yearly_week           = "Last"
      retention_yearly_month          = "December"
    }
  ]
}