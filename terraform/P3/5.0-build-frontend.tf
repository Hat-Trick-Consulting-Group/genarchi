resource "local_file" "api_config" {
  filename = "../../frontend/.env.production"
  content  = <<-EOT
    VITE_API_URL = "${aws_apigatewayv2_stage.prod.invoke_url}"
  EOT
}

resource "null_resource" "build_frontend" {
  triggers = {
    build_trigger = "../../frontend/.env.production"
  }

  provisioner "local-exec" {
    command = "npm run build"
    
    working_dir = "../../frontend/"
  }

  depends_on = [local_file.api_config]
}
