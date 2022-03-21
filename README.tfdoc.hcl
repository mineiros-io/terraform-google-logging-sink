header {
  image = "https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg"
  url   = "https://mineiros.io/?ref=terraform-google-logging-sink"

  badge "build" {
    image = "https://github.com/mineiros-io/terraform-google-logging-sink/workflows/Tests/badge.svg"
    url   = "https://github.com/mineiros-io/terraform-google-logging-sink/actions"
    text  = "Build Status"
  }

  badge "semver" {
    image = "https://img.shields.io/github/v/tag/mineiros-io/terraform-google-logging-sink.svg?label=latest&sort=semver"
    url   = "https://github.com/mineiros-io/terraform-google-logging-sink/releases"
    text  = "GitHub tag (latest SemVer)"
  }

  badge "terraform" {
    image = "https://img.shields.io/badge/Terraform-1.x-623CE4.svg?logo=terraform"
    url   = "https://github.com/hashicorp/terraform/releases"
    text  = "Terraform Version"
  }

  badge "tf-gcp-provider" {
    image = "https://img.shields.io/badge/google-4-1A73E8.svg?logo=terraform"
    url   = "https://github.com/terraform-providers/terraform-provider-google/releases"
    text  = "Google Provider Version"
  }

  badge "slack" {
    image = "https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack"
    url   = "https://mineiros.io/slack"
    text  = "Join Slack"
  }
}

section {
  title   = "terraform-google-logging-sink"
  toc     = true
  content = <<-END
    A [Terraform](https://www.terraform.io) module to create and manage [Google Project Logging Sinks](https://cloud.google.com/logging/docs/reference/v2/rest/v2/projects.sinks).

    **_This module supports Terraform version 1
    and is compatible with the Terraform AWS Provider version 3._**

    This module is part of our Infrastructure as Code (IaC) framework
    that enables our users and customers to easily deploy and manage reusable,
    secure, and production-grade cloud infrastructure.
  END

  section {
    title   = "Module Features"
    content = <<-END
      This module implements the following Terraform resources:

      - `google_logging_project_sink`
    END
  }

  section {
    title   = "Getting Started"
    content = <<-END
      Most common usage of the module:

      ```hcl
      module "terraform-google-logging-sink" {
        source = "git@github.com:mineiros-io/terraform-google-logging-sink.git?ref=v0.0.1"

        name = "my-pubsub-instance-sink"
        destination = "pubsub.googleapis.com/projects/my-project/topics/instance-activity"
      }
      ```
    END
  }

  section {
    title   = "Module Argument Reference"
    content = <<-END
      See [variables.tf] and [examples/] for details and use-cases.
    END

    section {
      title = "Main Resource Configuration"

      variable "name" {
        required    = true
        type        = string
        description = "The name of the logging sink."
      }

      variable "destination" {
        required    = true
        type        = string
        description = <<-END
          The destination of the sink (or, in other words, where logs are written to).

          Can be a Cloud Storage bucket, a PubSub topic, a BigQuery dataset or a Cloud Logging bucket.

          Examples:
          - `"storage.googleapis.com/[GCS_BUCKET]"`
          - `"bigquery.googleapis.com/projects/[PROJECT_ID]/datasets/[DATASET]"`
          - `"pubsub.googleapis.com/projects/[PROJECT_ID]/topics/[TOPIC_ID]"`
          - `"logging.googleapis.com/projects/[PROJECT_ID]]/locations/global/buckets/[BUCKET_ID]"`

          The writer associated with the sink must have access to write to the above resource.
        END
      }

      variable "filter" {
        type        = string
        description = <<-END
          The filter to apply when exporting logs. Only log entries that match the filter are exported.

          See [Advanced Log Filters](https://cloud.google.com/logging/docs/view/building-queries) for information on how to write a filter.
        END
      }

      variable "description" {
        type        = string
        description = "A description of this sink. The maximum length of the description is 8000 characters."
      }

      variable "disabled" {
        type        = bool
        description = "If set to True, then this sink is disabled and it does not export any log entries."
      }

      variable "project" {
        type        = string
        description = <<-END
          The ID of the project to create the sink in.

          If omitted, the project associated with the provider is used.
        END
      }

      variable "unique_writer_identity" {
        type        = bool
        description = <<-END
          Whether or not to create a unique identity associated with this sink.

          If `false` (the default), then the `writer_identity` used is `serviceAccount:cloud-logs@system.gserviceaccount.com`.

          If `true`, then a unique service account is created and used for this sink. If you wish to publish logs across projects or utilize `bigquery_options`, you must set `unique_writer_identity` to true.
        END
        default     = false
      }

      variable "bigquery_options" {
        type        = object(option)
        description = "Options that affect sinks exporting data to BigQuery."

        attribute "use_partitioned_tables" {
          required    = true
          type        = bool
          description = <<-END
            Whether to use [BigQuery's partition tables](https://cloud.google.com/bigquery/docs/partitioned-tables).

            By default, Logging creates dated tables based on the log entries' timestamps, e.g. syslog_20170523. With partitioned tables the date suffix is no longer present and [special query syntax](https://cloud.google.com/bigquery/docs/querying-partitioned-tables)  has to be used instead. In both cases, tables are sharded based on UTC timezone.
          END
        }
      }

      variable "exclusions" {
        type        = list(exclusion)
        description = <<-END
          Log entries that match any of the exclusion filters will not be exported.

          If a log entry is matched by both filter and one of `exclusion_filters` it will not be exported. Can be repeated multiple times for multiple exclusions.
        END

        attribute "name" {
          required    = true
          type        = string
          description = <<-END
            A client-assigned identifier, such as `load-balancer-exclusion`.

            Identifiers are limited to 100 characters and can include only letters, digits, underscores, hyphens, and periods. First character has to be alphanumeric.
          END

          attribute "description" {
            type        = string
            description = "A description of this exclusion."
          }

          attribute "filter" {
            required    = true
            type        = string
            description = <<-END
                An advanced logs filter that matches the log entries to be excluded. By using the sample function, you can exclude less than 100% of the matching log entries.

                See [Advanced Log Filters](https://cloud.google.com/logging/docs/view/advanced_filters) for information on how to write a filter.
              END
          }

          attribute "disabled" {
            type        = bool
            description = "If set to `true`, then this exclusion is disabled and it does not exclude any log entries."
          }
        }
      }
    }

    # section {
    #   title = "Extended Resource Configuration"
    #
    #   # please uncomment and add extended resource variables here (resource not the main resource)
    # }

    section {
      title = "Module Configuration"

      variable "module_enabled" {
        type        = bool
        default     = true
        description = <<-END
          Specifies whether resources in the module will be created.
        END
      }

      # TODO: remove if not needed
      variable "module_tags" {
        type           = map(string)
        default        = {}
        description    = <<-END
          A map of tags that will be applied to all created resources that accept tags.
          Tags defined with `module_tags` can be overwritten by resource-specific tags.
        END
        readme_example = <<-END
          module_tags = {
            environment = "staging"
            team        = "platform"
          }
        END
      }

      # TODO: remove if not needed
      variable "module_timeouts" {
        type           = map(timeout)
        description    = <<-END
          A map of timeout objects that is keyed by Terraform resource name
          defining timeouts for `create`, `update` and `delete` Terraform operations.

          Supported resources are: `null_resource`, ...
        END
        readme_example = <<-END
          module_timeouts = {
            null_resource = {
              create = "4m"
              update = "4m"
              delete = "4m"
            }
          }
        END

        attribute "create" {
          type        = string
          description = <<-END
            Timeout for create operations.
          END
        }

        attribute "update" {
          type        = string
          description = <<-END
            Timeout for update operations.
          END
        }

        attribute "delete" {
          type        = string
          description = <<-END
            Timeout for delete operations.
          END
        }
      }

      variable "module_depends_on" {
        type           = list(dependency)
        description    = <<-END
          A list of dependencies.
          Any object can be _assigned_ to this list to define a hidden external dependency.
        END
        default        = []
        readme_example = <<-END
          module_depends_on = [
            null_resource.name
          ]
        END
      }
    }
  }

  section {
    title   = "Module Outputs"
    content = <<-END
      The following attributes are exported in the outputs of the module:
    END

    output "module_enabled" {
      type        = bool
      description = <<-END
          Whether this module is enabled.
        END
    }

    output "module_tags" {
      type        = map(string)
      description = <<-END
        The map of tags that are being applied to all created resources that accept tags.
      END
    }
  }

  section {
    title = "External Documentation"

    section {
      title   = "AWS Documentation IAM"
      content = <<-END
        - https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html
        - https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies.html
        - https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2_instance-profiles.html
      END
    }

    section {
      title   = "Terraform AWS Provider Documentation"
      content = <<-END
        - https://www.terraform.io/docs/providers/aws/r/iam_role.html
        - https://www.terraform.io/docs/providers/aws/r/iam_role_policy.html
        - https://www.terraform.io/docs/providers/aws/r/iam_role_policy_attachment.html
        - https://www.terraform.io/docs/providers/aws/r/iam_instance_profile.html
      END
    }
  }

  section {
    title   = "Module Versioning"
    content = <<-END
      This Module follows the principles of [Semantic Versioning (SemVer)].

      Given a version number `MAJOR.MINOR.PATCH`, we increment the:

      1. `MAJOR` version when we make incompatible changes,
      2. `MINOR` version when we add functionality in a backwards compatible manner, and
      3. `PATCH` version when we make backwards compatible bug fixes.
    END

    section {
      title   = "Backwards compatibility in `0.0.z` and `0.y.z` version"
      content = <<-END
        - Backwards compatibility in versions `0.0.z` is **not guaranteed** when `z` is increased. (Initial development)
        - Backwards compatibility in versions `0.y.z` is **not guaranteed** when `y` is increased. (Pre-release)
      END
    }
  }

  section {
    title   = "About Mineiros"
    content = <<-END
      [Mineiros][homepage] is a remote-first company headquartered in Berlin, Germany
      that solves development, automation and security challenges in cloud infrastructure.

      Our vision is to massively reduce time and overhead for teams to manage and
      deploy production-grade and secure cloud infrastructure.

      We offer commercial support for all of our modules and encourage you to reach out
      if you have any questions or need help. Feel free to email us at [hello@mineiros.io] or join our
      [Community Slack channel][slack].
    END
  }

  section {
    title   = "Reporting Issues"
    content = <<-END
      We use GitHub [Issues] to track community reported issues and missing features.
    END
  }

  section {
    title   = "Contributing"
    content = <<-END
      Contributions are always encouraged and welcome! For the process of accepting changes, we use
      [Pull Requests]. If you'd like more information, please see our [Contribution Guidelines].
    END
  }

  section {
    title   = "Makefile Targets"
    content = <<-END
      This repository comes with a handy [Makefile].
      Run `make help` to see details on each available target.
    END
  }

  section {
    title   = "License"
    content = <<-END
      [![license][badge-license]][apache20]

      This module is licensed under the Apache License Version 2.0, January 2004.
      Please see [LICENSE] for full details.

      Copyright &copy; 2020-2022 [Mineiros GmbH][homepage]
    END
  }
}

references {
  ref "homepage" {
    value = "https://mineiros.io/?ref=terraform-google-logging-sink"
  }
  ref "hello@mineiros.io" {
    value = " mailto:hello@mineiros.io"
  }
  ref "badge-license" {
    value = "https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg"
  }
  ref "releases-terraform" {
    value = "https://github.com/hashicorp/terraform/releases"
  }
  ref "releases-aws-provider" {
    value = "https://github.com/terraform-providers/terraform-provider-aws/releases"
  }
  ref "apache20" {
    value = "https://opensource.org/licenses/Apache-2.0"
  }
  ref "slack" {
    value = "https://mineiros.io/slack"
  }
  ref "terraform" {
    value = "https://www.terraform.io"
  }
  ref "aws" {
    value = "https://aws.amazon.com/"
  }
  ref "semantic versioning (semver)" {
    value = "https://semver.org/"
  }
  ref "variables.tf" {
    value = "https://github.com/mineiros-io/terraform-google-logging-sink/blob/main/variables.tf"
  }
  ref "examples/" {
    value = "https://github.com/mineiros-io/terraform-google-logging-sink/blob/main/examples"
  }
  ref "issues" {
    value = "https://github.com/mineiros-io/terraform-google-logging-sink/issues"
  }
  ref "license" {
    value = "https://github.com/mineiros-io/terraform-google-logging-sink/blob/main/LICENSE"
  }
  ref "makefile" {
    value = "https://github.com/mineiros-io/terraform-google-logging-sink/blob/main/Makefile"
  }
  ref "pull requests" {
    value = "https://github.com/mineiros-io/terraform-google-logging-sink/pulls"
  }
  ref "contribution guidelines" {
    value = "https://github.com/mineiros-io/terraform-google-logging-sink/blob/main/CONTRIBUTING.md"
  }
}
