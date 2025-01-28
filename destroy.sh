cd "03-apprunner"

echo "NOTE: Destroying app runner instance."

terraform init
terraform destroy -auto-approve

cd ..

echo "NOTE: Deleting ECR repository contents."

ECR_REPOSITORY_NAME="flask-app"
aws ecr delete-repository --repository-name $ECR_REPOSITORY_NAME --force




