#!/bin/bash

./check_env.sh
if [ $? -ne 0 ]; then
  echo "ERROR: Environment check failed. Exiting."
  exit 1
fi


# Navigate to the 01-lambdas directory
cd "01-infrastructure" 
echo "NOTE: Building DynamoDB table and ECR Repository."

terraform init
terraform apply -auto-approve

# Return to the parent directory
cd ..

# Execute the validation script
#./validate.sh


