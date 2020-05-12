# Capstone-CloudDevOps
Capstone- Cloud DevOps project

> Cloud DevOps Nanodegree program Capstone Project.

## Project Tasks:

* Docker image of the webhook app which will be used for this project
* kubernets deployment and service files
* AWS infrastructure to host the application [VPC, EKS, EC2, ELB, SG ..]
* Cloudformation templates to spin up AWS EKS cluster
* Jenkins pipeline project to manage the CI and CD
* Rolling upgrade of kubernets deployment to make sure there is minimum downtime with the upgrade

## Project tech stack:

* Docker
* Kubernetes
* AWS
* Jenkins
* python3

## The files included are:
```sh
* README.md
* webhook    
  - app_flask.py              Slack webhook application
* Dockerfile                  To build the docker image
* kubernetes                  Kubernetes deployment and service files
  - webhook-deployment.yaml
  - webhook-service.yaml
* Makefile                    Makefile to bootstrap virtual env to run the app
* jenkins                     
  - Jenkinsfile_CD_install      Jenkins pipeline file for install CD
  - Jenkinsfile_CD_upgrade      Jenkins pipeline file for upgrade CD
  - Jenkinsfile_CI              Jenkins pipeline file for infra and image build CI
* test
  - test.py                   test.py to run health check
* requirements.txt            requirements.txt for the app
* infra                       Cloudformation templates and bash script to bootstrap AWS EKS env
  - hms-bootstrap.sh          Bash script to bootstrap AWS EKS
  - eks-infra.yaml            CF template for EKS cluster creation
  - eks-infra.json            EKS cluster CF params
  - eks-nodegroup.yaml        CF template for EKS nodegroup creation
  - eks-nodegroup.json        EKS nodegroup CF params
  - aws-auth-cm.yaml          Configmap to configure nodegroup to cluster
  - aws-stack.sh              Bash script to create cloudformation stacks
* images                      Screenshots of various tasks performed in the project
```
