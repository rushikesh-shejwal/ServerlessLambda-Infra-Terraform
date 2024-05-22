terraform {
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "~> 5.40"
      }
    }

    required_version = ">= 1.2.0"
}

terraform {
  backend "s3" {
    bucket                  = "coachx-terraform-backend"
    key                     = "coachx"
    region                  = "ap-south-1"
  }
}

provider "aws" {
  region = "ap-south-1"
}

resource "aws_s3_bucket" "build_bucket" {
    bucket = var.BUILD_BUCKET_NAME
}



resource "aws_route53_record" "route53_record" {
  name = module.coachx-api.aws_api_gateway_domain.domain_name
  type = "A"
  zone_id = "ASJHLXXXXXX***KJHCLKJ" # enter your route53 hosted zone id here

  alias {
    evaluate_target_health = false
    name = "${module.coachx-api.aws_api_gateway_domain.regional_domain_name}"
    zone_id = "${module.coachx-api.aws_api_gateway_domain.regional_zone_id}"
  }
}

module "coachx-api" {
  source = "./modules/api-gateway"
  LAMBDA_COACHX_AUTH_INVOKE_ARN = module.coachx-lambda.auth-invoke-arn
  STAGE_NAME = var.STAGE_NAME
  CERTIFICATE_ARN = var.CERTIFICATE_ARN
}

module "coachx-lambda" {
  source = "./modules/lambda-function"
  AMPLITUDE_LOGIN_EVENT_URL = var.AMPLITUDE_LOGIN_EVENT_URL
  ASSISTANT_ID = var.ASSISTANT_ID
  ASSISTANT_URL = var.ASSISTANT_URL
  COOKIE_DOMAIN = var.COOKIE_DOMAIN
  ENCRYPTION = var.ENCRYPTION
  ENV = var.ENV
  GOAL_SUBMISSION_WINDOW_LENGTH = var.GOAL_SUBMISSION_WINDOW_LENGTH
  MONGODB_DB_NAME = var.MONGODB_DB_NAME
  MONGODB_URL = var.MONGODB_URL
  OPENAI_API_KEY = var.OPENAI_API_KEY
  POPULATE_DB_ENUMS = var.POPULATE_DB_ENUMS
  SECRET_KEY = var.SECRET_KEY
  SEND_EMAIL_URL = var.SEND_EMAIL_URL
  UI_URL = var.UI_URL
  BUILD_BUCKET_NAME = var.BUILD_BUCKET_NAME
  ACCESS_KEY_AWS = var.ACCESS_KEY_AWS
  AMPLITUDE_API_KEY = var.AMPLITUDE_API_KEY
  SECRET_KEY_AWS = var.SECRET_KEY_AWS
  REGION_AWS = var.REGION_AWS
  AUTH_IAM_ROLE_ARN = module.coachx-iam.auth-iam.arn
  BUCKET_FOLDER_NAME = var.BUCKET_FOLDER_NAME
  BUCKET_NAME = var.BUCKET_NAME
  SMART_GOALS_ASSISTANT_ID = var.SMART_GOALS_ASSISTANT_ID
  OPENAI_MODEL = var.OPENAI_MODEL

}

module "coachx-iam" {
  source = "./modules/iam"

}


# Frontend 

resource "aws_s3_bucket" "frontend_bucket" {
  bucket = "coachx-frontend"
}

resource "aws_cloudfront_origin_access_control" "coachx_origin_access" {
  name = aws_s3_bucket.frontend_bucket.bucket_regional_domain_name 
  origin_access_control_origin_type = "s3"
  signing_behavior = "always"
  signing_protocol = "sigv4"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  aliases = [ "dev.coachx.com", ]
  comment = "dev"
  default_root_object = "index.html"
  origin {
    domain_name = aws_s3_bucket.frontend_bucket.bucket_regional_domain_name 
    origin_id = aws_s3_bucket.frontend_bucket.bucket_regional_domain_name
    connection_attempts = 3
    connection_timeout = 10
    origin_access_control_id = aws_cloudfront_origin_access_control.coachx_origin_access.id
    origin_path = "/dev"
    

  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }    
  }
  default_cache_behavior {
    cached_methods = [ "GET", "HEAD" ]
    target_origin_id = "coachx-frontend.s3.ap-south-1.amazonaws.com"
    viewer_protocol_policy = "allow-all"
    allowed_methods = [ "GET", "HEAD" ]
    cache_policy_id = "413**2d-6df8-4XX**3-9df3-4b5a84be39ad"
    compress = true
    response_headers_policy_id = "60669652-455b-4ae9-85a4-c4c02393f86c"
  }

  viewer_certificate {
    cloudfront_default_certificate = false
    acm_certificate_arn = var.US_EAST_1_CERTIFICATE_ARN #this ACM arn is in us-east-1 only
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method = "sni-only"
  }
  enabled = true
  is_ipv6_enabled = true

  custom_error_response {
    error_caching_min_ttl = 10
    error_code = 403
    response_code = 200
    response_page_path = "/index.html"
  }

}




