#!/bin/bash
bash read.sh

echo "Enter your Mater Instance Type"

read masterinsta

echo "Enter your Node Instance Type"

read nodeinsta

echo " Enter Node count"

read ncount

cd aws-vpc/

terraform init

terraform apply --var-file example.tfvars -auto-approve

sleep 60s

terraform output vpc > ../vpcid.txt
terraform output subnets | awk {'print $1'} | sed '$d' | sed "1d" |  sed 's/^.//' | sed 's/..$//' | paste -sd "," - > ../subnets.txt

cd ..



names=$(cat clustername.txt)
mzoness=$(cat mzones.txt)
nzoness=$(cat zones.txt)
vpcid=$(cat vpcid.txt)
publicsubnet=$(cat subnets.txt)
hostedzoneroute=$(cat route53zone.txt)

echo "Your cluster name is $names"
echo "your zones are $zoness"
echo "your VPCID is $vpcid"

cd aws-s3/

terraform init

terraform apply --var-file s3.tfvars -auto-approve

sleep 20s

terraform output state_store > ../stores.txt

cd ..

statestore=$(cat stores.txt)


export NAME=$names
export KOPS_STATE_STORE=$statestore

echo $NAME
echo $KOPS_STATE_STORE

echo "Please wait !! Your cluster will be ready in a few minutes"


kops create cluster \
    --master-zones $mzoness \
    --zones $nzoness \
    --master-size $masterinsta \
    --node-size $nodeinsta \
    --node-count $ncount \
    --topology private \
    --dns-zone $hostedzoneroute \
    --networking flannel \
    --vpc $vpcid \
    --out=. \
    ${NAME}

echo "1: You can continue to edit the cluster and change the subnets: kops edit cluster --name $names --state $statestore"
echo "2: After editing the cluster, please update the cluster: kops update cluster --name $names --state $statestore --yes "
echo "3: validate the cluster: kops validate cluster --name $names --state $statestore"
