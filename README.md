# Terragrunt configuration for a multi-AWS account ECS cluster on self managed EC2 instances. A DRY, test-driven modular example of infrastructure as code
-------------------------

Kubernetes

Organising terraform code across large teams can be difficult.

We often find that making changes to configuration requires *changes in multiple places*. Referencing values created by other terraform modules can also be tough. 

Infrastructure changes need to be *fast, reliable and easy for development teams to implement*. Rolling back should be straight forwards too.

Teragrunt is way to write code that meets these demands with the simplicity of only having to configure the *absolute minimum* in a [unit.](https://terragrunt-v1.gruntwork.io/docs/features/units/) 

> **Note:** Each unit is a directory of terraform code and a `terragrunt.hcl` file.  
> Anything you need to use in more than one `terragrunt.hcl` file can be kept DRY in the `_env` folder.

You can also easily *reference values from other units* through [includes](https://terragrunt-v1.gruntwork.io/docs/features/includes/)

As a result, Terragrunt allows organisations to *easily share modules* with company standards built in. The users of these modules only configure the *absolute minimum* and don't need to repeat themselves.

Problem

Terratest 


