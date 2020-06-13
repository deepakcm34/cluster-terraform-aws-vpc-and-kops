# Cluster-terraform-aws-vpc-and-kops

Build kubernetes cluster in an existing VPC using kops (Terraform-aws-vpc and kops)


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

git clone https://github.com/deepakcm34/cluster-terraform-aws-vpc-and-kops.git

Please follow the below steps to build the infra :

1 : Execute the bash script "init.sh" : ./init.sh

    The script "init.sh" will ask you to enter the variables which need to build the cluster,s3 bucket and VPC using another script "read.sh"(eg: region,instance type etc). Once you enter the details, the bash script "read.sh" will replace the variables in the terraform tf/tfvars files and also write some values to the txt files. After that, "init.sh" will first execute the terraform under "aws-vpc" where the VPC tf files are placed. Once the VPC creation completes.
   
    After the VPC is created, the terraform tf/tfvars files under aws-s3 will be executed in-order to create the s3 bucket.
   
    Finally the script will execute the kops command in-order to build the kubernetes cluster.
   
2 : When the kops command executes, we only mentione the vpc id. The cluster will be assign to the VPC, but the subnets and the cidr will be different and if we did not change those values, it will conflicts with the existing subnets.

 In-order to avoid the conflict, we need to manually edit the cluster and change the subnet field.
 
 kops edit cluster --name clustername --state s3-bucket-state-store 
 
 subnets map should look something like this:
 
subnets:
  - cidr: 10.0.32.0/19
    name: us-east-1a
    type: Private
    zone: us-east-1a
  - cidr: 10.0.64.0/19
    name: us-east-1b
    type: Private
    zone: us-east-1b
  - cidr: 10.0.96.0/19
    name: us-east-1c
    type: Private
    zone: us-east-1c
  - cidr: 10.0.0.0/22
    name: utility-us-east-1a
    type: Utility
    zone: us-east-1a
  - cidr: 10.0.4.0/22
    name: utility-us-east-1b
    type: Utility
    zone: us-east-1b
  - cidr: 10.0.8.0/22
    name: utility-us-east-1c
    type: Utility
    zone: us-east-1c
   
 There should be one Private type subnet and one Utility (public) type subnet in each availability zone. We need to modify this section by replacing each cidr with the corresponding existing subnet ID for that region. For the Private subnets, we also need to specify our NAT gateway ID in an egress key. Modify your subnets section to look like this:
 
 subnets:
  - egress: nat-0d0e915d4f79fedae
    id: subnet-08f9639ba62029698
    name: us-east-1a
    type: Private
    zone: us-east-1a
  - egress: nat-00b31045cc8b0ab4d
    id: subnet-04426beb64cc855fa
    name: us-east-1b
    type: Private
    zone: us-east-1b
  - egress: nat-0f9369d8dfe7db024
    id: subnet-04753570cfa98260d
    name: us-east-1c
    type: Private
    zone: us-east-1c
  - id: subnet-0e98bb2241c30f050
    name: utility-us-east-1a
    type: Utility
    zone: us-east-1a
  - id: subnet-02a3be7863e7b405d
    name: utility-us-east-1b
    type: Utility
    zone: us-east-1b
  - id: subnet-0c96e1c521ad5b3a4
    name: utility-us-east-1c
    type: Utility
    zone: us-east-1c
   
 The IDs will be different, you can get the ids from the AWS or from the terraform output.
 
 Save the config after the change
 
3: Update the cluster , so that the changes will be applied and will build the cluster:

 kops update cluster --name clustername --state s3-bucket-state-store --yes
 
4: Validate the cluster:

 kops validate cluster --name clustername --state s3-bucket-state-store
 
 It might take a few minutes in-order to complete the setup.
 
5: Once the validation is successful, you can run the script "deployments.sh" in-order to deploy the EFK and Wordpress

#NB: Replace clustername with original cluster anme and the s3-bucket-state-store with original state store while runnig edit,update,validate etc

# Destroy the cluster:

Run the script destroy-cluster.sh in-order to destroy everything you built..
