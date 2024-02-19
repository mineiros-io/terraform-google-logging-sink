# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# EMPTY FEATURES (DISABLED) UNIT TEST
# This module tests an empty set of features.
# The purpose is to verify no resources are created when the module is disabled.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# DO NOT RENAME MODULE NAME
module "test" {
  source = "../.."

  module_enabled = false

  # add all required arguments
  name        = "my-pubsub-instance-sink-disabled"
  destination = "pubsub.googleapis.com/projects/${var.gcp_project}/topics/instance-activity"
  # add all optional arguments that create additional resources
}

# outputs generate non-idempotent terraform plans so we disable them for now unless we need them.
# output "all" {
#   description = "All outputs of the module."
#   value       = module.test
# }
