#!/usr/bin/env bash
set -e

usage="Usage: bash $(basename "$0") | ./$(basename "$0") | sh $(basename "$0")
    Any arguments passed will be discarded ..
"

if [ "$1" == "-h" ] || [ "$1" == "--help" ] || [ "$1" == "help" ] || [ "$1" == "usage" ] ; then
  echo "$usage"
  exit -1
fi

region=`aws configure get region`
if [ -z "${REGION}"  ]
then
    region=${REGION}
else
    echo "REGION input is not defined using configured region .."
    region=`aws configure get region`
fi


shopt -s failglob
set -eu -o pipefail

echo "Bootstraping EKS cluster for webhook app .."


cloudformation/aws-stack.sh $region infra-stack eks-infra.yaml eks-infra.json
if [ $? -eq 0  ]; then
    echo "EKS infra creation successfull .."
else
    echo "Failed to create EKS infra!"
    exit 1
fi

cloudformation/aws-stack.sh $region nodegroup-stack eks-nodegroup.yaml eks-nodegroup.json
if [ $? -eq 0  ]; then
    echo "EKS nodegroup creation successfull .."
else
    echo "Failed to creat nodegroup infra!"
    exit 1
fi

echo "Updating kubeconfig with the EKS cluster .."
aws eks --region us-east-2 update-kubeconfig --name rak-cluster

aws_iam_arn=`aws cloudformation describe-stacks --stack-name nodegroup-stack | jq '.Stacks[].Outputs[] | select(.OutputKey=="NodeInstanceRole") | .OutputValue'`

sed -i "s~aws_iam_arn~`echo $aws_iam_arn | sed -e 's/^"//' -e 's/"$//'`~g" cloudformation/aws-auth-cm.yaml

if [ $? -eq 0  ]; then
    echo "EKS infra creation successfull .."
else
    echo "Failed to create EKS infra!"
    exit 1
fi

kubectl apply -f aws-auth-cm.yaml

sleep 60

echo "Successfully installed EKS .."

