# ----------------------------------------------------------------------------------------------------------------------
# OUTPUT CALCULATED VARIABLES (prefer full objects)
# ----------------------------------------------------------------------------------------------------------------------

output "project_sink" {
  description = "All attributes of the created `google_logging_project_sink` resource."
  value       = try(google_logging_project_sink.project_sink[0], null)
}

output "folder_sink" {
  description = "All attributes of the created `google_logging_folder_sink` resource."
  value       = try(google_logging_folder_sink.folder_sink[0], null)
}

output "organization_sink" {
  description = "All attributes of the created `google_logging_organization_sink` resource."
  value       = try(google_logging_organization_sink.organization_sink[0], null)
}

# ----------------------------------------------------------------------------------------------------------------------
# OUTPUT ALL RESOURCES AS FULL OBJECTS
# ----------------------------------------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------------------------------------------
# OUTPUT MODULE CONFIGURATION
# ----------------------------------------------------------------------------------------------------------------------

output "module_enabled" {
  description = "Whether or not the module is enabled."
  value       = var.module_enabled
}
