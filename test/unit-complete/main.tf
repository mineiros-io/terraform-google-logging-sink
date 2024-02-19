# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# COMPLETE FEATURES UNIT TEST
# This module tests a complete set of most/all non-exclusive features
# The purpose is to activate everything the module offers, but trying to keep execution time and costs minimal.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# DO NOT RENAME MODULE NAME
module "test" {
  source = "../.."

  //TODO: disabled due to a problem with 'my-project' not existing
  module_enabled = false

  # add all required arguments
  name        = "my-pubsub-instance-sink"
  destination = "pubsub.googleapis.com/projects/my-project/topics/instance-activity"

  # add all optional arguments that create additional resources
  description            = "some explanation on what this is"
  filter                 = "resource.type = gce_instance"
  unique_writer_identity = true
  use_partitioned_tables = true
  exclusions = [{
    name        = "nsexcllusion1"
    description = "Exclude logs from namespace-1 in k8s"
    filter      = "resource.type = k8s_container resource.labels.namespace_name=\"namespace-1\" "
    },
    {
      name        = "nsexcllusion2"
      description = "Exclude logs from namespace-2 in k8s"
      filter      = "resource.type = k8s_container resource.labels.namespace_name=\"namespace-2\" "
  }]

  module_depends_on = ["nothing"]
}

# outputs generate non-idempotent terraform plans so we disable them for now unless we need them.
# output "all" {
#   description = "All outputs of the module."
#   value       = module.test
# }
