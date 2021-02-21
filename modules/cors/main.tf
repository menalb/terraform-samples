module "cors" {
  # import
  source = "./cors-module"

  # parameters
  resource_id = aws_api_gateway_resource.api_resource.id
  api_id      = aws_api_gateway_rest_api.api.id
}
