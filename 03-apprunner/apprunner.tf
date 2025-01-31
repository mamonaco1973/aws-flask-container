# AWS App Runner Service configuration
resource "aws_apprunner_service" "flask_app" {
  # Name of the App Runner service
  service_name = "flask-app-runner"

  # Source configuration block for the service
  source_configuration {
    # Authentication configuration for accessing the image repository
    authentication_configuration {
      # Role ARN used by App Runner to pull the image from the ECR repository
      access_role_arn = aws_iam_role.app_runner_build_role.arn
    }

    # Image repository configuration for the service
    image_repository {
      # Fully qualified ECR image identifier, dynamically using the current account ID and region
      image_identifier = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com/flask-app:flask-app-${var.image_version}"

      # Specifies that the image repository is hosted in Amazon Elastic Container Registry (ECR)
      image_repository_type = "ECR"

      # Configuration for the container image
      image_configuration {
        # Port on which the container listens for HTTP traffic
        port = "8000"
      }
    }
  }

  # Instance configuration for the service
  instance_configuration {
    # Specifies the amount of CPU allocated to each instance
    cpu = "1 vCPU"

    # Specifies the amount of memory allocated to each instance
    memory = "2 GB"

    # Role ARN used by the service instances for runtime permissions
    instance_role_arn = aws_iam_role.app_runner_run_role.arn
  }

  # Network configuration for the App Runner service
  network_configuration {
    # Outbound traffic configuration
    egress_configuration {
      # Uses the default egress type, which routes traffic through the App Runner-managed VPC
      egress_type = "DEFAULT"
    }

    # Inbound traffic configuration
    ingress_configuration {
      # Allows the service to be publicly accessible
      is_publicly_accessible = true
    }
  }

  # Health check configuration for the App Runner service
  health_check_configuration {
    # Protocol used for health checks (HTTP or HTTPS)
    protocol = "HTTP"

    # Path used for health check requests
    path = "/gtg"

    # Interval in seconds between health checks
    interval = 10

    # Timeout in seconds for each health check request
    timeout = 5

    # Number of consecutive successful health checks required to consider the service healthy
    healthy_threshold = 1

    # Number of consecutive failed health checks required to consider the service unhealthy
    unhealthy_threshold = 5
  }
}
