resource "aws_apigatewayv2_integration" "tf-add-client" {
  api_id = aws_apigatewayv2_api.hat-trick-crm-api.id

  integration_uri    = aws_lambda_function.tf-add-client.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "get_tf-add-client" {
  api_id = aws_apigatewayv2_api.hat-trick-crm-api.id

  route_key = "POST /add-client"
  target    = "integrations/${aws_apigatewayv2_integration.tf-add-client.id}"
}

resource "aws_lambda_permission" "tf-add-client_api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.tf-add-client.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.hat-trick-crm-api.execution_arn}/*/*"
}

output "add-clients_base_url" {
  value = aws_apigatewayv2_stage.prod.invoke_url
}