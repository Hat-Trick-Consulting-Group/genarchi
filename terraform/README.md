# Terraform

## Plateform 2

Everything related to the plateform 2 deployment is in the P2 folder [here](P2/README.md).

---------

## Plateform 3

Everything related to the plateform 3 deployment is in the P3 folder [here](P3/README.md).

----------

# DOC FOR DEVS
## Tutorials

Tutorials can be found at these adresses:

 - Terraform basics:
https://developer.hashicorp.com/terraform/tutorials

 - Platform 2 deployement:
https://devopssec.fr/article/construire-infrastructure-aws-hautement-disponible-terraform#begin-article-section

A terraform lab can be found in the tutorial folder.

---------

### Basics
DON'T FORGET TO EXPORT THESE VARIABLES:
1.  AWS_ACCESS_KEY_ID
2.  AWS_SECRET_ACCESS_KEY

To start a terraform project:
- Create a .tf file (ex main.tf) and write your IaC stuff inside
- Run
```
terraform validate
```
to check if the config file is valid.
- Run
```
terraform fmt
```
to format the configuration file(s) (we are not pigs)
- Run 
```
terraform init
```
to initialize the terraform project.
- Run 
```
terraform apply
```
to launch the terraform script
- Run 
```
terraform show
```
to inspect the current state

- Run 
```
terraform state list
```
to list of the ressources in your project's state

- Run
```
terraform destroy
```
to destroy the result of the terraform script.

---------
### Few words on architecture of a terraform project:

After a terraform init:
- the file .terraform contains all the providers T's downloaded for init
- the file .terraform.lock.hcl specifies the exact provider version used

After a terraform apply:
- the file terraform.tfstate contains data of the configuration applied which is used by T to track which ressources it manages and sensitive info about these ressources.

----------

## Tips

### Use env variables in Terraform

For Terraform variables, there are two options:

1. You can define them in the `output.tf` file located within a module (e.g., `modules/vpc/output.tf`).
2. You can define them in the `vars.tf` file at the root of the project.

To use these variables within modules, you should create a `variables.tf` file (e.g., `modules/asg_alb/variables.tf`) and add the variable name in it.

---------

