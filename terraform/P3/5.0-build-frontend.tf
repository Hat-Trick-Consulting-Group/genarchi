resource "local_file" "api_config" {
  filename = "../../frontend/.env.production"
  content  = <<-EOT
    VITE_API_URL = "${aws_apigatewayv2_stage.prod.invoke_url}"
  EOT
}

resource "null_resource" "install_nodejs" {
  depends_on = [local_file.api_config]

  provisioner "local-exec" {
    command = <<-EOT
      # Check if Node.js is already installed
      if (-not (Test-Path "$env:ProgramFiles\nodejs\node.exe")) {
        # Download and install Node.js
        winget install --uninstall-previous OpenJS.NodeJS
      } else {
          Write-Host "Node.js is already installed."
      }
    EOT

    interpreter = ["PowerShell", "-Command"]
  }
}

resource "null_resource" "build_frontend" {
  depends_on = [null_resource.install_nodejs]
  triggers = {
    build_trigger = "../../frontend/.env.production"
  }

  provisioner "local-exec" {
    command = "npm install vite@latest && npm install npm install && npm run build"
    working_dir = "../../frontend/"
  }
}
