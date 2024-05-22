#coachx AUTH SERVICE FUCNTION

resource "aws_lambda_function" "coachx-auth" {
    function_name = "dev-coachx-auth"
    s3_bucket = var.BUILD_BUCKET_NAME
    s3_key = "auth-service/dev-coachx-auth.zip"
    handler = "dist/lambda.handler"
    runtime = "nodejs20.x"
    role = var.AUTH_IAM_ROLE_ARN
    timeout = 90 #value is in seconds
    
    ephemeral_storage {
      size = 512 #value is in mb
    }

    environment {
      variables = {
        "AMPLITUDE_LOGIN_EVENT_URL" = var.AMPLITUDE_LOGIN_EVENT_URL
        "ASSISTANT_ID" = var.ASSISTANT_ID
        "ASSISTANT_URL" = var.ASSISTANT_URL
        "COOKIE_DOMAIN" = var.COOKIE_DOMAIN
        "ENCRYPTION" = var.ENCRYPTION
        "ENV" = var.ENV
        "GOAL_SUBMISSION_WINDOW_LENGTH" = var.GOAL_SUBMISSION_WINDOW_LENGTH
        "MONGODB_DB_NAME" = var.MONGODB_DB_NAME
        "MONGODB_URL" = var.MONGODB_URL
        "OPENAI_API_KEY" = var.OPENAI_API_KEY
        "POPULATE_DB_ENUMS" = var.POPULATE_DB_ENUMS
        "SECRET_KEY" = var.SECRET_KEY
        "SEND_EMAIL_URL" = var.SEND_EMAIL_URL
        "UI_URL" = var.UI_URL
        "BUCKET_ACCESS_KEY_ID" = var.ACCESS_KEY_AWS
        "BUCKET_SECRET_ACCESS_KEY" = var.SECRET_KEY_AWS
        "BUCKET_REGION" = var.REGION_AWS
        "BUCKET_FOLDER_NAME" = var.BUCKET_FOLDER_NAME
        "BUCKET_NAME" = var.BUCKET_NAME

      }
    }
    tags = {
      "ENV" = "DEV"
    }
    
}


resource "aws_lambda_function_url" "coachx-auth-function-url" {
    function_name = aws_lambda_function.coachx-auth.function_name
    authorization_type = "NONE"
    invoke_mode = "BUFFERED"
}

#coachx EMAIL SERVICE FUCNTION

resource "aws_lambda_function" "coachx-email-function" {
    function_name = "dev-coachx-email-service"
    s3_bucket = var.BUILD_BUCKET_NAME
    s3_key = "email-service/dev-coachx-email-service.zip"
    handler = "dist/src/lambda.handler"
    runtime = "nodejs20.x"
    role = "arn:aws:iam::04XXXXXX****9:role/service-role/coachx-email-service-role-wy9z8k03" 
    timeout = 30 #value is in seconds
    ephemeral_storage {
      size = 512 #value is in mb
    }

    environment {
      variables = {
        "ACCESS_KEY_AWS" = var.ACCESS_KEY_AWS
        "ENV" = var.ENV
        "REGION_AWS" = var.REGION_AWS
        "SECRET_KEY_AWS" = var.SECRET_KEY_AWS
      }
    }
    tags = {
      "ENV" = "DEV"
    }
    
}

# coachx ANALYTICS SERVICE FUNCTION

resource "aws_lambda_function" "coachx-analytics-function" {
    function_name = "dev-coachx-analytics"
    s3_bucket = var.BUILD_BUCKET_NAME
    s3_key = "analytics-service/dev-coachx-analytics.zip"
    handler = "dist/src/lambda.handler"
    runtime = "nodejs20.x"
    role = "arn:aws:iam::0XXX*******9:role/service-role/coachx-analytics-role-xgiqfyhi" #aws_iam_role.coachx_analytics_service_role.arn
    timeout = 30 #value is in seconds
    ephemeral_storage {
      size = 512 #value is in mb
    }

    environment {
      variables = {
        "AMPLITUDE_API_KEY" = var.AMPLITUDE_API_KEY
        "ENV" = var.ENV
      }
    }
    tags = {
      ENV = "DEV"
    }
    
}

#coachx ASSISTANT SERVICE FUNCTION

resource "aws_lambda_function" "coachx-assistant-function" {
    function_name = "dev-coachx-assistant-service"
    s3_bucket = var.BUILD_BUCKET_NAME
    s3_key = "assistant-service/dev-coachx-assistant-service.zip"
    handler = "dist/lambda.handler"
    runtime = "nodejs20.x"
    role = "arn:aws:iam::0XXXXXX******9:role/service-role/dev-coachx-assistant-service-role-sji7hm8l" #aws_iam_role.coachx_assistant_service_role.arn
    timeout = 30 #value is in seconds
    tags = {
      "ENV" = "DEV"
    }
    ephemeral_storage {
      size = 512 #value is in mb
    }

    environment {
      variables = {
        "OPENAI_API_KEY" = var.OPENAI_API_KEY
        "SMART_GOALS_ASSISTANT_ID" = var.SMART_GOALS_ASSISTANT_ID
        "OPENAI_MODEL" = var.OPENAI_MODEL
        "ENV" = var.ENV
      }
    }    
}


