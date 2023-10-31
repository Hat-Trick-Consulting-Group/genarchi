# Terraform

## Tutorials

Tutorials can be found at these adresses:

 - Terraform basics:
https://developer.hashicorp.com/terraform/tutorials

 - Platform 2 deployement:
https://devopssec.fr/article/construire-infrastructure-aws-hautement-disponible-terraform#begin-article-section

A terraform lab can be found in the tutorial folder.

### Basics
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

### Few words on architecture of a terraform project:

After a terraform init:
- the file .terraform contains all the providers T's downloaded for init
- the file .terraform.lock.hcl specifies the exact provider version used

After a terraform apply:
- the file terraform.tfstate contains data of the configuration applied which is used by T to track which ressources it manages and sensitive info about these ressources.

## Plateform 2

Everything related to the plateform 2 deployment is in the P2 folder.

TODO

## Plateform 3

Everything related to the plateform 3 deployment is in the P3 folder.

TODO