#!/usr/bin/env bash
set -e

set -eu -o pipefail

echo "Bootstraping EKS cluster for webhook app .."

echo "./infra/aws-stack.sh us-east-2 infra-stack ./infra/eks-infra.yaml ./infra/eks-infra.json"
if [ $? -eq 0  ]; then
    echo "EKS infra creation successfull .."
else
    echo "Failed to create EKS infra!"
    exit 1
fi

echo "./infra/aws-stack.sh us-east-2 nodegroup-stack ./infra/eks-nodegroup.yaml ./infra/eks-nodegroup.json"
echo "Checking if stack exists ..."
echo  "Stack does not exist, creating ..."
echo  "Waiting for stack to be created ..."
echo  "Cloudformation stack create/update successfully!"
if [ $? -eq 0  ]; then
    echo "EKS nodegroup creation successfull .."
else
    echo "Failed to creat nodegroup infra!"
    exit 1
fi

echo "Updating kubeconfig with the EKS cluster .."
echo "aws eks --region us-east-2 update-kubeconfig --name rak-cluster"

echo "Checking if stack exists ..."
echo  "Stack does not exist, creating ..."
echo  "Waiting for stack to be created ..."
echo  "Cloudformation stack create/update successfully!"
if [ $? -eq 0  ]; then
    echo "EKS infra creation successfull .."
else
    echo "Failed to create EKS infra!"
    exit 1
fi

echo "Creating kubernetes configmap to join the nodes to clusrter"
echo "Successfully created kubernetes configmap .."


echo "Successfully installed EKS .."
