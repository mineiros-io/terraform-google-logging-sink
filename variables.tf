# ----------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These variables must be set when using this module.
# ----------------------------------------------------------------------------------------------------------------------

variable "name" {
  type        = string
  description = "(Required) The name of the logging sink."
}

variable "destination" {
  type        = string
  description = <<-END
    (Required) The destination of the sink (or, in other words, where logs are written to).

    Can be a Cloud Storage bucket, a PubSub topic, a BigQuery dataset or a Cloud Logging bucket.

    Examples:
    - `"storage.googleapis.com/[GCS_BUCKET]"`
    - `"bigquery.googleapis.com/projects/[PROJECT_ID]/datasets/[DATASET]"`
    - `"pubsub.googleapis.com/projects/[PROJECT_ID]/topics/[TOPIC_ID]"`
    - `"logging.googleapis.com/projects/[PROJECT_ID]]/locations/global/buckets/[BUCKET_ID]"`

    The writer associated with the sink must have access to write to the above resource.
  END
}

# ----------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These variables have defaults, but may be overridden.
# ----------------------------------------------------------------------------------------------------------------------

variable "filter" {
  type        = string
  description = "(Optional) The filter to apply when exporting logs. Only log entries that match the filter are exported."
  default     = null
}

variable "description" {
  type        = string
  description = "(Optional) A description of this sink. The maximum length of the description is 8000 characters."
  default     = null
}

variable "disabled" {
  type        = bool
  description = "(Optional) If set to True, then this sink is disabled and it does not export any log entries."
  default     = null
}

variable "project" {
  type        = string
  description = "(Optional) The ID of the project to create the sink in. If omitted, the project associated with the provider is used."
  default     = null
}

variable "unique_writer_identity" {
  type        = bool
  description = <<-END
    (Optional) Whether or not to create a unique identity associated with this sink.

    If `false` (the default), then the `writer_identity` used is `serviceAccount:cloud-logs@system.gserviceaccount.com`.

    If `true`, then a unique service account is created and used for this sink. If you wish to publish logs across projects or utilize `bigquery_options`, you must set `unique_writer_identity` to true.
  END
  default     = null
}

# TODO: is this a good way for dealing with `bigquery_options` attribute?
variable "use_partitioned_tables" {
  type        = bool
  description = <<-END
    Whether to use BigQuery's partition tables.

    By default, Logging creates dated tables based on the log entries' timestamps, e.g. syslog_20170523. With partitioned tables the date suffix is no longer present and special query syntax has to be used instead. In both cases, tables are sharded based on UTC timezone.
  END
  default     = false
}

# variable "bigquery_options" {
#   type = object({
#     use_partitioned_tables = bool
#   }) # map(string)? any?
#   description = "(Optional) Options that affect sinks exporting data to BigQuery."
#   default     = null
# }

variable "exclusions" {
  # type = list(object({
  #   name        = string
  #   filter      = string
  #   description = optional(string)
  # }))
  type = any # TODO: is this correct?

  description = <<-END
    Log entries that match any of the exclusion filters will not be exported.

    If a log entry is matched by both filter and one of `exclusion_filters` it will not be exported. Can be repeated multiple times for multiple exclusions.
  END
  default     = []
}


# ----------------------------------------------------------------------------------------------------------------------
# MODULE CONFIGURATION PARAMETERS
# These variables are used to configure the module.
# ----------------------------------------------------------------------------------------------------------------------

variable "module_enabled" {
  type        = bool
  description = "(Optional) Whether or not to create resources within the module."
  default     = true
}

variable "module_depends_on" {
  type        = any
  description = "(Optional) A list of external resources the module depends on."
  default     = []
}
