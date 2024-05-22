resource "aws_api_gateway_rest_api" "auth-rest-api" {
    name = "dev-coachx-auth"
    
    endpoint_configuration {
      types = ["REGIONAL"]
    }
}

resource "aws_api_gateway_resource" "proxy_resource" {
  parent_id = aws_api_gateway_rest_api.auth-rest-api.root_resource_id
  path_part = "{proxy+}"
  rest_api_id = aws_api_gateway_rest_api.auth-rest-api.id 
}

resource "aws_api_gateway_method" "api_gateway_proxy_method" {
  http_method = "ANY"
  resource_id = aws_api_gateway_resource.proxy_resource.id
  rest_api_id = aws_api_gateway_rest_api.auth-rest-api.id
  authorization = "NONE"
  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "lambda_integration" {
  cache_key_parameters = []
  content_handling = "CONVERT_TO_TEXT"
  request_parameters = {}
  request_templates = {}
  http_method = aws_api_gateway_method.api_gateway_proxy_method.http_method
  resource_id = aws_api_gateway_resource.proxy_resource.id
  rest_api_id = aws_api_gateway_rest_api.auth-rest-api.id
  integration_http_method = "POST"
  cache_namespace = aws_api_gateway_resource.proxy_resource.id
  type = "AWS_PROXY"
  uri = var.LAMBDA_COACHX_AUTH_INVOKE_ARN
}

resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.auth-rest-api.id
}

resource "aws_api_gateway_stage" "api_stage" {
  stage_name = var.STAGE_NAME
  rest_api_id = aws_api_gateway_rest_api.auth-rest-api.id
  deployment_id = aws_api_gateway_deployment.api_deployment.id
}

resource "aws_api_gateway_domain_name" "MyDomain" {
  regional_certificate_arn = var.CERTIFICATE_ARN
  domain_name = "dev-api.coachx.com"
  endpoint_configuration {
    types = [ "REGIONAL" ]
  }
}

resource "aws_api_gateway_base_path_mapping" "custome_domain_mapping" {
  domain_name = aws_api_gateway_domain_name.MyDomain.id
  api_id = aws_api_gateway_rest_api.auth-rest-api.id
  stage_name = aws_api_gateway_stage.api_stage.stage_name
}
