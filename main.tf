# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# THIS IS A UPPERCASE MAIN HEADLINE
# And it continues with some lowercase information about the module
# We might add more than one line for additional information
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

resource "google_logging_project_sink" "sink" {
  count = var.module_enabled ? 1 : 0

  name        = var.name
  destination = var.destination

  filter                 = var.filter
  description            = var.description
  disabled               = var.disabled
  project                = var.project
  unique_writer_identity = var.unique_writer_identity

  # TODO: is this correct?
  bigquery_options {
    use_partitioned_tables = var.use_partitioned_tables
  }

  dynamic "exclusions" {
    for_each = var.exclusions
    iterator = exclusion

    content {
      name        = exclusion.value.name
      filter      = exclusion.value.filter
      description = try(exclusion.value.description, null)
    }
  }

  depends_on = [var.module_depends_on]
}
