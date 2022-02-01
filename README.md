# Github Runner Infrastructure
 This repository sets up an AKS cluster and installs Github runners on the cluster.

 ### Prerequisites
 ---
 For the `azurerm` provider, you will need to first authenticate with Azure via `az login` or include the Azure Environment Variables:
```shell
ARM_CLIENT_ID
ARM_CLIENT_SECRET
ARM_SUBSCRIPTION_ID
ARM_TENANT_ID
```
You also need to provide the `GHE_PAT` (PAT) for the GitHub API with the `admin:repo_hook, manage_runners:enterprise, repo, workflow, write:packages` scopes assigned.

### Set up
---

### Usage
---
