# GitHub Actions Runner Infrastructure

This repo sets up the infrastructure we use to host our private Actions runners, and configures the runners on the infrastructure.
The runners are hosted on an Azure Kubernetes Service (AKS) cluster.

We use Terraform and Terragrunt to deploy this infrastructure in two stages.
The first stage (called `azure` in the source code) sets up the AKS cluster and other Azure resources it needs to operate.
The second stage (called `kubernetes`) configures services in the cluster such as cert manager and external-dns, as well as setting up our [actions runner controller](https://github.com/actions-runner-controller/actions-runner-controller).
Terragrunt is used to route outputs from the first stage into the second stage.

#### Configuration
Our runners are configured at the Enterprise level in GitHub.
We have three different runner types available: terraform, nodejs, and dotnet.
The images used in these runners can be found in the [runner-images](https://github.com/liatrio-enterprise/runner-images) repository.

#### Workflows
For each stage there is a plan and an apply workflow. `plan` runs when a PR to `main` that changes a stage's files is created, and `apply` runs upon a merge to main that changes a stage's files.

#### Requirements
For this configuration to run, an Azure Service Principal with `Contributor` access to a subscription and `Application Administrator` in AAD is needed.

A GitHub Personal Access Token (PAT) with the following permissions is required: `admin:org, admin:org_hook, admin:repo_hook, manage_runners:enterprise, repo, workflow, write:packages`
