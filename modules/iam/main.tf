data "aws_iam_policy_document" "coachx_lambda_role_policy" {
    statement {
      effect = "Allow"

      principals {
        type = "Service"
        identifiers = ["lambda.amazonaws.com"]
      }

      actions = ["sts:AssumeRole"]
    }
  
}

resource "aws_iam_role" "coachx_auth_role" {
    name = "dev-coachx-auth-role-lnccyhfz"  
    path = "/service-role/"
    assume_role_policy = data.aws_iam_policy_document.coachx_lambda_role_policy.json
    }

resource "aws_iam_role_policy_attachment" "policy_attach" {
  role = aws_iam_role.coachx_auth_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}


resource "aws_iam_role" "coachx_email_service_role" {
    name = "coachx-email-service-role-wy9z8k03"  
    path = "/service-role/"
    assume_role_policy = data.aws_iam_policy_document.coachx_lambda_role_policy.json
    }

resource "aws_iam_role" "coachx_analytics_service_role" {
    name = "coachx-analytics-role-xgiqfyhi"  
    path = "/service-role/"
    assume_role_policy = data.aws_iam_policy_document.coachx_lambda_role_policy.json
    }

resource "aws_iam_role" "coachx_assistant_service_role" {
    name = "dev-coachx-assistant-service-role-sji7hm8l"
    managed_policy_arns = ["arn:aws:iam::0XXXXX*****9:policy/service-role/AWSLambdaBasicExecutionRole-161133b3-bf33-44a3-a5ab-c1f0cf64b44c",]
    path = "/service-role/"
    assume_role_policy = data.aws_iam_policy_document.coachx_lambda_role_policy.json
    }