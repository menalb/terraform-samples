# API
resource "aws_api_gateway_rest_api" "api" {
  name        = "greetings"
  description = "Hello World"
}

# endpoint
resource "aws_api_gateway_resource" "gs" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "greetings"
}

# GET
resource "aws_api_gateway_method" "gs_get" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.gs.id
  http_method   = "GET"
  authorization = "NONE"
}

# lambda integration
resource "aws_api_gateway_integration" "gs_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_method.gs_get.resource_id
  http_method             = aws_api_gateway_method.gs_get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.example.invoke_arn
}

# enable apigw to invoke lambda
resource "aws_lambda_permission" "apigw-get-gs" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.example.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}
