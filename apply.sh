#!/bin/bash

./check_env.sh
if [ $? -ne 0 ]; then
  echo "ERROR: Environment check failed. Exiting."
  exit 1
fi


# Navigate to the 01-ecr directory
cd "01-ecr" 
echo "NOTE: Building ECR Repository."

terraform init
terraform apply -auto-approve

# Return to the parent directory
cd ..

# Navigate to the 02-docker directory

cd "02-docker"
echo "NOTE: Building flask container with Docker."

# Retrieve the AWS Account ID using the AWS CLI.
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)

# Authenticate Docker to AWS ECR using the retrieved credentials.
aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.us-east-2.amazonaws.com

# Build and push the Docker image.
# The image tag includes the AWS Account ID and the specified repository and tag.

docker build -t ${AWS_ACCOUNT_ID}.dkr.ecr.us-east-2.amazonaws.com/flask-app:flask-app-rc1 . --push

cd ..

# Navigate to the 03-apprunner directory
cd 03-apprunner
echo "NOTE: Building apprunner instance and deploy flask container."

terraform init
terraform apply -auto-approve

# Return to the parent directory
cd ..

# Execute the validation script
#./validate.sh


