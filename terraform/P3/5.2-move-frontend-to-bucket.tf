resource "aws_s3_object" "static_html" {
  bucket = aws_s3_bucket.tf_front_end_bucket.id
  key    = "index.html"
  source = "../../frontend/dist/index.html"
  content_type = "text/html"

  depends_on = [null_resource.build_frontend, local_file.api_config]
}

resource "aws_s3_object" "vite_svg" {
  bucket = aws_s3_bucket.tf_front_end_bucket.id
  key    = "vite.svg"
  source = "../../frontend/dist/vite.svg"
  content_type = "text/html"

  depends_on = [null_resource.build_frontend, local_file.api_config]
}

resource "aws_s3_object" "index_js" {
  bucket = aws_s3_bucket.tf_front_end_bucket.id
  key    = "app-index.js"
  source = "../../frontend/dist/app-index.js"
  content_type = "application/javascript"

  depends_on = [null_resource.build_frontend, local_file.api_config]
}

output "front_end_website_url" {
  description = "S3 hosting URL (HTTP)"
  value = "http://${aws_s3_bucket.tf_front_end_bucket.bucket}.s3-website.${var.AWS_REGION}.amazonaws.com"
}
