# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# THIS IS A UPPERCASE MAIN HEADLINE
# And it continues with some lowercase information about the module
# We might add more than one line for additional information
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

locals {
  create_project_sink      = var.project != null || (var.folder == null && var.organization == null)
  create_folder_sink       = var.project == null && var.folder != null
  create_organization_sink = var.project == null && var.folder == null && var.organization != null
}

resource "google_logging_project_sink" "project_sink" {
  count = var.module_enabled && local.create_project_sink ? 1 : 0

  project = var.project

  name        = var.name
  destination = var.destination

  filter      = var.filter
  description = var.description
  disabled    = var.disabled

  unique_writer_identity = var.unique_writer_identity

  dynamic "bigquery_options" {
    for_each = var.use_partitioned_tables != null ? [1] : []

    content {
      use_partitioned_tables = var.use_partitioned_tables
    }
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

resource "google_logging_folder_sink" "folder_sink" {
  count = var.module_enabled && local.create_folder_sink ? 1 : 0

  folder = var.folder

  name        = var.name
  destination = var.destination

  filter      = var.filter
  description = var.description
  disabled    = var.disabled

  include_children = var.include_children

  dynamic "bigquery_options" {
    for_each = var.use_partitioned_tables != null ? [1] : []

    content {
      use_partitioned_tables = var.use_partitioned_tables
    }
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

resource "google_logging_organization_sink" "organization_sink" {
  count = var.module_enabled && local.create_organization_sink ? 1 : 0

  org_id = var.organization

  name        = var.name
  destination = var.destination

  filter      = var.filter
  description = var.description
  disabled    = var.disabled

  include_children = var.include_children

  dynamic "bigquery_options" {
    for_each = var.use_partitioned_tables != null ? [1] : []

    content {
      use_partitioned_tables = var.use_partitioned_tables
    }
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
