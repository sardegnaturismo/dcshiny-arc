# Planning block 

Go to working directory:
`cd <live working dir>/<environment>/<block>`

Terragrunt plan will pickup latest model revision from the git repository configured on terraform.tfvars within the block directory. It will then initialize terraform environment and show desired infrastructures changes.
Run `terragrunt plan` to start planning. Run with `--terragrunt-source-update`to force sources update to latest available revision.


## Local testing, iterating

When testing local version of model (aka *module*) You need to set specific flags to inform terragrunt of the source relative path pointing to the git local working directory.

Assuming your home dir contains "live" and "modules" repositories:

~
 |- live
 |- modules

To plan infrastructure enter live directory, environment, block:

`cd <live working dir>/<environment>/<block>`

i.e. `cd live/prod/common`

Run terragrunt plan specifying the relative path to reach module sources for the block:  

`terragrunt plan --terragrunt-source ../../../modules/<block>`

i.e. `terragrunt plan --terragrunt-source ../../../modules/common`

Run with `--terragrunt-source-update`to force sources update to latest available revision.

# Planning all infrastructure block at once


Terragrunt `plan-all` will pickup latest revision of each infrastructure block, then initialize terraform environment and show desired infrastructures changes.
Change to `live` working directory
`cd live` 

Run `terragrunt plan-all` to start planning. Run with `--terragrunt-source-update`to force sources update to latest available revision from the associated git repository.

## Local testing, iterating

Set source relative path to the git local working directory for module.

Assuming your home dir contains "live" and "modules" repositories:

~
 |- live
 |- modules

To plan-all infrastructure at once enter live directory, environment:

`cd <live working dir>/<environment>`

i.e. `cd live/prod`

Run terragrunt plan-all and set the relative path to the module sources :  

`terragrunt plan-all --terragrunt-source ../../../modules`

Run with `--terragrunt-source-update`to force sources update to latest available revision.

# Applying 

## Single block - latest revision from git module repository  ( branch master)
Enter live directory, environment, block:

`cd <live working dir>/<environment>/<block>`

i.e. `cd live/prod/common`

Run `terragrunt apply`

## Single block - Local testing, iterating
Enter live directory, environment, block:

`cd <live working dir>/<environment>/<block>`

i.e. `cd live/prod/common`

Run `terragrunt apply --terragrunt-source ../../../modules/<block>`

i.e. `terragrunt apply --terragrunt-source ../../../modules/common`

Run with `--terragrunt-source-update`to force sources update to latest available revision.

## All blocks at once - latest revision from git module repository  ( branch master)

Enter live directory, environment, block:


`cd <live working dir>/<environment>/<block>`

i.e. `cd live/prod/common`

Run `terragrunt apply-all`. Run with `--terragrunt-source-update`to force sources update to latest available revision.

## All blocks at once - Local testing, iterating
Enter live directory, environment:

`cd <live working dir>/<environment>`

i.e. `cd live/prod`

Run `terragrunt apply-all --terragrunt-source ../../../modules`
Run with `--terragrunt-source-update` flag to force sources update to the latest available revision.

