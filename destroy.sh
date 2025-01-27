# Navigate to the 01-lambdas directory
cd "01-infrastructure"

# Initialize and apply Terraform configuration
echo "NOTE: Destroying DynamoDB table and ECR Repository."

terraform init
terraform destroy -auto-approve

# Return to the parent directory
cd ..

