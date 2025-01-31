
#!/bin/bash

# Fetch the default domain of the App Runner service
SERVICE_NAME="flask-app-runner"
SERVICE_URL=$(aws apprunner list-services --query "ServiceSummaryList[?ServiceName=='$SERVICE_NAME'].ServiceUrl" --output text)

# Check if the SERVICE_URL is empty
if [[ -z "$SERVICE_URL" || "$SERVICE_URL" == "None" ]]; then
  echo "ERROR: Default domain for App Runner service '$SERVICE_NAME' could not be retrieved. Please check if the service exists and try again."
  exit 1
fi

cd ./02-docker
SERVICE_URL="https://$SERVICE_URL"
echo "NOTE: Testing the App Runner Solution."
echo "NOTE: URL for App Runner Solution is $SERVICE_URL/gtg?details=true"
./test_candidates.py $SERVICE_URL

cd ..
