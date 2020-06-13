# cluster-terraform-aws-vpc-and-kops

build kubernetes cluster in an existing VPC using kops (Terraform-aws-vpc and kops)


The folder "es-yamls" contains the yaml files to build the elastic cluster

The folder "kibana-yamls" contains the fluentd and kibana deployment yamls

The folder "wordpress-yamls" contains the wordpress yamls

The folder "aws-s3" contains terraform files to build a s3 bucket

The folder "aws-vpc" contains terraform files to build a VPC

There are 4 bash scripts present under this repo. 

1: init.sh > This script will help you to build the s3 bucket, VPC and the kubernetes cluster using Kops 

2: read.sh > This script will ask you the details in-order to build the s3 bucket, VPC and the kubernetes cluster. You do not need to run the this script "read.sh" directly. The script will be automatically run when you initiate the script "init.sh"

3: deployments.sh > This script will deploy the EFK and wordpress using the yamls files present under the folders "es-yamls,kibana-yamls,wordpress-yamls".

4: destroy-cluster.sh > This script will help you to destroy the entire infra (cluster, VPC, s3).


# The things you need to setup before initiating the script:


1: Create a bastion host in your AWS account.

2: Configure the aws in the bastion host using the access and secret key.

3: Install the Terraform v0.12.26 in the bastion host

4: Add a zone in the route53

5: Install kops (Refer https://kubernetes.io/docs/setup/production-environment/tools/kops/)

Once you setup all the above 5, you can clone the git repo to your bastion host.

