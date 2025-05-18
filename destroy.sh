export AWS_DEFAULT_REGION=us-east-2

cd "03-apprunner"

echo "NOTE: Destroying app runner instance."

if [ ! -d ".terraform" ]; then
    terraform init
fi
terraform destroy -auto-approve
rm -f -r terraform* .terraform*

cd ..

echo "NOTE: Deleting ECR repository contents."

ECR_REPOSITORY_NAME="flask-app"
aws ecr delete-repository --repository-name $ECR_REPOSITORY_NAME --force

cd 01-ecr
rm -f -r terraform* .terraform*
cd ..




