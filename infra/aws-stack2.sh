#!/bin/bash
#set -x

api_stack_name="awsprojectspringboot"
#$API_STACK_NAME
api_region="us-east-1"
#$API_REGION

type_formation=""

if ! aws cloudformation describe-stacks --region $api_region --stack-name $api_stack_name ; then
        echo "1"
            type_formation='create-stack'
        else
                type_formation='update-stack'
fi

declare -A parameters

#Se asigna key=value
parameters["EnvironmentName"]="dev"
#$ENVIRONMENT_NAME
parameters["AppName"]="awsprojectspringboot"
#$APP_NAME
parameters["AppImage"]="aws-project-springboot"
#$APP_IMAGE
parameters["AppImageTag"]="latest"
#$APP_IMAGE_TAG
parameters["AppDesiredCount"]=1
#$APP_DESIRED_COUNT
#parameters["SpringCloudConfigServerGitUsername"]=$SPRING_CLOUD_CONFIG_SERVER_GIT_USERNAME
#parameters["SpringCloudConfigServerGitPassword"]=$SPRING_CLOUD_CONFIG_SERVER_GIT_PASSWORD
#parameters["SpringCloudConfigServerGitUri"]=$SPRING_CLOUD_CONFIG_SERVER_GIT_URI
parameters["ApiVpcId"]="vpc-2ec5f255"
#$API_VPC_ID
parameters["VpcSubnets"]='"subnet-e2ef15cc\,subnet-c1be469d"'
#$VPC_SUBNETS
parameters["EcsAmiId"]="ami-04351e12"
#"ami-5253c32d"
parameters["EcsInstanceType"]="t2.small"
#$ECS_AMI_ID
#parameters["AlbAcmCertificate"]=$ALB_ACM_CERTIFICATE

file='api_ecs_cloud_formation.template.cf.yaml'

sed -i -- 's/ApiStackName-/'$api_stack_name'/g' $file

#se hace concatenacion de los parametros
s_parameters=''
for i in "${!parameters[@]}" ; do
        s_parameters=$s_parameters' '$(printf "ParameterKey=%s,ParameterValue=%s" $i ${parameters[${i}]})
    done

    echo "======================================== CREACION / ACTUALIZACION DEL STACK "
    eval "aws --region $api_region cloudformation $type_formation --stack-name $api_stack_name --template-body 'file://$file' --parameters $s_parameters"
    echo "======================================== VERIFICACION DEL STACK "
    exec aws --region $api_region cloudformation describe-stacks --stack-name $api_stack_name
