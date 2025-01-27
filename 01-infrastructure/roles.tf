resource "aws_iam_role" "app_runner_role" {
 name               = "app-runner-role" # Name of the IAM Role
 assume_role_policy = jsonencode({    
   Version = "2012-10-17",
   Statement = [
     {
       Effect = "Allow",              
       Principal = {
         Service = "apprunner.amazonaws.com"
       },
       Action = "sts:AssumeRole"       # Action to assume the role
     }
   ]
 })
}

resource "aws_iam_role_policy" "app_runner_policy" {
 name   = "app-runner-policy"               # Name of the policy
 role   = aws_iam_role.app_runner_role.id   # Attach the policy to the IAM role
 policy = jsonencode({                      # Define the policy document in JSON format
   Version = "2012-10-17",
   Statement = [
     {
       Action   = [                         # List of actions allowed on the DynamoDB table
         "dynamodb:Query",                  # Allow querying the table
         "dynamodb:PutItem",                # Allow adding items to the table
         "dynamodb:Scan"                    # Allow scanning the table
       ],
       Effect   = "Allow",                  # Grant the specified permissions
       Resource = "${aws_dynamodb_table.candidate-table.arn}" # Reference the table's ARN
     }
   ]
 })
}
