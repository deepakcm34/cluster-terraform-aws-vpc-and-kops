#!/bin/bash

echo "Enter your Region"

read reg 

echo "Enter your First Zone"

read zonea

echo "Enter your Second Zone"

read zoneb

echo "Enter your Third Zone"

read zonec

echo "Enter your environment"

read env

echo "Enter your route53 zonename"

read name

echo "Enter your VPC name"

read vpcname

echo $name > route53zone.txt
echo "$env.$name" > clustername.txt
echo $zonea > mzones.txt
echo "$zonea,$zoneb,$zonec" > zones.txt
sed -i "s|ENVIRONMENT|$env|g" aws-s3/s3.tfvars
sed -i "s|TYPENAME|$name|g" aws-s3/s3.tfvars
sed -i "s|REG|$reg|g" aws-vpc/example.tfvars
sed -i "s|REG|$reg|g" aws-s3/s3.tfvars
sed -i "s|REGa|$zonea|g" aws-vpc/example.tfvars
sed -i "s|REGb|$zoneb|g" aws-vpc/example.tfvars
sed -i "s|REGc|$zonec|g" aws-vpc/example.tfvars
sed -i "s|VPCNAME|$vpcname|g" aws-vpc/example.tfvars
