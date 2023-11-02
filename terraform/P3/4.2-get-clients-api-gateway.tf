resource "aws_apigatewayv2_integration" "tf-get-clients" {
  api_id = aws_apigatewayv2_api.hat-trick-crm-api.id

  integration_uri    = aws_lambda_function.tf-get-clients.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "get_tf-get-clients" {
  api_id = aws_apigatewayv2_api.hat-trick-crm-api.id

  route_key = "GET /get-clients"
  target    = "integrations/${aws_apigatewayv2_integration.tf-get-clients.id}"
}

resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.tf-get-clients.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.hat-trick-crm-api.execution_arn}/*/*"
}

output "get-clients_base_url" {
  value = aws_apigatewayv2_stage.prod.invoke_url
}