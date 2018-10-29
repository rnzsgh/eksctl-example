#!/bin/bash

AWS_REGION=us-east-1

# Note: this is the GPU optimized AMI in us-east-1 - 10/29/2018
EKS_AMI=ami-058bfb8c236caae89

NODE_INSTANCE=p2.xlarge

NODE_COUNT=1

CLUSTER_NAME=eks-gpu

# Size in GB
NODE_VOLUME_SIZE=200

ZONES=us-east-1a,us-east-1c,us-east-1d,us-east-1f

# Public key
SSH_KEY=$HOME/.ssh/id_rsa.pub

# Timeout in minutes
TIMEOUT=60m

mkdir -p $HOME/bin

# Pull down the latest version of eksctl
curl --silent --location "https://github.com/weaveworks/eksctl/releases/download/latest_release/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
mv /tmp/eksctl $HOME/bin
chmod +x ~/bin/eksctl

curl -sS -o $HOME/bin/aws-iam-authenticator "https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-07-26/bin/$(uname -s | awk '{print tolower($0)}')/amd64/aws-iam-authenticator"

curl -sS -o $HOME/bin/kubectl "https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-07-26/bin/$(uname -s | awk '{print tolower($0)}')/amd64/kubectl"

chmod +x $HOME/bin/aws-iam-authenticator $HOME/bin/kubectl

export PATH=$HOME/bin:$PATH

eksctl version

eksctl create cluster --name=$CLUSTER_NAME \
                      --nodes=$NODE_COUNT \
                      --ssh-access \
                      --full-ecr-access \
                      --timeout=$TIMEOUT \
                      --ssh-public-key=$SSH_KEY \
                      --node-type=$NODE_INSTANCE \
                      --node-ami=$EKS_AMI \
                      --region=$AWS_REGION \
                      --node-volume-size=$NODE_VOLUME_SIZE \
                      --zones=$ZONES


