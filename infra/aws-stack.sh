#!/usr/bin/env bash
set -u

usage="Usage: $(basename "$0") region stack-name cfn_template json_parameters
where:
  region            - the AWS region
  stack-name        - the stack name
  aws-cli-opts      - extra options passed directly to create-stack/update-stack
  cfn_template      - cloudformation template to create a stack
  json_parameters   - parameters for cloudformation template in json format
"

if [ "$1" == "-h" ] || [ "$1" == "--help" ] || [ "$1" == "help" ] || [ "$1" == "usage" ] ; then
  echo "$usage"
  exit -1
fi

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] ; then
  echo "$usage"
  exit -1
fi

shopt -s failglob
set -eu -o pipefail

echo "Checking if stack exists ..."

if ! aws cloudformation describe-stacks --region $1 --stack-name $2 ; then

  echo -e "\nStack does not exist, creating ..."
  output=$( aws cloudformation create-stack \
    --region $1 \
	--stack-name $2\
	--template-body file:\/\/$3 \
    --parameters file:\/\/$4 --capabilities "CAPABILITY_IAM" "CAPABILITY_NAMED_IAM" )

  echo "Waiting for stack to be created ..."
  aws cloudformation wait stack-create-complete \
    --region $1 \
    --stack-name $2 \

else

  echo -e "\nStack exists, attempting update ..."

  set +e
  output=$( aws cloudformation update-stack \
    --region $1 \
	--stack-name $2\
	--template-body file:\/\/$3 \
	--parameters file:\/\/$4 --capabilities "CAPABILITY_IAM" "CAPABILITY_NAMED_IAM" )
  status=$?
  set -e

  echo "$output"

  if [ $status -ne 0 ] ; then

    # Don't fail for no-op update
    if [[ $output == *"ValidationError"* && $output == *"No updates"* ]] ; then
      echo -e "\nFinished create/update - no updates to be performed"
      exit 0
    else
      exit $status
    fi

  fi

  echo "Waiting for stack update to complete ..."
  aws cloudformation wait stack-update-complete \
    --region $1 \
    --stack-name $2 \

fi

echo "Cloudformation stack create/update successfully!"
