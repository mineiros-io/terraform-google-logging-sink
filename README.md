[<img src="https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg" width="400"/>](https://mineiros.io/?ref=terraform-google-logging-sink)

[![Build Status](https://github.com/mineiros-io/terraform-google-logging-sink/workflows/Tests/badge.svg)](https://github.com/mineiros-io/terraform-google-logging-sink/actions)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/mineiros-io/terraform-google-logging-sink.svg?label=latest&sort=semver)](https://github.com/mineiros-io/terraform-google-logging-sink/releases)
[![Terraform Version](https://img.shields.io/badge/Terraform-1.x-623CE4.svg?logo=terraform)](https://github.com/hashicorp/terraform/releases)
[![Google Provider Version](https://img.shields.io/badge/google-4-1A73E8.svg?logo=terraform)](https://github.com/terraform-providers/terraform-provider-google/releases)
[![Join Slack](https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack)](https://mineiros.io/slack)

# terraform-google-logging-sink

A [Terraform](https://www.terraform.io) module to create and manage [Google Project Logging Sinks](https://cloud.google.com/logging/docs/reference/v2/rest/v2/projects.sinks).

**_This module supports Terraform version 1
and is compatible with the Terraform AWS Provider version 3._**

This module is part of our Infrastructure as Code (IaC) framework
that enables our users and customers to easily deploy and manage reusable,
secure, and production-grade cloud infrastructure.


- [Module Features](#module-features)
- [Getting Started](#getting-started)
- [Module Argument Reference](#module-argument-reference)
  - [Main Resource Configuration](#main-resource-configuration)
  - [Module Configuration](#module-configuration)
- [Module Outputs](#module-outputs)
- [External Documentation](#external-documentation)
  - [AWS Documentation IAM](#aws-documentation-iam)
  - [Terraform AWS Provider Documentation](#terraform-aws-provider-documentation)
- [Module Versioning](#module-versioning)
  - [Backwards compatibility in `0.0.z` and `0.y.z` version](#backwards-compatibility-in-00z-and-0yz-version)
- [About Mineiros](#about-mineiros)
- [Reporting Issues](#reporting-issues)
- [Contributing](#contributing)
- [Makefile Targets](#makefile-targets)
- [License](#license)

## Module Features

This module implements the following Terraform resources:

- `google_logging_project_sink`

## Getting Started

Most common usage of the module:

```hcl
module "terraform-google-logging-sink" {
  source      = "git@github.com:mineiros-io/terraform-google-logging-sink.git?ref=v0.0.1"

  name        = "my-pubsub-instance-sink"
  destination = "pubsub.googleapis.com/projects/my-project/topics/instance-activity"
}
```

## Module Argument Reference

See [variables.tf] and [examples/] for details and use-cases.

### Main Resource Configuration

- [**`name`**](#var-name): *(**Required** `string`)*<a name="var-name"></a>

  The name of the logging sink.

- [**`destination`**](#var-destination): *(**Required** `string`)*<a name="var-destination"></a>

  The destination of the sink (or, in other words, where logs are written to).

  Can be a Cloud Storage bucket, a PubSub topic, a BigQuery dataset or a Cloud Logging bucket.

  Examples:
  - `"storage.googleapis.com/[GCS_BUCKET]"`
  - `"bigquery.googleapis.com/projects/[PROJECT_ID]/datasets/[DATASET]"`
  - `"pubsub.googleapis.com/projects/[PROJECT_ID]/topics/[TOPIC_ID]"`
  - `"logging.googleapis.com/projects/[PROJECT_ID]]/locations/global/buckets/[BUCKET_ID]"`

  The writer associated with the sink must have access to write to the above resource.

- [**`filter`**](#var-filter): *(Optional `string`)*<a name="var-filter"></a>

  The filter to apply when exporting logs. Only log entries that match the filter are exported.

  See [Advanced Log Filters](https://cloud.google.com/logging/docs/view/building-queries) for information on how to write a filter.

- [**`description`**](#var-description): *(Optional `string`)*<a name="var-description"></a>

  A description of this sink. The maximum length of the description is 8000 characters.

- [**`disabled`**](#var-disabled): *(Optional `bool`)*<a name="var-disabled"></a>

  If set to True, then this sink is disabled and it does not export any log entries.

- [**`project`**](#var-project): *(Optional `string`)*<a name="var-project"></a>

  The ID of the project to create the sink in.

  If omitted and either `var.organization` or `var.folder` are present, no project logging sink is created.

  If omitted and both `var.organization` and `var.folder` are omitted, the project associated with the provider is used.

- [**`unique_writer_identity`**](#var-unique_writer_identity): *(Optional `bool`)*<a name="var-unique_writer_identity"></a>

  Whether or not to create a unique identity associated with this sink.

  If `false` (the default), then the `writer_identity` used is `serviceAccount:cloud-logs@system.gserviceaccount.com`.

  If `true`, then a unique service account is created and used for this sink. If you wish to publish logs across projects or utilize `bigquery_options`, you must set `unique_writer_identity` to true.

  Default is `null`.

- [**`use_partitioned_tables`**](#var-use_partitioned_tables): *(Optional `bool`)*<a name="var-use_partitioned_tables"></a>

  Whether to use [BigQuery's partition tables](https://cloud.google.com/bigquery/docs/partitioned-tables).

  By default, Logging creates dated tables based on the log entries' timestamps, e.g. syslog_20170523. With partitioned tables the date suffix is no longer present and [special query syntax](https://cloud.google.com/bigquery/docs/querying-partitioned-tables)  has to be used instead. In both cases, tables are sharded based on UTC timezone.

  Default is `null`.

- [**`exclusions`**](#var-exclusions): *(Optional `list(exclusion)`)*<a name="var-exclusions"></a>

  Log entries that match any of the exclusion filters will not be exported.

  If a log entry is matched by both filter and one of `exclusion_filters` it will not be exported. Can be repeated multiple times for multiple exclusions.

  Default is `[]`.

  Each `exclusion` object in the list accepts the following attributes:

  - [**`name`**](#attr-exclusions-name): *(**Required** `string`)*<a name="attr-exclusions-name"></a>

    A client-assigned identifier, such as `load-balancer-exclusion`.

    Identifiers are limited to 100 characters and can include only letters, digits, underscores, hyphens, and periods. First character has to be alphanumeric.

    The object accepts the following attributes:

    - [**`description`**](#attr-exclusions-name-description): *(Optional `string`)*<a name="attr-exclusions-name-description"></a>

      A description of this exclusion.

    - [**`filter`**](#attr-exclusions-name-filter): *(**Required** `string`)*<a name="attr-exclusions-name-filter"></a>

      An advanced logs filter that matches the log entries to be excluded. By using the sample function, you can exclude less than 100% of the matching log entries.

      See [Advanced Log Filters](https://cloud.google.com/logging/docs/view/advanced_filters) for information on how to write a filter.

    - [**`disabled`**](#attr-exclusions-name-disabled): *(Optional `bool`)*<a name="attr-exclusions-name-disabled"></a>

      If set to `true`, then this exclusion is disabled and it does not exclude any log entries.

- [**`folder`**](#var-folder): *(Optional `string`)*<a name="var-folder"></a>

  The ID of the folder to create the sink in.

  If omitted, no folder logging sink is created.

  If provided along with `var.project`, only the project logging sink is created.

  Default is `null`.

- [**`organization`**](#var-organization): *(Optional `string`)*<a name="var-organization"></a>

  The ID of the organization to create the sink in.

  If omitted, no organization logging sink is created.

  If provided along with `var.project`, only the project logging sink is created.

  If provided along with `var.folder`, the folder logging sink is created instead.

  Default is `null`.

- [**`include_children`**](#var-include_children): *(Optional `bool`)*<a name="var-include_children"></a>

  Whether or not to include child projects in the sink export.

  If `true`, logs associated with child projects are also exported; otherwise only logs relating to the provided folder or organization are included.

  Default is `null`.

### Module Configuration

- [**`module_enabled`**](#var-module_enabled): *(Optional `bool`)*<a name="var-module_enabled"></a>

  Specifies whether resources in the module will be created.

  Default is `true`.

- [**`module_tags`**](#var-module_tags): *(Optional `map(string)`)*<a name="var-module_tags"></a>

  A map of tags that will be applied to all created resources that accept tags.
  Tags defined with `module_tags` can be overwritten by resource-specific tags.

  Default is `{}`.

  Example:

  ```hcl
  module_tags = {
    environment = "staging"
    team        = "platform"
  }
  ```

- [**`module_timeouts`**](#var-module_timeouts): *(Optional `map(timeout)`)*<a name="var-module_timeouts"></a>

  A map of timeout objects that is keyed by Terraform resource name
  defining timeouts for `create`, `update` and `delete` Terraform operations.

  Supported resources are: `null_resource`, ...

  Example:

  ```hcl
  module_timeouts = {
    null_resource = {
      create = "4m"
      update = "4m"
      delete = "4m"
    }
  }
  ```

  Each `timeout` object in the map accepts the following attributes:

  - [**`create`**](#attr-module_timeouts-create): *(Optional `string`)*<a name="attr-module_timeouts-create"></a>

    Timeout for create operations.

  - [**`update`**](#attr-module_timeouts-update): *(Optional `string`)*<a name="attr-module_timeouts-update"></a>

    Timeout for update operations.

  - [**`delete`**](#attr-module_timeouts-delete): *(Optional `string`)*<a name="attr-module_timeouts-delete"></a>

    Timeout for delete operations.

- [**`module_depends_on`**](#var-module_depends_on): *(Optional `list(dependency)`)*<a name="var-module_depends_on"></a>

  A list of dependencies.
  Any object can be _assigned_ to this list to define a hidden external dependency.

  Default is `[]`.

  Example:

  ```hcl
  module_depends_on = [
    null_resource.name
  ]
  ```

## Module Outputs

The following attributes are exported in the outputs of the module:

- [**`module_enabled`**](#output-module_enabled): *(`bool`)*<a name="output-module_enabled"></a>

  Whether this module is enabled.

- [**`module_tags`**](#output-module_tags): *(`map(string)`)*<a name="output-module_tags"></a>

  The map of tags that are being applied to all created resources that accept tags.

## External Documentation

### AWS Documentation IAM

- https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html
- https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies.html
- https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2_instance-profiles.html

### Terraform AWS Provider Documentation

- https://www.terraform.io/docs/providers/aws/r/iam_role.html
- https://www.terraform.io/docs/providers/aws/r/iam_role_policy.html
- https://www.terraform.io/docs/providers/aws/r/iam_role_policy_attachment.html
- https://www.terraform.io/docs/providers/aws/r/iam_instance_profile.html

## Module Versioning

This Module follows the principles of [Semantic Versioning (SemVer)].

Given a version number `MAJOR.MINOR.PATCH`, we increment the:

1. `MAJOR` version when we make incompatible changes,
2. `MINOR` version when we add functionality in a backwards compatible manner, and
3. `PATCH` version when we make backwards compatible bug fixes.

### Backwards compatibility in `0.0.z` and `0.y.z` version

- Backwards compatibility in versions `0.0.z` is **not guaranteed** when `z` is increased. (Initial development)
- Backwards compatibility in versions `0.y.z` is **not guaranteed** when `y` is increased. (Pre-release)

## About Mineiros

[Mineiros][homepage] is a remote-first company headquartered in Berlin, Germany
that solves development, automation and security challenges in cloud infrastructure.

Our vision is to massively reduce time and overhead for teams to manage and
deploy production-grade and secure cloud infrastructure.

We offer commercial support for all of our modules and encourage you to reach out
if you have any questions or need help. Feel free to email us at [hello@mineiros.io] or join our
[Community Slack channel][slack].

## Reporting Issues

We use GitHub [Issues] to track community reported issues and missing features.

## Contributing

Contributions are always encouraged and welcome! For the process of accepting changes, we use
[Pull Requests]. If you'd like more information, please see our [Contribution Guidelines].

## Makefile Targets

This repository comes with a handy [Makefile].
Run `make help` to see details on each available target.

## License

[![license][badge-license]][apache20]

This module is licensed under the Apache License Version 2.0, January 2004.
Please see [LICENSE] for full details.

Copyright &copy; 2020-2022 [Mineiros GmbH][homepage]


<!-- References -->

[homepage]: https://mineiros.io/?ref=terraform-google-logging-sink
[hello@mineiros.io]: mailto:hello@mineiros.io
[badge-license]: https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg
[releases-terraform]: https://github.com/hashicorp/terraform/releases
[releases-aws-provider]: https://github.com/terraform-providers/terraform-provider-aws/releases
[apache20]: https://opensource.org/licenses/Apache-2.0
[slack]: https://mineiros.io/slack
[terraform]: https://www.terraform.io
[aws]: https://aws.amazon.com/
[semantic versioning (semver)]: https://semver.org/
[variables.tf]: https://github.com/mineiros-io/terraform-google-logging-sink/blob/main/variables.tf
[examples/]: https://github.com/mineiros-io/terraform-google-logging-sink/blob/main/examples
[issues]: https://github.com/mineiros-io/terraform-google-logging-sink/issues
[license]: https://github.com/mineiros-io/terraform-google-logging-sink/blob/main/LICENSE
[makefile]: https://github.com/mineiros-io/terraform-google-logging-sink/blob/main/Makefile
[pull requests]: https://github.com/mineiros-io/terraform-google-logging-sink/pulls
[contribution guidelines]: https://github.com/mineiros-io/terraform-google-logging-sink/blob/main/CONTRIBUTING.md
